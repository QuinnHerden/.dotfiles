# 1. Secret-blind Podman machine for dev boxes

Date: 2026-06-19

## Status

Accepted.

## Context

The dev container lets Claude run autonomously inside a box. We want Claude to be
able to spin up arbitrary containers reachable on the host (via published ports),
which means giving the box access to the podman daemon socket.

A confirmed escape (issue #191) showed why that is dangerous: the socket is
root-equivalent on the host runtime. From inside a box, container-root reached
the bind-mounted host podman socket, drove the daemon as a remote client, and
spawned a sibling container with `-v /Users/<me>:/host`. The original box never
saw `/Users`, but the daemon's VM did, so the sibling read `.aws`, `.gnupg`,
`.ssh`, `.claude.json`, and more. The mount restriction is enforced on the
original container, not on what the daemon will mount for new ones.

Constraints discovered while designing the fix:

- **macOS, applehv provider, podman 5.4.1.** Only one Podman machine can run at a
  time. A two-machine design (a sacrificial daemon VM running alongside the
  primary) is therefore infeasible here.
- `podman machine init` defaults to mounting `$HOME` (`/Users/<me>`) into the VM.
  That default mount is the root cause: it is what makes `/Users` visible to any
  container the daemon spawns.
- Required workflows that must keep working: bind a repo into the box, read the
  Claude knowledge library, share global Claude memory across boxes.

## Decision

Run a single Podman machine, initialized to mount **only** a narrow set of host
dirs instead of all of `$HOME`:

- `~/containers`: the boxes tree (each box is `~/containers/<name>`, its home).
- `~/.dotfiles/private/knowledge`: the Claude knowledge library, read-only.
- `~/.claude/memory`: shared global Claude memory.

Everything else under `~` (`.aws`, `.ssh`, `.gnupg`, `.claude.json`, the SSH key
in `~/.dotfiles/private/overlay`, etc.) is never mounted, so it is invisible to
the VM and to every container in it. A sibling container Claude spawns cannot
bind-mount a host path the VM cannot see. The escape is closed structurally, at
the VM boundary, rather than by filtering what the daemon is asked to mount.

`dev --vm-init` provisions the machine with exactly this volume set and then
runs an acceptance test (`-v /Users:/host` from a throwaway container must come
back empty); it fails loudly if the narrow volumes did not replace the default
`$HOME` mount.

The podman socket stays opt-in (`dev --sock on`), and `CONTAINER_HOST` is set by
the launcher only when the socket is actually mounted (it is no longer baked into
the image).

## Alternatives considered

- **Two-machine (dedicated sacrificial daemon VM).** The cleanest isolation: the
  box runs on the primary VM and drives a separate, `/Users`-blind `claude-vm`
  over `ssh://`, keeping creds in the primary VM out of sibling reach. Rejected:
  applehv allows only one running machine, so the box's VM and `claude-vm` cannot
  both run. Reconsider if we move to a provider that permits concurrent VMs.

- **Run the box on a `/Users`-blind VM with the creds dir narrow-mounted in.**
  Simpler plumbing, but the per-box creds dir then lives in the VM the box
  controls, so a spawned sibling could bind-mount and exfiltrate the long-lived
  gh/Claude tokens. Rejected in favor of keeping the surface minimal, though note
  the accepted residual below is the same class of exposure.

- **Socket-filtering proxy (deny bind mounts in create requests).** Off-the-shelf
  `docker-socket-proxy` filters by API route, not request body, so it cannot
  strip `HostConfig.Binds` from an otherwise-allowed `create`. A body-filtering
  proxy is a fragile hand-roll. Deferred as optional later hardening; the narrow
  VM mount makes it unnecessary for the crown-jewel exposure.

- **Podman-in-podman (no host socket).** Fully closes #191 but nested containers'
  ports cannot be published to the host at runtime, breaking the "reachable on
  the host" requirement. Rejected.

## Consequences

- Host crown-jewel secrets (`.aws`, `.ssh`, `.gnupg`, `.claude.json`, ...) are
  structurally unreachable from any container, including ones Claude spawns.
- **Accepted residual:** a sibling container can read what the VM *does* see:
  the box dirs and the read-only knowledge mount. Because the whole `~/containers`
  tree is mounted, a compromised box can read **every** box's gh/Claude tokens
  under `.dev-state`, not just its own. These are rotatable, scoped credentials,
  not the irreplaceable host secrets. Mitigate with short-lived/least-scope
  tokens; never put secrets in a box dir.
- Ports a spawned container publishes reach the host; bind them to `127.0.0.1`
  unless LAN/Tailscale exposure is intended, so a spawned container cannot become
  a network pivot.
- Re-provisioning the machine is destructive (drops its containers and images).
  `dev --vm-init` refuses to clobber an existing machine; remove it first.
- The host box dir is bind-mounted as `/home/dev`; repos live directly in
  `~/containers/<name>`. Binding an arbitrary host dir outside `~/containers`
  is no longer supported (by design; it would require the VM to see that path).
