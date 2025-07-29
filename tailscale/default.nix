{ lib, cfg, name, ... }:
let
  # Grab the specific machine we're configuring
  machine = cfg.machines."${name}";

  # If this machine routes packets
  exempt = (name == "lighthouse");
in
{
  services = lib.mkIf !exempt {
    # All machines are part of the tailnet
    tailscale = {
      enable = true;
      openFirewall = true;
      interfaceName = cfg.tailscale.interface;
      useRoutingFeatures = machine.ts.routingFeatures;
    };
  };
}
