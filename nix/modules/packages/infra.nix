{
  common =
    pkgs: with pkgs; [
      ansible
      ansible-lint
      hcloud
      kubectx
      kubernetes-helm
      opentofu
      rclone
      restic
      spacectl
      tflint
    ];

  heavy =
    pkgs: with pkgs; [
      awscli2
      packer
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
