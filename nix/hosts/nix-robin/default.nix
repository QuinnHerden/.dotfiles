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
  
  networking = {
    hostName = "nix-robin";
  }
  
  users.users."quinnherden" = {
    name = "quinnherden";
    home = "/Users/quinnherden";
    
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    
    shell = pkgs.zsh;
    
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2aUAuv3nXZ2xUyydp6QA0zovy7L7iRlSC1ilxm37/tuva7kyJnMZPGmbpOM2vyp3fHOZpW0HV5nD72Q+4ofXHL8gTXhU0vqh2hIzyhFnwn6J/bsmrYu+3EEjzDR0GQFwlXTyBuX84paXHv5PN08/MTAgkdvt63VB0xsBMnQSqbHOpXzkm0Kja+aHGGEUdEXa5DrbcVc4pM+T9OutMd5tL1TSjod+obrxRSBFi2l0xZYdq+orLckrkpxKSjdnAUDxvGvHNsKkB9Y5EmokjGQkDhRL/UzhQ+FT+ffC/BNOAVCFyr7QcmYbrEfzoi9yRdKwRtAS+kk4eIqUGZVIRr+Rfw/8Ayk4jvBWYJXeIoegzcPoEjYI/yA/yzjUW29JAO9OqJDtDUa0J93RhVh0Ar1PAinPYMQp0X64bXogwFBF27fO+mQw+nar2zis4xckgQ2084+Olb4xWdROYqpYOtcQhwQqoH3bY9fGiHe9CNrifBkkmpYqdcG9DJ7chjXg90mI7Gd2M58bumxeoXZ/y6XJele7V4Im5Ep+Sem25jFplPcnpQzjoOOyKYp8L55N03YzmBPRrLmWLEnBNUJK5VpU6dPBERJT4/ihxfCNMPxQEnVDqCDUFGqzmIxRpj3Tl8TFmRDhfcUGj/H9If9C4mPVa9kt6dlc0eeEpB0E/rUOoWw== engineering@sculpted.io"
    ];
  };

  baseHome = {
    enable = true;
    name = "quinnherden";
  };

  linuxPackages.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    
    # require public key authentication for better security
    #settings.PasswordAuthentication = false;
    #settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "no";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

}

