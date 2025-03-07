{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    driverUser = {
      enable = lib.mkEnableOption "enables driverUser";

      userName = lib.mkOption {
        default = "driver";
      };
    };
  };
  
  config = lib.mkIf config.driverUser.enable {
    users.users.${config.driverUser.userName} = {
      shell = pkgs.zsh;
      openssh.authorizedKeys.keyFiles = [];
      packages = with pkgs; [];
    };
  };

}