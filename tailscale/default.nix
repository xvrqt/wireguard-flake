{ lib, cfg, name, ... }:
let
  # Grab the specific machine we're configuring
  machine = cfg.machines."${name}";

  # If this machine routes packets
  routes_packets = (name == "lighthouse");
in
{
  services = {
    # All machines are part of the tailnet
    tailscale = {
      enable = true;
      openFirewall = true;
      interfaceName = cfg.tailscale.interface;
      useRoutingFeatures = machine.ts.routingFeatures;

      extraUpFlags = lib.mkIf routes_packets [
        "--advertise-tags tag:exit"
      ];

      extraSetFlags = lib.mkIf routes_packets [
        "--advertise-exit-node"
      ];
    };
  };

  # Enable IP packet forwarding
  boot.kernel.sysctl = lib.mkIf routes_packets {
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
