let
  port = 16842;
  # If the device is on the internal network, address directly
  internalGateway = "192.168.1.6";
  # If the device is mobile (e.g. laptops & phones) then resolve via DNS
  externalGateway = "gateway.irlqt.net";
  interface = "irlqt-secured";
in
{
  # Home Server
  archive = {
    inherit port interface;
    ip = "10.0.0.1";
    isServer = true;
    # TODO: Make the internal variant
    endpoint = "${externalGateway}:${builtins.toString port}";
    # Used to encrypt secrets (i.e. the privateKeyFile)
    ageKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6GH/nzYFaruIZ9ZORbBhYEzTHBnrCZXSJUK2rrs1jL archive@machine";
    # Wireguard Public Key
    publicKey = "SvnDMnuK8ZN+pED7rjhqhQUMq46cui/LrYurhfvHi2U=";
    # Where to find the Wireguard Private Key
    privateKeyFile = "/key/secrets/wg/private.key";
  };
  # Apple M1 Ashai-Linux Lappy
  spark = {
    inherit port interface;
    ip = "10.55.5.69";
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
    ip = "10.0.0.3";
    isServer = false;
    publicKey = "ma+LA7hdq9ayI26Ev0w0MyNFmSUNfBbsDU7+3/85Tis=";
  };
  # Home Desktop
  nyaa = {
    inherit port interface;
    ip = "10.0.0.4";
    isServer = false;
    # Used to encrypt secrets (i.e. the privateKeyFile)
    ageKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINtHIPfa2+AQGIHZcBRLgkIx+3mhwEt/zf5ClP2AVvZ+ nyaa@machine";
    # Wireguard Public Key
    publicKey = "tHzr/Ej6G0qSX5mpn7U48ucdwk9TVuHZyxrDRfID50c=";
    # Where to find the Wireguard Private Key
    privateKeyFile = "/key/secrets/wg/private.key";
  };
  # Emme's Cell Phone (not managed by this flake)
  emme_phone = {
    inherit port interface;
    ip = "10.0.0.5";
    isServer = false;
    publicKey = "4JwWETlM2xeNJLB/a+doIC8SCP4U2qIg+3tcgGbUVWc=";
  };  
  # Greg Gateway
  gregnet = {
    inherit port interface;
    ip = "10.55.5.1";
    isServer = true;
    # TODO: Make the internal variant
    endpoint = "tartarus.hell.cool:666";
    # Used to encrypt secrets (i.e. the privateKeyFile)
    ageKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6GH/nzYFaruIZ9ZORbBhYEzTHBnrCZXSJUK2rrs1jL archive@machine";
    # Wireguard Public Key
    publicKey = "x3VZ92d4Lo8K3Qot9eEBd4PfYQ/XvESLOmyVuqjgi0w=";
    # Where to find the Wireguard Private Key
    privateKeyFile = "/key/secrets/wg/private.key";
  };
}
