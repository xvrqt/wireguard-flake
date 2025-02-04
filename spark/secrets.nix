let
  archive = machines.archive.ageKey;
  machines = import ../machines.nix;
in
{
  # Archive's Wireguard private key, only accessible to itself
  "secrets/archive.wg.key".publicKeys = [ archive ];
}
