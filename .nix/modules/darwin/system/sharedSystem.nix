{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    sharedSystem = {
      enable = lib.mkEnableOption "enables sharedSystem";
    };
  };
  
  config = lib.mkIf config.sharedSystem.enable {
    security.pki.certificateFiles = [];

    time.timeZone = "America/New_York";

    system.defaults.loginwindow = {
      # allow guest user account
      GuestEnabled = false;
    };

    system.defaults.LaunchServices = {
      # enable warning for untrusted apps
      LSQuarantine = true;
    };

    system.defaults.controlcenter = {
      BatteryShowPercentage = false;

      Bluetooth = true;
      NowPlaying = true;    

      FocusModes = false;
      Sound = false;
      AirDrop = false;
      Display = false;
    };

    system.defaults.menuExtraClock = {
      # date
      ShowDate = 1; # '1' =always
      ShowDayOfWeek = true;
      ShowDayOfMonth = true;

      # clock
      Show24Hour = true;
      ShowSeconds = false;
    };

    system.defaults.dock = {
      # dock location
      orientation = "bottom";
      autohide = true;

      # only show open apps
      static-only = true;

      # make hidden apps translucent
      showhidden = true;

      # dock icon size
      tilesize = 16;
      magnification = true;
      largesize = 64;
      
      # corner hover quick launch
      wvous-bl-corner = 1; # '1' = disabled
      wvous-br-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;

      # change desktop order
      mru-spaces = false;

      # disable animations
      expose-animation-duration = null;
    };

    system.defaults.finder = {
      # empty month-old trash
      FXRemoveOldTrashItems = true;

      # allow quitting finder
      QuitMenuItem = true;

      # enable visual desktop
      CreateDesktop = true;

      # display devices on desktop
      ShowHardDrivesOnDesktop = true;
      ShowExternalHardDrivesOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
      ShowMountedServersOnDesktop = true;

      # default finder folder
      NewWindowTarget = "Documents";

      # default finder view
      FXPreferredViewStyle = "clmv";

      # show hidden files
      AppleShowAllFiles = false;
      
      # show breadcrumb path
      ShowPathbar = true;

      # show item/disk status
      ShowStatusBar = true;

      # show full file path
      _FXShowPosixPathInTitle = true;

      # show extensions
      AppleShowAllExtensions = true;

      # folders sort first
      _FXSortFoldersFirst = false;
      _FXSortFoldersFirstOnDesktop = false;
    };

    system.defaults.screencapture = {
      # YYYY-MM-DD @ time in filename
      include-date = true;

      # delay save with preview
      show-thumbnail = false;
    };

    system.defaults.hitoolbox = {
      # what does the function key do
      AppleFnUsageType = "Do Nothing";
    };

    system.defaults.".GlobalPreferences" = {
      # mouse speed
      "com.apple.mouse.scaling" = 100.0;
    };
  };

}
