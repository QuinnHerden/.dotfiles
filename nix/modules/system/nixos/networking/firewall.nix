{
  lib,
  config,
  ...
}:

{

  options = {
    firewall = {
      enable = lib.mkEnableOption "enables the firewall";
    };
  };

  config = lib.mkIf config.firewall.enable {
    networking.firewall = {
      enable = true;

      # Trust the Tailscale interface so services (SSH included) are reachable
      # over the tailnet but not the public interface. Only meaningful when
      # tailscale is enabled, so gate it on that.
      trustedInterfaces = lib.mkIf config.services.tailscale.enable [ "tailscale0" ];
    };
  };

}
