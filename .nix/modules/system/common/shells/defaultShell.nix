{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    defaultShell = {
      enable = lib.mkEnableOption "enables defaultShell";
    };
  };
  
  config = lib.mkIf config.defaultShell.enable {
    users.defaultUserShell = pkgs.zsh;
  };
}