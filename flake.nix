# This flake collates all my host flakes together for convenienc0
{
  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
      agenix.url = "github:ryantm/agenix";
    };
  outputs =
    { nixpkgs
    , agenix
    , ...
    } @ inputs:
    let
      machines = import ./machines.nix;
      # wgConfig = lib: name: isServer:
      #   let
      #     # Grab the machine's config
      #     machine = machines."${name}";
      #     # Grab all the other machine's configs
      #     other_machines = lib.attrsets.filterAttrs (n: v: n != name) machines;
      #   in
      #   { };
    in
    {
      nixosModules = {
        default = {
          imports = [ ./common.nix ];
        };
        archive = { lib, pkgs, config, ... }: {
          imports = [
            (import ./archive.nix { inherit lib pkgs config agenix machines; })
            (import ./common.nix { inherit lib pkgs; })
            agenix.nixosModules.default
          ];
        };
        # let
        #   port = machine.port;
        #   machine = machines.archive;
        #   interface = machine.interface;
        # in
        # {
        #   networking.nat.enable = true;
        #   networking.nat.externalInterface = "enp0s31f6";
        #   networking.nat.internalInterfaces = [ "${interface}" ];
        #   networking.firewall = {
        #     allowedUDPPorts = [ port ];
        #   };
        #   networking.wireguard.interfaces = {
        #     # "wg0" is the network interface n.net. You can n.net the interface arbitrarily.
        #     irlqt-secured = {
        #       ips = [ "${ip}/24" ];
        #       listenPort = port;
        #       privateKeyFile = "/home/crow/wg-keys/archive";

        #       peers = [
        #         machine.wireguard.peers.spark
        #         {
        #           publicKey = "ma+LA7hdq9ayI26Ev0w0MyNFmSUNfBbsDU7+3/85Tis=";
        #           allowedIPs = [ "2.2.2.3/32" ];
        #           persistentKeepalive = 25;
        #         }
        #       ];
        #     };
        #   };
        # };
      };
    };
}
