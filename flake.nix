{
  description = "inventory";

  inputs.std.url = "github:divnix/std";
  inputs.std.inputs.devshell.url = "github:numtide/devshell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs =
    inputs@{
      self,
      std,
      nixpkgs,
      ...
    }:
    with std;
    growOn
      {
        inherit inputs;
        cellsFrom = ./cells;
        cellBlocks = with blockTypes; [
          (functions "nixosModules")
          (installables "packages")
        ];
      }
      {
      };
}
