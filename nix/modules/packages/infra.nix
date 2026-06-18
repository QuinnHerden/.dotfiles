{
  common =
    pkgs: with pkgs; [
      ansible
      awscli2
      kubectx
      kubernetes-helm
      packer
      opentofu
      tflint
    ];

  linux =
    pkgs: with pkgs; [
    ];

  linuxX86 =
    pkgs: with pkgs; [
      virtualbox
    ];

  darwin = {
    brews = [ ];
    casks = [
      "balenaetcher"
      "raspberry-pi-imager"
      "virtualbox"
    ];
    masApps = { };
  };
}
