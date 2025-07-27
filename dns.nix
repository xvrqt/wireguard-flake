{ machines }: {
  # DNS servers I control, over various interfaces
  personal = {
    tailnet = machines.lighthouse.ip.v4.tailnet;
    wg = machines.lighthouse.ip.v4.wg;
    www = machines.lighthouse.ip.v4.www;
  };
  # Quad9 - to use as upstream nameservers
  quad9 = {
    ip = {
      v4 = [ "9.9.9.9" "149.112.112.112" ];
      v6 = [ "2620:fe::fe" "2620:fe::9" ];
    };
    https = [ "https://dns.quad9.net/dns-query" ];
    tls = [ "tcp-tls:dns.quad9.net" ];
  };
}
