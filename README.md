# Personal Nix packages repository

This contains some additional Nix packages.

Can be added to a flake `inputs` with

```nix
ack-nix-packages = {
  url = "github:albertodonato/nix-packages";
  inputs.nixpkgs.follows = "nixpkgs";
};
```
