{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "carbonyl-dev";

  buildInputs = with pkgs; [
    # Development tools
    just
    patchelf

    # Rust toolchain
    rustc
    cargo
    rustfmt
    clippy

    # Build essentials
    gcc
    binutils
    pkg-config
    gnumake
    cmake

    # Version control
    git
    git-lfs

    # Python (required for Chromium build scripts)
    python3

    # Chromium build dependencies
    ninja
    gn
    ccache

    # For depot_tools and Chromium builds
    curl
    which

    # Linux-specific dependencies for Chromium
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    libxkbcommon

    # Additional Chromium runtime dependencies
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libnotify
    mesa
    nspr
    nss
    pango
    systemd

    # Archive and compression tools
    unzip
    zip

    # Additional utilities
    nodejs
  ];

  shellHook = ''
    echo "Carbonyl development environment"
    echo ""
    echo "Quick start: just setup && just run https://example.com"
    echo "Available commands: just --list"
    echo ""

    # Set up environment variables for Chromium builds if needed
    export CARBONYL_ROOT="$PWD"
    export CHROMIUM_ROOT="$PWD/chromium"
    export CHROMIUM_SRC="$CHROMIUM_ROOT/src"
    export DEPOT_TOOLS_ROOT="$CHROMIUM_ROOT/depot_tools"

    # Add depot_tools to PATH if it exists
    if [ -d "$DEPOT_TOOLS_ROOT" ]; then
      export PATH="$PATH:$DEPOT_TOOLS_ROOT"
    fi

    # macOS deployment target for compatibility
    export MACOSX_DEPLOYMENT_TARGET=10.13
  '';

  # Set library path for runtime dependencies
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs; [
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    libxkbcommon
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libnotify
    mesa
    nspr
    nss
    pango
    systemd
  ]);
}
