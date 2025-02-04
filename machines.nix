let
  port = 16842;
  interface = "irlqt-secured";
in
{
  archive = {
    inherit port interface;
    ip = "2.2.2.1";
    isServer = true;
    # Used to encrypt secrets (i.e. the privateKeyFile)
    ageKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6GH/nzYFaruIZ9ZORbBhYEzTHBnrCZXSJUK2rrs1jL archive@machine";
    # Wireguard Public Key
    publicKey = "SvnDMnuK8ZN+pED7rjhqhQUMq46cui/LrYurhfvHi2U=";
    # Where to find the Wireguard Private Key
    privateKeyFile = "/key/secrets/wg/archive.key";
    peers = {
      spark = {
        publicKey = "paUrZfB470WVojQBL10kpL7+xUWZy6ByeTQzZ/qzv2A=";
        allowedIPs = [ "2.2.2.2/32" ];
      };
    };
  };
  spark = {
    inherit port interface;
    ip = "2.2.2.2";
    isServer = false;
    # Used to encrypt secrets (i.e. the privateKeyFile)
    ageKey = "";
    # Wireguard Public Key
    publicKey = "";
    # Where to find the Wireguard Private Key
    privateKeyFile = "/key/secrets/wg/spark.key";
  };
}
