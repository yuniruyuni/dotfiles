#!/bin/bash
# Update all tools and packages (cross-platform)

set -e

echo "=== Updating package manager ==="
case ${OSTYPE} in
  darwin*)
    brew update && brew upgrade
    ;;
  msys*)
    choco upgrade all -y
    ;;
  linux*)
    if command -v apt &> /dev/null; then
      sudo apt update && sudo apt upgrade -y
    elif command -v pacman &> /dev/null; then
      sudo pacman -Syu
    fi
    ;;
esac

echo ""
echo "=== Updating Rust ==="
if command -v rustup &> /dev/null; then
  rustup update
fi

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
