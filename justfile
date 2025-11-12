# Carbonyl - Terminal Browser

# Show available recipes
default:
    @just --list

# Build the Rust core library
build:
    cargo build --release

# Download pre-built Chromium runtime binaries
runtime-pull:
    ./scripts/runtime-pull.sh

# Patch the pre-built binary for NixOS
patch:
    @echo "Patching carbonyl binary for NixOS..."
    @patchelf --set-interpreter $(patchelf --print-interpreter $(which sh)) \
        --set-rpath './build/pre-built/x86_64-unknown-linux-gnu:'"$$LD_LIBRARY_PATH" \
        ./build/pre-built/x86_64-unknown-linux-gnu/carbonyl
    @echo "Binary patched successfully"

# Setup: build, pull runtime, and patch (one-time setup)
setup: build runtime-pull patch
    @echo "Setup complete! You can now run carbonyl with: just run <URL>"

# Run carbonyl with a URL (example: just run https://example.com)
run URL:
    ./build/pre-built/x86_64-unknown-linux-gnu/carbonyl {{URL}}

# Run carbonyl with example.com (for quick testing)
test:
    ./build/pre-built/x86_64-unknown-linux-gnu/carbonyl https://example.com

# Clean build artifacts
clean:
    cargo clean
    rm -rf build/pre-built

# Build the complete Chromium runtime from source (takes ~1 hour)
build-runtime TARGET="Default":
    ./scripts/build.sh {{TARGET}}

# Show cargo version info
info:
    @echo "Rust version: $(rustc --version)"
    @echo "Cargo version: $(cargo --version)"
