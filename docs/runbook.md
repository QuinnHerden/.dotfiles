# Runbook

Operator how-to: reinstalling a machine, adding a machine, dev boxes, and forking. For the design behind any of this, see [architecture.md](architecture.md). Back to the [README](../README.md).

## Install (reinstalling on a new machine)

This is the runbook for setting up a machine, written for me. The host config is keyed by hostname, so the hostname must match an entry before `.switch` will resolve.

### 1. Prerequisites

On macOS, install Nix:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

On NixOS, get online and make git available:

```bash
nmcli d wifi list
nmcli d wifi connect {ssid} --ask
nix-shell -p git
```

On generic Linux (non-NixOS), set the hostname and make sure curl is present:

```bash
sudo hostname {hostname}        # e.g. kali-bug
sudo apt install curl           # or your distro's equivalent
```

### 2. Clone

The repo has a private submodule. A plain clone works (the flake falls back to the public stub), but as the owner, init the submodule so the real identifiers load:

```bash
cd ~/
git clone --recurse-submodules https://github.com/QuinnHerden/.dotfiles.git
# or, after a plain clone:
git submodule update --init
```

Without the private overlay (`private/overlay`), the NixOS rebuild scripts warn and fall back to an empty authorized-SSH-keys stub.

### 3. Init

Run the bootstrap script. It is not idempotent in one pass; run it repeatedly until it exits 0.

```bash
sh ~/.dotfiles/files/scripts/.init
```

### 4. Set hostname

The hostname selects which host config to sync to.

```bash
sudo hostname {hostname}        # NixOS / macOS
```

On generic Linux this is already done from step 1. There, `.switch` resolves the `homeConfigurations` entry from `$(whoami)@$(hostname)`.

### 5. Switch

Apply the config:

```bash
sh ~/.dotfiles/files/scripts/.switch
```

## Add a machine

Hosts are data. Each machine is an entry in the `hosts` attrset in `nix/flake.nix`, mapped through `mkHost`. Adding a machine means adding an entry plus its host directory; you never copy a builder block. See [architecture.md](architecture.md#flake-and-the-host-matrix) for how the matrix works.

Generic starting points live in `nix/hosts/_template/`, one directory per platform (each holds a `default.nix`, so copying the directory needs no rename):

| Directory | For |
|------|-----|
| `nixos/` (`default.nix` + `hardware-configuration.nix`) | A NixOS host |
| `darwin/` | A nix-darwin host |
| `home/` | A standalone home-manager host |

### NixOS host

1. Copy `nix/hosts/_template/nixos/` to `nix/hosts/<name>/`.
2. Replace the stub hardware config with real output:
   ```bash
   nixos-generate-config --show-hardware-config > nix/hosts/<name>/hardware-configuration.nix
   ```
3. In `nix/hosts/<name>/default.nix`, set `hostname.name`, `user.name`, and the package toggles.
4. Add an entry under `hosts.nixos` in `nix/flake.nix`:
   ```nix
   <name> = {
     builder = "nixos";
     hostPath = ./hosts/<name>;
   };
   ```
5. Set the system hostname to `<name>` (see step 4 of the install runbook).
6. Switch:
   ```bash
   sh ~/.dotfiles/files/scripts/.switch
   ```

> **Bootstrap login:** authorized SSH keys come from the owner's private overlay, which a fork does not have, so the template sets a placeholder `initialPassword` (`changeme`) on the primary user to keep a fresh build reachable on first boot. Change it before any real use: add your own SSH key via a private overlay, or replace it with a `hashedPassword` (`mkpasswd -m sha-512`). The owner's real hosts do not set it.

### Darwin host

Copy `nix/hosts/_template/darwin/` to `nix/hosts/<name>/`, set `hostname.name`, `user.name`, and `time.timeZone`, then add an entry under `hosts.darwin` with `builder = "darwin"` and `hostPath = ./hosts/<name>`.

### Standalone home-manager host

Copy `nix/hosts/_template/home/` to `nix/hosts/<name>/`, set `home.username` and `home.homeDirectory` in its `default.nix`, then add an entry under `hosts.home` with `builder = "home"`, the right `system` (e.g. `aarch64-linux`), and `hostPath = ./hosts/<name>`.

The username is set in one place per host: `user.name` for NixOS/darwin (the `user` option, which drives the system user, home directory, and home-manager user), and `home.username` for standalone home-manager hosts. Authorized SSH keys come from the private overlay, not the host file.

## Dev boxes (Podman)

A dev box is a persistent host dir, `~/containers/<name>`, mounted as the container's home. Repos go under `~/containers/<name>/repos`; per-box state (Claude creds, gh/git auth) persists in `.dev-state`. The Podman machine is provisioned to mount only `~/containers`, the Claude knowledge dir, and the Claude memory dir, never your home root, so host secrets stay unreachable from any container. The security rationale is [docs/decisions/0001-secret-blind-dev-vm.md](decisions/0001-secret-blind-dev-vm.md).

### Fresh setup

1. Install [Podman Desktop](https://podman-desktop.io/).
2. Provision the secret-blind machine (once). This creates the machine with the narrow mount set and runs the isolation acceptance test:
   ```bash
   dev --vm-init
   ```
3. Optional: let boxes spawn sibling containers via the podman socket:
   ```bash
   dev --sock on
   ```
4. Create a box:
   ```bash
   dev <name>
   ```

### Migration (existing users)

> **Breaking change.** The old `dev <name> <host-dir>` interface is gone, and per-box state moved from `~/.dev-containers/<name>` to `~/containers/<name>/.dev-state`. The old state is abandoned: re-authenticate `gh` and Claude in the new box.

The machine must be re-provisioned to drop the default `$HOME` mount that caused [#191](decisions/0001-secret-blind-dev-vm.md). This is destructive: it drops the current machine's containers and images.

1. Remove the current machine:
   ```bash
   podman machine stop podman-machine-default && podman machine rm podman-machine-default
   ```
2. Provision the secret-blind machine (runs the isolation acceptance test):
   ```bash
   dev --vm-init
   ```
3. Optional: re-enable the socket so boxes can spawn containers:
   ```bash
   dev --sock on
   ```
4. Create a box:
   ```bash
   dev <name>
   ```
5. Inside the box, re-authenticate (old `~/.dev-containers/<name>` auth does not carry over):
   ```bash
   gh auth login
   claude    # sign in when prompted
   ```

## Fork this

The public flake builds standalone against an in-repo stub, so a fork needs no private access. The [architecture doc](architecture.md#publicprivate-seam) explains the seam; the operator steps are below.

To supply your own last mile, pick one:

- Edit the public modules directly.
- Point `inputs.private` at your own overlay.

A fork cannot clone the owner-only private submodule. A plain `git clone` (without `--recurse-submodules`) already leaves `private/` empty and builds clean against the stub; nothing dangles, because the `~/.claude/knowledge` link is created at activation only when `private/knowledge` is actually present. To drop the inherited submodule reference entirely:

```bash
git submodule deinit -f private && git rm -f private && rm -rf .git/modules/private
git commit -m "drop private submodule"
```

The template hosts (`hosts.nixos.template`, `hosts.darwin.template`, `hosts.home.template`) are built in CI to guarantee the public layer stays forkable.

### Residual owner-specific values

A few things still carry the owner's identity or preferences; change them when you fork:

- **CI build matrix** (`.github/workflows/ci.yml`): replace the owner-host entries (marked `OWNER HOSTS`) with your own. Keep the `template *` entries (marked `KEEP THESE`) — they are the check that proves your fork still builds standalone.
- **iTerm2 profile** (`files/home/iterm2/profile.json`): the profile `Name` is `quinnherden` and a `Working Directory` path is the owner's home (inert, since `Custom Directory` is `No`). Edit if you import this profile.
- **Timezone**: set `time.timeZone` per host (the templates default to `UTC`).
