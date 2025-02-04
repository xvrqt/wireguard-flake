# This flake collates all my host flakes together for convenienc0
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    agenix.url = "github:ryantm/agenix";
  };
  outputs =
    { nixpkgs, agenix, ... }:
    let
      machines = import ./machines.nix;

      servers = nixpkgs.lib.attrsets.filterAttrs (n: v: v.isServer == true) machines;
      clients = nixpkgs.lib.attrsets.filterAttrs (n: v: v.isServer == false) machines;
      peersAttrSet = builtins.mapAttrs
        (n: v:
          let
            # Make the last octet a '0' 
            ip = "${(builtins.substring 0 ((builtins.stringLength v.ip) - 1) v.ip)}0";
          in
          {
            endpoint = v.endpoint;
            publicKey = v.publicKey;
            allowedIPs = [ "${ip}/24" ];
          })
        servers;
      clientsAttrSet = builtins.mapAttrs
        (n: v:
          {
            publicKey = v.publicKey;
            allowedIPs = [ "${v.ip}/32" ];
          })
        clients;
      peersList = map
        (key: peersAttrSet.${key})
        (builtins.attrNames peersAttrSet);
      clientsList = map
        (key: clientsAttrSet.${key})
        (builtins.attrNames clientsAttrSet);
      getServerPeers = peersList;
      getClientPeers = clientsList;
    in
    {
      nixosModules = {
        # Import me first to setup Agenix and common stuff
        default = { lib, pkgs, ... }: {
          imports = [
            (import ./common.nix { inherit lib pkgs agenix; })
            agenix.nixosModules.default
          ];
        };
        # Import the correct machine to configure Wireguard for it
        archive = { config, ... }: {
          imports = [
            (import ./archive.nix { inherit config machines getClientPeers; })
          ];
        };
        spark = { config, ... }: {
          imports = [
            (import ./spark.nix { inherit config machines getServerPeers; })
          ];
        };
        nyaa = { config, ... }: {
          imports = [
            (import ./nyaa.nix { inherit config machines getServerPeers; })
          ];
        };
      };
    };
}
