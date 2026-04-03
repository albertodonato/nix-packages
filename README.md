# Personal Nix packages repository

This contains some additional Nix packages.

Can be added to a flake `inputs` with

```nix
<input-name> = {
  url = "github:albertodonato/nix-packages";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

A specific package can be run via

```bash
nix run '.#<package-name>'
```
