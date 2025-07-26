{
  inputs = {
    secrets.url = "git+https://git.irlqt.net/crow/secrets-flake";
  };
  outputs =
    { secrets, ... }:
    let
      machines = import ./machines.nix;
    in
    {
      nixosModules = {
        archive = { lib, config, ... }:
          let
            name = "archive";
            inherit machines;
          in
          {
            imports = [
              secrets.nixosModules.default
              (import ./wireguard { inherit lib name config machines; })
            ];
          };
        spark = { lib, config, ... }:
          let
            name = "spark";
            inherit machines;
          in
          {
            imports = [
              secrets.nixosModules.default
              (import ./wireguard { inherit lib name config machines; })
            ];
          };
      };
    };
}
