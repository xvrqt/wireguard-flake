{
  # Wireguard Gateway in Helsinki
  lighthouse = {
    ip = "10.255.0.1/9";
    allowedIPs = [ "10.128.0.0/9" ];
    endpoint = "135.181.109.173:16842";
    publicKey = "CZc/OcuvBGUGDSll32yIidvPZr4WWRpKhs/a/ccPuWA=";
    privateKeyFile = "/key/secrets/wg/private.key";

    # This server will need to pass packets on to another server
    routesTraffic = true;
    parents = [ ];
    peers = [ "spark" "archive" "third_lobe" "gregnet" "nyaa" ];
  };
  # Home Server
  archive = {
    ip = "10.128.0.1/9";
    allowedIPs = [ "10.128.0.1/32" ];
    # endpoint = "archive.irlqt.net:16842";
    publicKey = "SvnDMnuK8ZN+pED7rjhqhQUMq46cui/LrYurhfvHi2U=";
    privateKeyFile = "/key/secrets/wg/private.key";

    parents = [ "lighthouse" "gregnet" ];
    peers = [ ];
  };
  # Apple M1 Ashai-Linux Lappy
  spark = {
    ip = "10.128.0.2/9";
    allowedIPs = [ "10.128.0.2/32" ];
    publicKey = "paUrZfB470WVojQBL10kpL7+xUWZy6ByeTQzZ/qzv2A=";
    privateKeyFile = "/key/secrets/wg/private.key";

    parents = [ "lighthouse" "gregnet" ];
    peers = [ ];
  };
  # Amy's Cell Phone (not managed by this flake)
  third_lobe = {
    ip = "10.128.0.3";
    allowedIPs = [ "10.128.0.3/32" ];
    publicKey = "ma+LA7hdq9ayI26Ev0w0MyNFmSUNfBbsDU7+3/85Tis=";
  };
  # Home Desktop
  nyaa = {
    ip = "10.128.0.4/9";
    allowedIPs = [ "10.128.0.4/32" ];
    publicKey = "tHzr/Ej6G0qSX5mpn7U48ucdwk9TVuHZyxrDRfID50c=";
    privateKeyFile = "/key/secrets/wg/private.key";

    parents = [ "lighthouse" ];
    peers = [ ];
  };
  # Emme's Cell Phone (not managed by this flake)
  emme_phone = {
    ip = "10.128.0.5/9";
    allowedIPs = [ "10.128.0.5/32" ];
    publicKey = "4JwWETlM2xeNJLB/a+doIC8SCP4U2qIg+3tcgGbUVWc=";
  };
  # Greg Gateway
  gregnet = {
    ip = "10.129.0.1/9";
    isNAT = true;
    allowedIPs = [ "10.129.0.0/16" ];
    listenPort = 667;
    endpoint = "tartarus.hell.cool:667";
    publicKey = "UR+lejpKmgS5UKri4/wA/Q57vfGhhCoCbW3Fk8qqVxA=";
  };
}
