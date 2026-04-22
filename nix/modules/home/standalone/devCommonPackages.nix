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

    home.packages = import ../../packages/devCommon.nix pkgs;
  };

}
