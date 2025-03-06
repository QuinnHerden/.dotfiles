{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.main-user;
in

{
  options.main-user = {
    enable = lib.mkEnableOption "enable user module";

    userName = lib.mkOption {
      default = "driver";
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