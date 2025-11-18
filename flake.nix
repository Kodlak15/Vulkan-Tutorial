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
      }: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            cmake
            ninja
            catch2
            boost
            vulkan-headers
            vulkan-loader
            vulkan-validation-layers
            vulkan-tools # vkcube's build in nixpkgs is broken and disabled temporarily
            vulkan-tools-lunarg
            glslang
            glfw
            glm
            wayland
            libxkbcommon
            shaderc
            tinyobjloader
            stb
            nlohmann_json
            xorg.libXxf86vm
            shader-slang
          ];

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs; [
            vulkan-loader
            vulkan-validation-layers
            wayland
            libxkbcommon
            glfw
            glm
            tinyobjloader
            stb
            nlohmann_json
          ]);

          shellHook = ''
            exec zsh -c zellij
          '';
        };
      };
    };
}
