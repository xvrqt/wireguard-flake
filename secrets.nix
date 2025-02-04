# Not imported, used by Agenix to encrypt secrets
let
  machines = import ./machines.nix;
in
{
  # Archive's Wireguard private key, only accessible to itself
  "secrets/archive.wg.key".publicKeys = [ machines.archive.ageKey ];
  # Spark's Wireguard private key, only accessible to itself
  "secrets/spark.wg.key".publicKeys = [ machines.spark.ageKey ];
  # Nyaa's Wireguard private key, only accessible to itself
  "secrets/nyaa.wg.key".publicKeys = [ machines.nyaa.ageKey ];
}
