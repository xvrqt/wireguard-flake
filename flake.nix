{
  inputs = {
    secrets.url = "git+https://git.irlqt.net/crow/secrets-flake";
  };
  outputs =
    { secrets, ... }:
    let
      # Wireguard interface name
      interface = "dorkweb";
      # Which point endpoints should keep open for connection
      endpoint_port = 16842;

      # List of machines on the dorkweb
      machines = import ./machines.nix;

      # Decrypts & Deploys the WG Key
      deploySecret = name: {
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

      # Creates the Nix Config attrSet
      configureMachine = pkgs: name: config: machine:
        let
          iptables = "${pkgs.iptables}/bin/iptables";
          is_endpoint = (machines.${name}?endpoint);
          routes_packets = (machines.${name}?isNAT && machines.${name}.isNAT);
        in
        {
          # Decrypt & Deploy the WG Key
          age.secrets.wgPrivateKey = deploySecret name;

          # Open our firewall that allows us to connect (if we're an endpoint)
          networking.firewall = pkgs.lib.mkIf is_endpoint {
            allowedUDPPorts = [ endpoint_port ];
          };
          # If routing packets for other machines on the network, then NAT must be enabled
          networking.nat = pkgs.lib.mkIf routes_packets {
            enable = true;
            externalInterface = machine.externalInterface;
            internalInterfaces = [ "${interface}" ];
          };
          # Setup the Wireguard Network Interface
          networking.wireguard.interfaces = {
            # Interface names are arbitrary
            "${interface}" = {
              # The machine's IP and the subnet (10.128.X.X/9) which the interface will capture and route traffic
              ips = [ "${machine.ip}" ];
              # The key that will be used to encrypt the traffic
              privateKeyFile = config.age.secrets.wgPrivateKey.path;
              # If the machine is an endpoint, set up routing
              postSetup = pkgs.lib.mkIf routes_packets "${iptables} -t nat -A POSTROUTING -s ${(builtins.elemAt machine.allowedIPs 0)} -o ${machine.externalInterface} -j MASQUERADE";
              postShutdown = pkgs.lib.mkIf routes_packets "${iptables} -t nat -D POSTROUTING -s ${(builtins.elemAt machine.allowedIPs 0)} -o ${machine.externalInterface} -j MASQUERADE";
              # Open a port and listen on it if we're an endpoint peer
              listenPort = pkgs.lib.mkIf is_endpoint endpoint_port;
              # A list of peers to connect to, and allow connections to
              peers = (generatePeerList pkgs name);
            };
          };

        };

      # Creates a list of Peer attrSets from the machines.nix list
      generatePeerList = pkgs: name:
        let
          # Filter out the machine from its own Peer list
          # If the machine doesn't have an endpoint, filter out all machines without an endpoint
          filteredMachines = pkgs.lib.attrsets.filterAttrs (n: v: (n != name) && (v?endpoint || machines.${name}?endpoint)) machines;

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
        archive = { pkgs, config, ... }:
          let
            name = "archive";
            machine = machines.${name};
          in
          configureMachine pkgs name config machine;

        spark = { pkgs, config, ... }:
          let
            name = "spark";
            machine = machines.${name};
          in
          configureMachine pkgs name config machine;
        nyaa = { pkgs, config, ... }:
          let
            name = "nyaa";
            machine = machines.${name};
          in
          configureMachine pkgs name config machine;
        lighthouse = { pkgs, config, ... }:
          let
            name = "lighthouse";
            machine = machines.${name};
          in
          configureMachine pkgs name config machine;
      };
    };
}
