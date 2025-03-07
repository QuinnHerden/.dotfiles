{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    driverUser = {
      enable = lib.mkEnableOption "enables driverUser";

      userName = lib.mkOption {
        default = "driver";
      };
    };
  };
  
  config = lib.mkIf config.driverUser.enable {
    users.users.${config.driverUser.userName} = {
      shell = pkgs.zsh;
      packages = with pkgs; [];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2aUAuv3nXZ2xUyydp6QA0zovy7L7iRlSC1ilxm37/tuva7kyJnMZPGmbpOM2vyp3fHOZpW0HV5nD72Q+4ofXHL8gTXhU0vqh2hIzyhFnwn6J/bsmrYu+3EEjzDR0GQFwlXTyBuX84paXHv5PN08/MTAgkdvt63VB0xsBMnQSqbHOpXzkm0Kja+aHGGEUdEXa5DrbcVc4pM+T9OutMd5tL1TSjod+obrxRSBFi2l0xZYdq+orLckrkpxKSjdnAUDxvGvHNsKkB9Y5EmokjGQkDhRL/UzhQ+FT+ffC/BNOAVCFyr7QcmYbrEfzoi9yRdKwRtAS+kk4eIqUGZVIRr+Rfw/8Ayk4jvBWYJXeIoegzcPoEjYI/yA/yzjUW29JAO9OqJDtDUa0J93RhVh0Ar1PAinPYMQp0X64bXogwFBF27fO+mQw+nar2zis4xckgQ2084+Olb4xWdROYqpYOtcQhwQqoH3bY9fGiHe9CNrifBkkmpYqdcG9DJ7chjXg90mI7Gd2M58bumxeoXZ/y6XJele7V4Im5Ep+Sem25jFplPcnpQzjoOOyKYp8L55N03YzmBPRrLmWLEnBNUJK5VpU6dPBERJT4/ihxfCNMPxQEnVDqCDUFGqzmIxRpj3Tl8TFmRDhfcUGj/H9If9C4mPVa9kt6dlc0eeEpB0E/rUOoWw== engineering@sculpted.io"
      ];
    };
  };

}