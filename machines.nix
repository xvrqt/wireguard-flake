{
  # Wireguard Gateway in Helsinki
  lighthouse = {
    ip = "10.255.0.1/9";
    allowedIPs = [ "10.128.0.0/9" ];
    enableNAT = true;
    listenPort = 1337;
    externalInterface = "eth0";
    # TODO: Make the internal variant
    endpoint = "135.181.109.173:16842";
    # Wireguard Public Key
    publicKey = "CZc/OcuvBGUGDSll32yIidvPZr4WWRpKhs/a/ccPuWA=";
    # Where to find the Wireguard Private Key
    privateKeyFile = "/key/secrets/wg/private.key";
  };
  # Home Server
  archive = {
    ip = "10.128.0.1/9";
    allowedIPs = [ "10.128.0.0/16" ];
    enableNAT = true;
    listenPort = 16842;
    externalInterface = "enp0s31f6";
    # TODO: Make the internal variant
    endpoint = "archive.irlqt.net:16842";
    # Wireguard Public Key
    publicKey = "SvnDMnuK8ZN+pED7rjhqhQUMq46cui/LrYurhfvHi2U=";
    # Where to find the Wireguard Private Key
    privateKeyFile = "/key/secrets/wg/private.key";
  };
  # Apple M1 Ashai-Linux Lappy
  spark = {
    ip = "10.128.0.2/9";
    allowedIPs = [ "10.128.0.2/32" ];
    enableNAT = false;
    # Wireguard Public Key
    publicKey = "paUrZfB470WVojQBL10kpL7+xUWZy6ByeTQzZ/qzv2A=";
    # Where to find the Wireguard Private Key
    privateKeyFile = "/key/secrets/wg/private.key";
  };
  # Amy's Cell Phone (not managed by this flake)
  third_lobe = {
    ip = "10.128.0.3";
    allowedIPs = [ "10.128.0.3/32" ];
    enableNAT = false;
    publicKey = "ma+LA7hdq9ayI26Ev0w0MyNFmSUNfBbsDU7+3/85Tis=";
  };
  # Home Desktop
  nyaa = {
    ip = "10.128.0.4/9";
    allowedIPs = [ "10.128.0.4/32" ];
    enableNAT = false;
    # Wireguard Public Key
    publicKey = "tHzr/Ej6G0qSX5mpn7U48ucdwk9TVuHZyxrDRfID50c=";
    # Where to find the Wireguard Private Key
    privateKeyFile = "/key/secrets/wg/private.key";
  };
  # Emme's Cell Phone (not managed by this flake)
  emme_phone = {
    ip = "10.128.0.5/9";
    allowedIPs = [ "10.128.0.5/32" ];
    enableNAT = false;
    publicKey = "4JwWETlM2xeNJLB/a+doIC8SCP4U2qIg+3tcgGbUVWc=";
  };
  # Greg Gateway
  gregnet = {
    ip = "10.129.0.1/9";
    enableNAT = true;
    allowedIPs = [ "10.129.0.0/16" ];
    listenPort = 667;
    # TODO: Make the internal variant
    endpoint = "tartarus.hell.cool:667";
    # Wireguard Public Key
    publicKey = "UR+lejpKmgS5UKri4/wA/Q57vfGhhCoCbW3Fk8qqVxA=";
  };
}
