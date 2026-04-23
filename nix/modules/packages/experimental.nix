{
  common = pkgs: with pkgs; [
  ];

  linux = pkgs: with pkgs; [
  ];

  linuxX86 = pkgs: with pkgs; [
  ];

  darwin = {
    brews = [];
    casks = [
      "protege"
    ];
    masApps = {
      "QuikFlow" = 1626354390;
    };
  };
}
