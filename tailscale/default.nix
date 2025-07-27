{ name, machines, tailscale, ... }:
let
  # Grab the specific machine we're configuring
  machine = machines."${name}";
in
{

  services = {
    # All machines are part of the tailnet
    tailscale = {
      enable = true;
      openFirewall = true;
      interfaceName = tailscale.interface;
      useRoutingFeatures = machine.ts.routingFeatures;
    };
  };
}
