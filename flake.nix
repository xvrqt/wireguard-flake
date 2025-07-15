{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    secrets.url = "git+https://git.irlqt.net/crow/secrets-flake";
  };
  outputs =
    { nixpkgs, secrets, ... }:
    let
      # Wireguard interface name
      interface = "dorkweb";

      # List of machines on the dorkweb
      machines = import ./machines.nix;

      # Creates the Nix Config attrSet
      configureMachine = name: config: machine: {
        # Configures agenix to decrypt and store the private key on the target machine
        age.secrets.wgPrivateKey = {
          # The secret file that will be decrypted
          file = ./secrets + ("/" + "${name}.wg.key");
          # Folder to decrypt into (config.age.secretDir/'path')
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
          allowedUDPPorts = [ 16842 667 1337 ];
        };
        # If routing packets for other machines on the network, then NAT must be enabled
        # networking.nat = nixpkgs.lib.mkIf machine.enableNAT {
        #   enable = true;
        #   externalInterface = machine.externalInterface;
        #   internalInterfaces = [ "${interface}" ];
        # };
        # Setup the Wireguard Network Interface
        networking.wireguard.interfaces = {
          # Interface names are arbitrary
          "${interface}" = {
            # The machine's IP and the subnet (10.128.X.X/9) which the interface will capture
            ips = [ "${machine.ip}" ];
            listenPort = nixpkgs.lib.mkIf machine.enableNAT 16842;
            privateKeyFile = config.age.secrets.wgPrivateKey.path;
            peers = (generatePeerList name);
          };
        };

      };

      # Creates a list of Peer attrSets from the machines.nix list
      generatePeerList = name:
        let
          # Filter out the machine from its own Peer list
          # If the machine doesn't have an endpoint, filter out all machines without an endpoint
          filteredMachines = nixpkgs.lib.attrsets.filterAttrs (n: v: (n != name) && (v?endpoint || machines.${name}?endpoint)) machines;

          # Convert the Peer attrSet into a list of attrSets
          filteredMachineNames = builtins.attrNames filteredMachines;
          filteredListOfMachines = builtins.map (key: filteredMachines.${key}) filteredMachineNames;
        in
        # Map the machine attrSets into conformant Peer attrSets
        builtins.map (machine: (createPeerAttrSetFromMachine machine)) filteredListOfMachines;
      # Converts a machine attrSet into an attrSet that conforms to NixOS Wireguard Peers [{}]
      createPeerAttrSetFromMachine = machine: {
        ${if machine?endpoint then "endpoint" else null} = machine.endpoint;
        publicKey = machine.publicKey;
        allowedIPs = machine.allowedIPs;
        persistentKeepalive = 25;
      };
    in
    {
      nixosModules = {
        # Import me first to setup Agenix and common stuff
        default = {
          imports = [
            secrets.nixosModules.default
          ];
        };
        archive = { config, ... }:
          let
            name = "archive";
            machine = machines.${name};
          in
          configureMachine name config machine;

        spark = { config, ... }:
          let
            name = "spark";
            machine = machines.${name};
          in
          configureMachine name config machine;
        nyaa = { config, ... }:
          let
            name = "nyaa";
            machine = machines.${name};
          in
          configureMachine name config machine;
        lighthouse = { config, ... }:
          let
            name = "lighthouse";
            machine = machines.${name};
          in
          configureMachine name config machine;
      };
    };
}
