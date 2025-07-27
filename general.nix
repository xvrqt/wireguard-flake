{ pkgs, name, config, tailscale, wireguard, ... }: {
  # Networking
  networking = {
    # Give the machine a proper name
    hostName = name;
    firewall = {
      enable = true;
      trustedInterfaces = [ tailscale.interface wireguard.interface ];
    };
  };
}
