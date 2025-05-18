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
    acceleration="cuda";
    environmentVariables = {
      OLLAMA_HOST = "0.0.0.0:11434";
    };

    loadModels = [
      llama2:latest
    ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      11434
    ];
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