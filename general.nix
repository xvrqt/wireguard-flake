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

  # Useful networking tools
  environment.systemPackages = [
    pkgs.nmap
    pkgs.trippy
    pkgs.ethtool
    pkgs.nettools
    pkgs.iproute2
    pkgs.traceroute
  ];
}
