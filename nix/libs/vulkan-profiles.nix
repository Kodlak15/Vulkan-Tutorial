{pkgs, ...}:
pkgs.stdenv.mkDerivation rec {
  pname = "vulkan-profiles";
  version = pkgs.vulkan-headers.version;

  nativeBuildInputs = with pkgs; [cmake ninja python3];
  buildInputs = with pkgs; [
    vulkan-headers
    vulkan-utility-libraries
    valijson
    (jsoncpp.override {enableStatic = true;})
  ];

  cmakeFlags = [
    "-DVULKAN_HEADERS_INSTALL_DIR=${pkgs.vulkan-headers}"
  ];

  src = pkgs.fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Profiles";
    rev = "vulkan-sdk-${version}";
    hash = "sha256-u6Q6nugoppuiElDWtO9F4XJsgPFYpht0EhNrvOe/bhE=";
  };
}
