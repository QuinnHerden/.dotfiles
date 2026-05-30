{
  lib,
  config,
  pkgs,
  ...
}:

let
  pkg = import ../../packages/ops.nix;
in

{

  options.opsPackages = {
    enable = lib.mkEnableOption "enables opsPackages";
    enableGui = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include GUI/desktop packages (disable for headless/container environments)";
    };
    enableHeavy = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include heavy tools like ffmpeg, ollama, pandoc (disable for lightweight/container environments)";
    };
  };

  config = lib.mkIf config.opsPackages.enable {
    home.packages =
      (pkg.common pkgs) ++
      (pkg.linux pkgs) ++
      (lib.optionals pkgs.stdenv.isx86_64 (pkg.linuxX86 pkgs)) ++
      (lib.optionals config.opsPackages.enableHeavy (pkg.heavy pkgs)) ++
      (lib.optionals config.opsPackages.enableGui (pkg.linuxGui pkgs));
  };

}
