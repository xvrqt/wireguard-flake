let
  port = 16842;
  interface = "irlqt-secured";
in
{
  archive = {
    inherit port interface;
    ip = "2.2.2.1";
    privateKeyFile = "/key/secrets/wg/archive.key";
    peers = {
      spark = {
        publicKey = "paUrZfB470WVojQBL10kpL7+xUWZy6ByeTQzZ/qzv2A=";
        allowedIPs = [ "2.2.2.2/32" ];
      };
    };
  };
}
