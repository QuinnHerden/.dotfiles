{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    devCommonPackages = {
      enable = lib.mkEnableOption "enables devCommonPackages";
    };
  };

  config = lib.mkIf config.devCommonPackages.enable {
    nixpkgs.config = {
      allowUnfree = true;
    };

    programs.zsh.enable = true;

    environment.systemPackages = import ../../../../packages/devCommon.nix pkgs;
  };

}
