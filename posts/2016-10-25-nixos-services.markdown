---
title: Creating Services on NixOS
tags: nixos, services, netdata
---

Sooner or later you will encounter packages that do not come with services listed in `man configuration.nix` or the online [NixOS manual](https://nixos.org/nixos/manual/options.html).

The example below creates a systemd service named netdata. It also references the `pkgs.netdata` package which makes nix install the package into the nix store.

What's interesting here is that `pkgs.writeText` generates a text file in the nix store as `/nix/store/w7m045rznxldckglcqyw5rz5jibdq480-netdata.conf` prefixed with the usual hash. This hash will always be consistent as long as its contents remain the same.

``` nix
let
  netdataConfig = pkgs.writeText "netdata.conf" ''
    [global]
    debug log = /var/log/netdata/debug.log
    error log = /var/log/netdata/error.log
    access log = /var/log/netdata/access.log
    [registry]
    registry db directory = /var/lib/netdata
  '';
in

{

  users.extraUsers.netdata = { };
    
  systemd.services.netdata = {
    description = "netdata";
    after = [ "network.target" ];
    preStart = ''
    
      mkdir -p /var/{cache,log}/netdata
      chown -R netdata /var/cache/netdata	
      chown -R netdata /var/log/netdata
    '';
    serviceConfig = {
      ExecStart = "${pkgs.netdata}/bin/netdata -c ${netdataConfig}";
      Type = "forking";
    };
  };

}

```

```
$ systemctl cat netdata
# /nix/store/nr6d0iqfy475m3c4kygkywnfcshyajjk-unit-netdata.service/netdata.service
[Unit]
After=network.target
Description=netdata

[Service]
Environment="LOCALE_ARCHIVE=/nix/store/8sl4c7fbfyiscacpf53nza0c8cx2db88-glibc-locales-2.24/lib/locale/locale-archive"
Environment="PATH=/nix/store/8rn45r9ndfq5h7mx58r35p2szky5ja6n-coreutils-8.25/bin:/nix/store/gjm2wjh8m72ch3ikiznn4v40h9mvpfks-findutils-4.6.0/bin:/nix/store/h9aqgpgspgjhygj63wpncfzvz5ys851n-gnugrep-2.25/bin:/nix/store/1awgi4ba6ymlzib2l7bxa1
Environment="TZDIR=/nix/store/bb2njjq32bh1wl2nl1zss0i8w1w2jgrz-tzdata-2016f/share/zoneinfo"



ExecStart=/nix/store/z83jbjccl56khfgl5khlajrj62b2hds6-netdata-1.0.0/bin/netdata -c /nix/store/w7m045rznxldckglcqyw5rz5jibdq480-netdata.conf
ExecStartPre=/nix/store/k10g0h1s7kmkqxif90zf2kh493sa9qpp-unit-script/bin/netdata-pre-start
Type=forking
```

Note: Creating a configuration file for netdata at the time of this writing is necessary due to a bug in the package. I've submitted [a PR](https://github.com/NixOS/nixpkgs/pull/19864) to fix this.
