{pkgs, ...}:
pkgs.mkShell {
  packages = with pkgs; [
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
    vulkan-profiles
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
  ];

  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (
    with pkgs; [
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
  );

  # Fixes build issue with tinygltf
  CPLUS_INCLUDE_PATH = "${pkgs.nlohmann_json}/include/nlohmann";

  shellHook = ''
    exec zsh -c zellij
  '';
}
