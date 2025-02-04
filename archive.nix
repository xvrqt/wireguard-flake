{ lib, pkgs, config, agenix, machines, ... }:
let
  machine = machines.archive;
  ageKey = "/key/agenix/keys/archive.agenix";

  ip = machine.ip;
  port = machine.port;
  interface = machine.interface;
in
{
  # Tell Agenix where the key that can decrypt the secrets is located 
  age.identityPaths = [ ageKey ];
  age.secrets.wgPrivateKey = {
    # The secret file that will be decrypted
    file = ./secrets/archive.wg.key;
    # Folder to decrypt into (ocnfig.age.secretDir/'path')
    name = "wg/private.key";

    # File Permissions
    mode = "400";
    owner = "root";

    # Symlink from the secretDir to the 'path'
    # Doesn't matter since both are in the same partition
    symlink = true;
  };

  # Servers need to enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = "enp0s31f6";
  networking.nat.internalInterfaces = [ "${interface}" ];
  # Open our firewall that allows us to connect
  networking.firewall = {
    allowedUDPPorts = [ port ];
  };

  networking.wireguard.interfaces = {
    # Interface names are arbitrary
    "${interface}" = {
      ips = [ "${ip}/24" ];
      listenPort = port;
      privateKeyFile = config.age.secrets.wgPrivateKey.path;

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
