{ lib, pkgs, config, agenix, machines, ... }:
let
  # Where the key that can be used to decrypt the file is located
  ageKey = "/key/agenix/keys/spark.agenix";

  # The machine to configure Wireguard for
  machine = machines.spark;
  # The list of machines to connect to
  # Since this is a client, only connect to servers
  servers = lib.attrsets.filterAttrs (n: v: v.isServer == true) machines;

  peersAttrSet = builtins.mapAttrs
    (n: v:
      let
        # Make the last octet a '0' 
        ip = builtins.concatString [
          (builtins.substring 0 ((builtins.stringLength v.ip) - 1))
          "0"
        ];
      in
      {
        endpoint = v.endpoint;
        publicKey = v.publicKey;
        allowedIPs = [ "${ip}/24" ];
      })
    servers;

  peers = map
    (key: peersAttrSet.${key})
    (builtins.attrNames peersAttrSet);

  # Convenience
  ip =
    machine.ip;
  port = machine.port;
  interface = machine.interface;
in
{
  # Tell Agenix where the key that can decrypt the secrets is located 
  age.identityPaths = [ ageKey ];
  age.secrets.wgPrivateKey = {
    # The secret file that will be decrypted
    file = ./secrets/spark.wg.key;
    # Folder to decrypt into (ocnfig.age.secretDir/'path')
    name = "wg/private.key";

    # File Permissions
    mode = "400";
    owner = "root";

    # Symlink from the secretDir to the 'path'
    # Doesn't matter since both are in the same partition
    symlink = true;
  };

  # Open our firewall that allows us to connect
  networking.firewall = {
    allowedUDPPorts = [ port ];
  };

  # Setup the Wireguard Network Interface
  networking.wireguard.interfaces = {
    # Interface names are arbitrary
    "${interface}" = {
      ips = [ "${ip}/32" ];
      listenPort = port;
      privateKeyFile = config.age.secrets.wgPrivateKey.path;
      inherit peers;
    };
  };
}
