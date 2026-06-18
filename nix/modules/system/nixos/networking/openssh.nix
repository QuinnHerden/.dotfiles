{
  lib,
  config,
  ...
}:

{

  options = {
    openssh = {
      enable = lib.mkEnableOption "enables openssh";
    };
  };

  config = lib.mkIf config.openssh.enable {
    services.openssh = {
      enable = true;

      # Do not open port 22 on the public interface. SSH is reached over the
      # Tailscale interface only (the firewall module trusts tailscale0).
      openFirewall = false;

      settings = {
        # Key-only, no root: brute-force over the public net has no surface, and
        # these are physical workstations with console recovery if keys break.
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

  };

}
