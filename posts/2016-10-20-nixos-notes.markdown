---
title: Posting my NixOS Notes Online
tags: nixos
---
I came across some [NixOS recipes](https://sheenobu.net/) by [\@sheenobu](https://twitter.com/sheenobu) and decided that I should document and share my experiences too.

I've been using NixOS since 2014 and it always amazes me how easy it is to configure system services. Using nix was so awesome that I stopped using debian as my daily driver after more than a decade of use. Next thing I knew was that I was maintaining [several nix packages](https://github.com/NixOS/nixpkgs/search?utf8=%E2%9C%93&q=womfoo) and contributing fixes to the project.

And since there already is a [recipe for ELK](https://sheenobu.net/nixos-recipes/elk.html), I'll start with a [Graylog 2.0 setup](/posts/2016-10-21-nixos-graylog.html). Instead of going through [manual steps](http://docs.graylog.org/en/2.1/pages/installation.html) on traditional distros, you just need to edit `/etc/nixos/configuration.nix` and `nixos-rebuild switch`.

While some may point out that chef or puppet can handle this in a similar fashion, one takeaway is that NixOS modules are bundled in the OS. This saves you a lot of time from searching for supermarket recipes or puppetforge modules. See `man configuration.nix` or the online [NixOS manual](https://nixos.org/nixos/manual/options.html) for all the things you can configure.

Happy Nixxing!
