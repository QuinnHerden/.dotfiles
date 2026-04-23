{
  common = pkgs: with pkgs; [
    nmap
    wireshark
  ];

  linux = pkgs: with pkgs; [
  ];

  linuxX86 = pkgs: with pkgs; [
  ];

  darwin = {
    brews = [];
    casks = [];
    masApps = {};
  };
}
