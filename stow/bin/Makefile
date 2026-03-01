.PHONY: build-go clean-go help

# Build all Go tools
build-go:
	@echo "🔨 Building Go tools..."
	@cd stow/bin/go/app-assets && go build -o ../../bin/app-assets .
	@echo "✓ Built: app-assets"

# Clean build artifacts
clean-go:
	@cd stow/bin/go/app-assets && go clean
	@rm -f stow/bin/bin/app-assets
	@echo "✓ Cleaned Go builds"

# Show build information
help-go:
	@echo "Go Tools Build Commands:"
	@echo "  make build-go    - Build all Go tools"
	@echo "  make clean-go    - Clean Go build artifacts"
