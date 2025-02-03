{ pkgs, agenix, ... }:
{
  # Install tools for secret management
  environment.systemPackages = [
    # age key generation and management
    pkgs.age
    agenix.packages.${pkgs.system}.default
  ];

  # Configure agenix
  # TODO: Pull the redundant agenix config out of this flake
  # and the identities flake so they can't get out of sync
  age = {
    secretsDir = "/key/secrets";
    secretsMountPoint = "/key/agenix/generations";
  };
}
