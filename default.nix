{ machines, ... }:
let
  ip = machine.wireguard.ip;
  port = machine.wireguard.port;
  interface = machine.wireguard.interface;
in
{
  # enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = "enp0s31f6";
  networking.nat.internalInterfaces = [ "${interface}" ];
  networking.firewall = {
    allowedUDPPorts = [ 53 port ];
    allowedTCPPorts = [ 53 ];
  };

  networking.wireguard.interfaces = {
    # "wg0" is the network interface n.net. You can n.net the interface arbitrarily.
    irlqt-secured = {
      ips = [ "${ip}/24" ];
      listenPort = port;
      privateKeyFile = "/home/crow/wg-keys/archive";

      peers = [
        machine.wireguard.peers.spark
        {
          publicKey = "ma+LA7hdq9ayI26Ev0w0MyNFmSUNfBbsDU7+3/85Tis=";
          allowedIPs = [ "2.2.2.3/32" ];
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
