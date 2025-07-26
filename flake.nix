{
  inputs = {
    secrets.url = "git+https://git.irlqt.net/crow/secrets-flake";
  };
  outputs =
    { secrets, ... }:
    let
      names = [ "lighthouse" "archive" "spark" "third-lobe" ];
      machines = import ./machines.nix;

      # Keeping things DRY
      cfg = { lib, name, config, ... }: {
        imports = [
          # Needs the secrets module to function since we will be deploying
          # Wireguard private keys on each machine
          secrets.nixosModules.default
          # Configure the Wireguard interface
          (import ./wireguard { inherit lib name config machines; })
        ];
      };
    in
    {
      # For each 'name' in 'names'
      # Create an attribute set key and, create a value for that key by calling
      # cfg() using that name as a parameter
      # e.g. {
      #   nyaa = { /* NixOS Module Config */ };
      #   spark = { /* NixOS Module Config */ };
      #   ...
      # }
      nixosModules = builtins.listToAttrs (
        map
          (item: {
            name = item;
            value = { lib, config, ... }: cfg { inherit lib config; name = item; };
          })
          names
      );
      #   {
      #   archive = { lib, config, ... }:
      #     let
      #       name = "archive";
      #       inherit machines;
      #     in
      #     {
      #       imports = [
      #         secrets.nixosModules.default
      #         (import ./wireguard { inherit lib name config machines; })
      #       ];
      #     };
      #   lighthouse = { lib, config, ... }:
      #     let
      #       name = "lighthouse";
      #       inherit machines;
      #     in
      #     {
      #       imports = [
      #         secrets.nixosModules.default
      #         (import ./wireguard { inherit lib name config machines; })
      #       ];
      #     };
      #   spark = { lib, config, ... }: cfg {
      #     inherit lib config; name = "spark";
      #   };
      # };
    };
}
