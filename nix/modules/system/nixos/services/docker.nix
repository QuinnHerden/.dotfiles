{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    docker = {
      enable = lib.mkEnableOption "enables docker";
    };
  };
  
  config = lib.mkIf config.docker.enable {
    virtualisation.docker.enable = true;

  };

}
