{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    standaloneCommonPackages = {
      enable = lib.mkEnableOption "enables standaloneCommonPackages";
    };
  };

  config = lib.mkIf config.standaloneCommonPackages.enable {
    nixpkgs.config = {
      allowUnfree = true;
    };

    home.packages = import ../../packages/common.nix pkgs;
  };

}
