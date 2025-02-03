{ machine, ... }:
let
  ip = machine.wireguard.ip;
  port = machine.wireguard.port;
  interface = machine.wireguard.interface;
in
{

  # DNS
  services.blocky = {
    enable = true;
    settings = {
      ports.dns = 53;
      upstreams.groups.default = [
        "https://one.one.one.one/dns-query"
      ];
      customDNS = {
        mapping = {
          "jellyseerr.irlqt.net" = "${ip}";
          "radarr.irlqt.net" = "${ip}";
          "immich.irlqt.net" = "${ip}";
          "sonarr.irlqt.net" = "${ip}";
          "prowlarr.irlqt.net" = "${ip}";
          "nzbget.irlqt.net" = "${ip}";
        };
      };
      bootstrapDns = {
        upstream = "https://one.one.one.one/dns-query";
        ips = [ "1.1.1.1" "1.0.0.1" ];
      };
      blocking = {
        blackLists = {
          ads = [ "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" ];
        };
        clientGroupsBlock = {
          default = [ "ads" ];
        };
      };
    };
  };
}
