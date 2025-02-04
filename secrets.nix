# Not imported, used by Agenix to encrypt secrets
let
  machines = import ./machines.nix;
in
{
  # Archive's Wireguard private key, only accessible to itself
  "secrets/archive.wg.key".publicKeys = [ machines.archive.ageKey ];
  # Archive's Wireguard private key, only accessible to itself
  "secrets/spark.wg.key".publicKeys = [ machines.spark.ageKey ];
}
