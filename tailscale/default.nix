{ name, machines, ... }:
let
  # Tailscale interface name
  interface = "irlqt-net";

  # Grab the specific machine we're configuring
  machine = machines."${name}";
in
{

  services = {
    # All machines are part of the tailnet
    tailscale = {
      enable = true;
      openFirewall = true;
      interfaceName = interface;
      useRoutingFeatures = machine.ts.routingFeatures;
    };
  };
}
