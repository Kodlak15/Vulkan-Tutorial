{
  # https://docs.vulkan.org/tutorial/latest/00_Introduction.html
  description = "Khronos Vulkan Tutorial";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  # TODO: issue with missing vulkan profiles header (see exercise 33)
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
        vulkan-profiles = pkgs.stdenv.mkDerivation rec {
          pname = "vulkan-profiles";
          version = pkgs.vulkan-headers.version;

          cmakeFlags = [
            "-DVULKAN_HEADERS_INSTALL_DIR=${pkgs.vulkan-headers}"
          ];

          nativeBuildInputs = with pkgs; [cmake ninja python3];
          buildInputs = with pkgs; [
            vulkan-headers
            vulkan-utility-libraries
            valijson
            (jsoncpp.override {enableStatic = true;})
          ];

          src = pkgs.fetchFromGitHub {
            owner = "KhronosGroup";
            repo = "Vulkan-Profiles";
            rev = "vulkan-sdk-${version}";
            hash = "sha256-u6Q6nugoppuiElDWtO9F4XJsgPFYpht0EhNrvOe/bhE=";
          };
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs;
            [
              cmake
              ninja
              catch2
              boost
              vulkan-headers
              vulkan-loader
              vulkan-validation-layers
              vulkan-tools
              vulkan-tools-lunarg
              vulkan-extension-layer
              vulkan-utility-libraries
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
              ktx-tools
              tinygltf
            ]
            ++ [vulkan-profiles];

          buildInputs = with pkgs; [
            nlohmann_json
          ];

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs;
            [
              vulkan-loader
              vulkan-validation-layers
              wayland
              libxkbcommon
              glfw
              glm
              tinyobjloader
              stb
              nlohmann_json
              ktx-tools
              tinygltf
            ]
            ++ [vulkan-profiles]);

          shellHook = ''
            exec zsh -c zellij
          '';
        };
      };
    };
}
