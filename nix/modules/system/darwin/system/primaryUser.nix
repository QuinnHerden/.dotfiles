# nix-darwin primary user, built from the shared `user` option (see
# modules/system/common/user.nix).
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
      home = if cfg.home != null then cfg.home else "/Users/${cfg.name}";

      shell = pkgs.zsh;
    };
  };
}
