{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    vpn-us-ga-285 = {
      enable = lib.mkEnableOption "enables vpn-us-ga-285";
    };
  };
  
  config = lib.mkIf config.vpn-us-ga-285.enable {
    networking.wg-quick.interfaces = let
      # [Interface] > PrivateKey
      int_private_key_file = "/etc/vpn-us-ga-285.key";
      # [Interface] > Address
      int_cidr_ipv4 = "10.2.0.2/32";

      # [Peer] > PublicKey
      peer_public_key = "vsquyHHSbv76cOqCMZCREGur05Mp5XM0lbCAzrGDs2w=";

      # [Peer] > AllowedIPs
      peer_allowed_cidr_ipv4 = "0.0.0.0/0";
      peer_allowed_cidr_ipv6 = "::/0";

      # [Peer] > Endpoint:port
      peer_ipv4 = "149.22.94.86";
      peer_port = 51820;

    in {
      wg0 = {
        address = [
          int_cidr_ipv4
        ];

        listenPort = peer_port;

        privateKeyFile = int_private_key_file;

        peers = [
          {
            allowedIPs = [
              peer_allowed_cidr_ipv4
              peer_allowed_cidr_ipv6
            ];
            publicKey = peer_public_key;
            endpoint = "${peer_ipv4}:${toString(peer_port)}";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  #
  };

}
