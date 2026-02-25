#!/bin/bash
# Update all tools and packages

set -e

echo "=== Updating Homebrew ==="
brew update && brew upgrade

echo ""
echo "=== Updating Rust ==="
rustup update

echo ""
echo "=== Updating mise ==="
if command -v mise &> /dev/null; then
  mise self-update
  mise upgrade
fi

echo ""
echo "=== Updating Cargo packages ==="
if command -v cargo-install-update &> /dev/null; then
  cargo install-update -a
else
  echo "cargo-install-update not found. Install with: cargo install cargo-update"
fi

echo ""
echo "=== Update complete! ==="
