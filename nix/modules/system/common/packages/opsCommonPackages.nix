{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    opsCommonPackages = {
      enable = lib.mkEnableOption "enables opsCommonPackages";
    };
  };

  config = lib.mkIf config.opsCommonPackages.enable {
    environment.systemPackages =
      (import ../../../packages/opsCommon.nix pkgs) ++
      (lib.optionals pkgs.stdenv.isx86_64 (import ../../../packages/opsCommonX86.nix pkgs));
  };

}
