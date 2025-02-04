let
  port = 16842;
  gateway = "gateway.xvrqt.com";
  interface = "irlqt-secured";
in
{
  # Home Server
  archive = {
    inherit port interface;
    ip = "2.2.2.1";
    isServer = true;
    endpoint = "${gateway}:${builtins.toString port}";
    # Used to encrypt secrets (i.e. the privateKeyFile)
    ageKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6GH/nzYFaruIZ9ZORbBhYEzTHBnrCZXSJUK2rrs1jL archive@machine";
    # Wireguard Public Key
    publicKey = "SvnDMnuK8ZN+pED7rjhqhQUMq46cui/LrYurhfvHi2U=";
    # Where to find the Wireguard Private Key
    privateKeyFile = "/key/secrets/wg/private.key";
    peers = {
      spark = {
        publicKey = "paUrZfB470WVojQBL10kpL7+xUWZy6ByeTQzZ/qzv2A=";
        allowedIPs = [ "2.2.2.2/32" ];
      };
    };
  };
  # Apple M1 Ashai-Linux Lappy
  spark = {
    inherit port interface;
    ip = "2.2.2.2";
    isServer = false;
    # Used to encrypt secrets (i.e. the privateKeyFile)
    ageKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEDnpWeIBR+QCwclhSqSDKTsYCLYPX0b38lYnKPYBEMM spark@machine";
    # Wireguard Public Key
    publicKey = "paUrZfB470WVojQBL10kpL7+xUWZy6ByeTQzZ/qzv2A=";
    # Where to find the Wireguard Private Key
    privateKeyFile = "/key/secrets/wg/private.key";
  };
  # Amy's Cell Phone (not managed by this flake)
  third_lobe = {
    inherit port interface;
    ip = "2.2.2.3";
    isServer = false;
    publicKey = "ma+LA7hdq9ayI26Ev0w0MyNFmSUNfBbsDU7+3/85Tis=";
  };
  # Home Desktop
  nyaa = {
    inherit port interface;
    ip = "2.2.2.4";
    isServer = false;
    # Used to encrypt secrets (i.e. the privateKeyFile)
    ageKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINtHIPfa2+AQGIHZcBRLgkIx+3mhwEt/zf5ClP2AVvZ+ nyaa@machine";
    # Wireguard Public Key
    publicKey = "tHzr/Ej6G0qSX5mpn7U48ucdwk9TVuHZyxrDRfID50c=";
    # Where to find the Wireguard Private Key
    privateKeyFile = "/key/secrets/wg/private.key";
  };
}
