{
  common = pkgs: with pkgs; [
  ];

  linux = pkgs: with pkgs; [
    obs-studio
    signal-desktop
  ];

  linuxX86 = pkgs: with pkgs; [
  ];

  darwin = {
    brews = [];
    casks = [
      "discord"
      "fathom"
      "loom"
      "obs"
      "signal"
      "vb-cable"
      "whatsapp"
    ];
    masApps = {};
  };
}
