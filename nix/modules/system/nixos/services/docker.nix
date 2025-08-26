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

    virtualisation.docker = {
      enable = true;
      # run Docker daemon as non-root user
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    virtualisation.oci-containers.backend = "docker";

  };

}
