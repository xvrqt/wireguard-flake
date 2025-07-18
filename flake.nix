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

      # Generates a peer configuration from a machine attrset
      createPeerAttrSetFromMachine = machine: is_endpoint: is_parent:
        let
          # If the machine is endpoint, add it's endpoint
          # WARN Unless the caller is also an endpoint but is not a parent
          cfg_endpoint = machine?endpoint && (!is_endpoint || is_parent);
        in
        {
          ${if cfg_endpoint then "endpoint" else null} = machine.endpoint;
          publicKey = machine.publicKey;
          allowedIPs = machine.allowedIPs;
          persistentKeepalive = 25;
        };

      # Creates a list of Peer attrSets from the current machine's peer list
      generatePeerList = name: is_endpoint:
        let
          peers = machines.${name}.peers;
          parents = machines.${name}.parents;
          # A list of machines based on what's in the peers list of the current machine
          listOfPeersAttrSets = builtins.map (key: machines.${key}) peers;
          listOfParentsAttrSets = builtins.map (key: machines.${key}) parents;
        in
        # Create the parent and peer attrsets and merge them
        ((builtins.map (machine: (createPeerAttrSetFromMachine machine is_endpoint false)) listOfPeersAttrSets) ++
          (builtins.map (machine: (createPeerAttrSetFromMachine machine is_endpoint true)) listOfParentsAttrSets));



      # Creates the Nix Config attrSet
      configureMachine = pkgs: name: config: machine:
        let
          thisMachine = machines.${name};
          is_endpoint = (thisMachine?endpoint);
          routesTraffic = (thisMachine?routesTraffic && thisMachine.routesTraffic);

          iptables = "${pkgs.iptables}/bin/iptables";

          # Commands to route packets if the machine is setup to do that
          postSetup = pkgs.lib.mkIf routesTraffic "${iptables} -A FORWARD -i ${interface} -o ${interface} -j ACCEPT;";
          postShutdown = pkgs.lib.mkIf routesTraffic "${iptables} -D FORWARD -i ${interface} -o ${interface} -j ACCEPT;";
        in
        {
          # Decrypt & Deploy the WG Key
          age.secrets.wgPrivateKey = deploySecret name;

          # Open our firewall that allows us to connect (if we're an endpoint)
          networking.firewall = pkgs.lib.mkIf is_endpoint {
            allowedUDPPorts = [ endpoint_port ];
          };

          # Enable packet forwarding in the kernel
          boot.kernel.sysctl = pkgs.lib.mkIf routesTraffic {
            "net.ipv4.ip_forward" = 1;
          };

          # Setup the Wireguard Network Interface
          networking.wireguard.interfaces = {
            # Interface names are arbitrary
            "${interface}" = {
              # Routing Table modifications (if the machine routes packets)
              inherit postSetup postShutdown;
              # The machine's IP and the subnet (10.128.X.X/9) which the interface will capture and route traffic
              ips = [ "${machine.ip}" ];
              # Key that is used to encrypt traffic
              privateKeyFile = config.age.secrets.wgPrivateKey.path;
              # The port we're listening on if we're an endpoint
              listenPort = pkgs.lib.mkIf is_endpoint endpoint_port;
              # A list of peers to connect to, and allow connections to
              peers = (generatePeerList name is_endpoint);
            };
          };
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

