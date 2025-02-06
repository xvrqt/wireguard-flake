{ config
, machines
, getClientPeers
, ...
}:
let
  peers = getClientPeers;
  machine = machines.archive;

  ip = machine.ip;
  port = machine.port;
  interface = machine.interface;
in
{
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

      inherit peers;
    };
  };
}
