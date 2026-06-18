# NixOS primary user, built from the shared `user` option (see
# modules/system/common/user.nix). Authorized SSH keys come from the private
# overlay (inputs.private), not this module.
{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.user;
in

{
  config = lib.mkIf cfg.enable {
    users.users.${cfg.name} = {
      inherit (cfg) name;
      home = if cfg.home != null then cfg.home else "/home/${cfg.name}";

      isNormalUser = true;
      extraGroups = [
        "docker"
        "wheel" # sudo
      ];

      shell = pkgs.zsh;
    };
  };
}
