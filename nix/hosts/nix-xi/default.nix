{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ 
    ./hardware-configuration.nix
  ];
  system.stateVersion = "24.11";
  
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  x86_64-linuxSystem.enable = true;

  hostname = {
    enable = true;
    name = "nix-xi";
  };
  
  commonBaseHome = {
    enable = true;
    name = "quinnherden";
  };
  nixosBaseHome = {
    enable = true;
    name = "quinnherden";
  };

  quinnherdenUser.enable = true;

  wifi.enable = true;
  openssh.enable = true;
  vpn-us-ga-285.enable = false;

  bluetooth.enable = true;

  keyd.enable = true;
  libinput.enable = true;

  i3.enable = true;
  redshift.enable = true;

  docker.enable = true;

  commonPackages.enable = true;
  linuxPackages.enable = true;

  ### extract ###

  boot.loader.grub.device = "/dev/nvme0n1";

  services.ollama = {
    enable = true;

    host = "0.0.0.0";
    port = 11434;
    openFirewall = true;

    acceleration = "cuda";

    loadModels = [
      codestral:22b
      deepseek-coder-v2:16b
      deepseek-r1:32b
      llama2:latest
      nomic-embed-text:v1.5
      starcoder2:15b
      
      gemma3:12b
      gemma3:27b
      mistral-small3.1:24b
      qwen3:30b
      qwen3:32b
    ];
  };

  services.open-webui = {
    enable = true;

    host = "0.0.0.0";
    port = 8080;
    openFirewall = true;

    stateDir = "/var/lib/open-webui";

    environment = {
      BYPASS_MODEL_ACCESS_CONTROL = "True";
    };
  };

  #####
  # GPU for Generative AI
  
  ## Enable OpenGL
  hardware.graphics.enable = true;

  ## Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
  };

  nixpkgs.config.allowUnfreePredicate = pkg: 
  builtins.elem (lib.getName pkg) [ "cuda_cccl" "cuda_cudart" "cuda_nvcc" "libcublas" "nvidia-settings" "nvidia-x11" ]; 
  #####

}
