{
  description = "Khronos Vulkan Tutorial";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        vulkan-profiles = pkgs.callPackage ./nix/libs/vulkan-profiles.nix {inherit pkgs;};
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [(final: prev: {vulkan-profiles = vulkan-profiles;})];
        };
      in {
        devShells.default = import ./nix/shells/default.nix {inherit pkgs;};
      };
    };
}
