# This flake collates all my host flakes together for convenienc0
{
  inputs = {
    agenix.url = "github:ryantm/agenix";
  };
  outputs =
    { agenix, ... }:
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
        # Import me first to setup Agenix and common stuff
        default = { lib, pkgs, ... }: {
          imports = [
            (import ./common.nix { inherit lib pkgs agenix; })
            agenix.nixosModules.default
          ];
        };
        # Import the correct machine to configure Wireguard for it
        archive = { lib, pkgs, config, ... }: {
          imports = [
            (import ./archive { inherit lib pkgs config agenix machines; })
          ];
        };
        spark = { lib, pkgs, config, ... }: {
          imports = [
            (import ./spark { inherit lib pkgs config agenix machines; })
          ];
        };
      };
    };
}
