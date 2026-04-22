{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    commonPackages = {
      enable = lib.mkEnableOption "enables commonPackages";
    };
  };

  config = lib.mkIf config.commonPackages.enable {
    nixpkgs.config = {
      allowUnfree = true; # accept paid licenses
    };

    programs.zsh.enable = true; # install zsh shell

    environment.systemPackages =
      (import ../../../../packages/common.nix pkgs) ++
      (lib.optionals pkgs.stdenv.isx86_64 (import ../../../../packages/x86Common.nix pkgs));
  };

}
