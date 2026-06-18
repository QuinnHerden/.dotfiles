{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    quinnherdenUser = {
      enable = lib.mkEnableOption "enables quinnherdenUser";
    };
  };

  config = lib.mkIf config.quinnherdenUser.enable {
    users.users."quinnherden" = {
      name = "quinnherden";
      home = "/home/quinnherden";

      isNormalUser = true;
      extraGroups = [
        "docker"
        "wheel" # sudo
      ];

      shell = pkgs.zsh;

      # Authorized SSH keys come from the private overlay (inputs.private), not
      # the public tree. See nix/private-stub for the generic fallback.
    };
  };

}
