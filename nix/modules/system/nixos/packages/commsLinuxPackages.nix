{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    commsLinuxPackages = {
      enable = lib.mkEnableOption "enables commsLinuxPackages";
    };
  };

  config = lib.mkIf config.commsLinuxPackages.enable {
    environment.systemPackages =
      (import ../../../packages/commsLinux.nix pkgs) ++
      (lib.optionals pkgs.stdenv.isx86_64 (import ../../../packages/commsLinuxX86.nix pkgs));
  };

}
