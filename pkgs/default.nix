{ pkgs }:
let
  dirs = pkgs.lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./.);
  packages = pkgs.lib.mapAttrs (name: _: pkgs.callPackage ./${name} { }) dirs;
in
packages
