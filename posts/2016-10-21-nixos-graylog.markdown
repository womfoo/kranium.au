---
title: Graylog2 on NixOS
tags: graylog, nixos
---
Graylog is an Open Source logging solution much like the ELK stack (Elasticsearch, Logstash, Kibana).

It comes with a GUI and it automatically mananges elasticsearch for log storage and indexes. All other configuration and metadata are stored in MongoDB.

The configuration snips below sets up these 3 services on a single server and exposes the default external port needed.

**Server**
``` nix
  services.graylog = {
    enable = true;
    passwordSecret = "REPLACEME";
    # your hash below a.k.a. `echo -n yourpassword | shasum -a 256`
    rootPasswordSha2 = "REPLACEME";
    elasticsearchClusterName = "elasticsearch";
  };

  services.elasticsearch = {
    enable = true;
    package = pkgs.elasticsearch2;
  };

  services.mongodb = {
    enable = true;
  };

  # opens port for the UDP GELF stream, add all UDP ports here. use networking.firewall.allowedTCPPorts for TCP.
  networking.firewall.allowedUDPPorts = [
    12201
  ];

```

**Clients (or on the server too)**
``` nix
  # NixOS does not have a module for this yet so go write it and open a nixpkgs PR :-)
  systemd.services.systemdjournal2gelf = {
    description = "SystemdJournal2Gelf";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 30;
      ExecStart = "${pkgs.systemd-journal2gelf}/bin/SystemdJournal2Gelf your.graylog.host:12201 --follow";
    };
  };
```
