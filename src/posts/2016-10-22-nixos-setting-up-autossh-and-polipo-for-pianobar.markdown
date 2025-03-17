---
title: Pandora Proxy with Autossh and Polipo on NixOS
tags: polipo, autossh, nixos
---
I love listening to Pandora but being based outside the USA makes it inconvenient to connect to a VPN everytime you want to hear those tunes.

For this setup, you will need:

1. NixOS laptop/desktop to listen on - lets call this ***Laptop***
2. USA-based Server with SSH - lets call this ***Proxy***
3. ***Dedicated local user on the Laptop*** for setting up an SSH connection to the *Proxy*. Note: You could use your own user, but this wont work with keys protected by a passphrase. Having a separate user makes troubleshooting and locking down the account easier.

As a command-line junkie, I use the console-based pianobar app as my Pandora player which can be configured to use HTTP proxies.

We then use Polipo to listen as the HTTP proxy and configure it to connect to a SOCKS proxy. Autossh will be responsible setting up the SOCKS proxy and maintain a persistent connection to the ***Proxy*** host.

```
pianobar --> polipo (port 3128) --> autossh (port 8080)
```

**Proxy**:

Servers running NixOS can just use:
``` nix
  users.extraUsers.remotesocksuser = {
    openssh.authorizedKeys.keys = [
      "PUT PUBLIC KEY HERE it usually begins with ssh-rsa XXX"
    ];
  };
```
Otherwise, you will need to manually add the SSH public key inside `/home/remotesocksuser/.ssh/authorized_keys`

**Laptop:**
``` nix
  environment.systemPackages = with pkgs; [
    pianobar
  ]

  services.autossh.sessions = [ 
    { extraArguments = "-N -D8080 socksuser@123.123.123.123";
      name = "sshproxy"; user = "socksuser";
    }
  ];

  services.polipo = {
    enable = true;
    socksuserParentProxy = "localhost:8080";
  };
```
