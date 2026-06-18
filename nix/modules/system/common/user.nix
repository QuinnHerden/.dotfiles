# Single source of truth for the primary user. Shared by the NixOS and darwin
# system layers (and the private overlay) so the username lives in one place per
# host instead of being hardcoded across modules.
{
  lib,
  ...
}:

{
  options.user = {
    enable = lib.mkEnableOption "the primary user";

    name = lib.mkOption {
      type = lib.types.str;
      default = "user";
      description = "Primary user's username.";
    };

    home = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Primary user's home directory; null derives the platform default.";
    };
  };
}
