{
  inputs = {
    # Used to set up Wireguard keys
    secrets.url = "git+https://git.irlqt.net/crow/secrets-flake";
  };
  outputs =
    { secrets, ... }:
    let
      names = [ "lighthouse" "archive" "spark" "nyaa" "third-lobe" ];
      dns = import ./dns { inherit machines; };
      machines = import ./machines.nix;

      # Keeping things DRY
      cfg = { lib, pkgs, name, config, ... }:
        {
          imports = [
            # Needs the secrets module to function since we will be deploying
            # Wireguard private keys on each machine
            secrets.nixosModules.default
            # Sets up the reverse proxy for hosts that need it
            # (if needs_proxy then websites.nixosModules.minimal else null)

            # Configure the Wireguard interface
            (import ./wireguard { inherit lib name config machines; })
            # Configure the Tailnet
            (import ./tailscale { inherit name machines; })
            # Configure the Headscale coordination server on Lighthouse
            (import ./headscale { inherit lib dns name config machines; })
            # Sets nameservers, and sets up DNS servers for certain machines
            (import ./dns { inherit lib dns pkgs name machines; })
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
            value = { pkgs, lib, config, ... }: cfg { inherit lib pkgs config; name = item; };
          })
          names
      );
    };
}
