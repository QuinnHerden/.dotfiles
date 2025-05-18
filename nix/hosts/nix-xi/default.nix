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
  
  boot.loader.grub.device = "/dev/nvme0n1";

  hostname = {
    enable = true;
    name = "nix-xi";
  };
  
  openssh.enable = true;

  quinnherdenUser.enable = true;

  baseHome = {
    enable = true;
    name = "quinnherden";
  };

  services.tailscale = {
    enable = true;
  };

  services.ollama = {
    enable = true;

    host = "0.0.0.0";
    port = 11434;
    openFirewall = true;

    acceleration = "cuda";

    loadModels = [
      llama2:latest
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