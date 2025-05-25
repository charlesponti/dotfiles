#!/bin/bash

# Build script for webicon-maker Go version
# This builds the Go binary and makes it available in your PATH

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BINARY_NAME="webicon-maker"
BACKUP_NAME="webicon-maker-bash"

echo "🔨 Building webicon-maker Go version..."

cd "$SCRIPT_DIR"

# Backup existing bash version if it exists
if [ -f "$BINARY_NAME" ] && [ ! -f "$BACKUP_NAME" ]; then
  echo "📦 Backing up existing bash version to $BACKUP_NAME"
  mv "$BINARY_NAME" "$BACKUP_NAME"
fi

# Build the Go binary
go build -o "$BINARY_NAME" webicon-maker.go

# Make it executable
chmod +x "$BINARY_NAME"

echo "✅ Build complete!"
echo "📍 Binary location: $SCRIPT_DIR/$BINARY_NAME"
echo ""
echo "🚀 Usage:"
echo "   webicon-maker -i logo.png"
echo "   webicon-maker -h  # for help"
echo ""
echo "💡 The Go version is now the main 'webicon-maker' command in your PATH"
echo "   The original bash version is available as '$BACKUP_NAME' if needed"
