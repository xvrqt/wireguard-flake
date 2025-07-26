{
  # Wireguard
  lighthouse = {
    ip = {
      v4 = {
        www = "135.181.109.173";
        wg = "10.128.0.1";
        tailnet = "100.64.0.8";
      };
    };

    wg = {
      endpoint = "lighthouse.machines.xvrqt.com";
      publicKey = "CZc/OcuvBGUGDSll32yIidvPZr4WWRpKhs/a/ccPuWA=";
    };
  };
  # Home Server
  archive = {
    ip = {
      v4 = {
        www = "136.27.49.66";
        wg = "10.128.0.2";
        tailnet = "100.64.0.3";
        local = "192.168.1.6";
      };
    };

    wg = {
      endpoint = "archive.machines.xvrqt.com";
      publicKey = "SvnDMnuK8ZN+pED7rjhqhQUMq46cui/LrYurhfvHi2U=";
    };
  };
  # Apple M1 Ashai-Linux Lappy
  spark = {
    ip = {
      v4 = {
        wg = "10.128.0.3";
        tailnet = "100.64.0.2";
        local = "192.168.1.5";
      };
    };

    wg = {
      publicKey = "paUrZfB470WVojQBL10kpL7+xUWZy6ByeTQzZ/qzv2A=";
    };
  };
  # Amy's Cell Phone (not managed by this flake)
  third-lobe = {
    ip = {
      v4 = {
        wg = "10.128.0.4";
        tailnet = "100.64.0.4";
        local = "192.168.1.10";
      };
    };
    wg = {
      publicKey = "ma+LA7hdq9ayI26Ev0w0MyNFmSUNfBbsDU7+3/85Tis=";
    };
  };
  # Home Desktop
  nyaa = {
    ip = {
      v4 = {
        wg = "10.128.0.5";
        tailnet = "100.64.0.1";
        local = "192.168.1.4";
      };
    };
    wg = {
      publicKey = "tHzr/Ej6G0qSX5mpn7U48ucdwk9TVuHZyxrDRfID50c=";
    };
  };
}
