{
  lib,
  config,
  ...
}:

{

  options = {
    nextcloud = {
      enable = lib.mkEnableOption "enables the Nextcloud desktop client";
    };
  };

  config = lib.mkIf config.nextcloud.enable {
    # The client keeps its login in the Secret Service; without a keyring it
    # asks for the app password on every start. gnome-keyring hooks the `login`
    # PAM stack, which the display manager includes, so a password login unlocks
    # it. A U2F-only login captures no password and leaves it locked.
    services.gnome.gnome-keyring.enable = true;

    home-manager.users.${config.user.name}.services.nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
  };

}
