{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    hostname = {
      enable = lib.mkEnableOption "enables hostname";

      name = lib.mkOption {
        default = "nix";
      };
    };
  };
  
  config = lib.mkIf config.hostname.enable {
    networking = {
      hostName = "${config.hostname.name}";
    };
  };

}