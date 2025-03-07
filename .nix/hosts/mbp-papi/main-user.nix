{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    main-user = {
      enable = lib.mkEnableOption "enables main-user";

      userName = lib.mkOption {
        default = "driver";
      };
    };
  };
  
  config = lib.mkIf config.main-user.enable {
    users.users.${config.main-user.userName} = {
      shell = pkgs.zsh;
      openssh.authorizedKeys.keyFiles = [];
      packages = with pkgs; [];
    };
  };

}