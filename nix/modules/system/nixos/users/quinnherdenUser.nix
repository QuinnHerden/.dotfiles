{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    quinnherdenUser = {
      enable = lib.mkEnableOption "enables quinnherdenUser";
    };
  };
  
  config = lib.mkIf config.quinnherdenUser.enable {
    users.users."quinnherden" = {
      name = "quinnherden";
      home = "/Users/quinnherden";
      
      isNormalUser = true;
      extraGroups = [
        "docker"
        "wheel" #sudo
      ];
      
      shell = pkgs.zsh;
      
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDdFfEjaPcB7Pk1s6gR1mIOVqAgeZ3P1KUIJR4698mdQ"
      ];
    };
  };

}
