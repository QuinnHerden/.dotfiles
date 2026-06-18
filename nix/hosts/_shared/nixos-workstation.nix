# Shared base for the NixOS workstations (nix-box, nix-dots). Holds the common
# system, home, user, and service toggles. Each host imports this and sets only
# its hostname, its hardware config, and its package-category overrides.
_:

{
  system.stateVersion = "24.11";
  x86_64-linuxSystem.enable = true;

  hostname.enable = true;

  commonBaseHome.enable = true;
  linuxBaseHome.enable = true;

  # The username is set per host (see hosts/<name>); the templates leave it at
  # the generic default.
  user.enable = true;

  pam.enable = true;

  wifi.enable = true;
  openssh.enable = true;
  firewall.enable = true;
  services.tailscale.enable = true;

  bluetooth.enable = true;

  keyd.enable = true;
  libinput.enable = true;

  i3.enable = true;
  redshift.enable = true;

  docker.enable = true;
}
