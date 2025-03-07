{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    mainUsers = {
      enable = lib.mkEnableOption "enables mainUsers";

      userName = lib.mkOption {
        default = "driver";
      };
    };
  };
  
  config = lib.mkIf config.mainUsers.enable {
    users.users.${config.mainUsers.userName} = {
      shell = pkgs.zsh;
      openssh.authorizedKeys.keyFiles = [];
      packages = with pkgs; [];
    };
  };

}