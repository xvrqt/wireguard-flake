{ cfg, pkgs, name, config, ... }: {
  # Networking
  networking = {
    # Give the machine a proper name
    hostName = name;
    firewall = {
      enable = true;
      trustedInterfaces = [ cfg.tailscale.interface cfg.wireguard.interface ];
    };
  };
}
