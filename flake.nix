{
  description = "Competitive Dev Environment - Go/TS/ML";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Go
            go_1_22
            golangci-lint
            go-tools
            delve

            # TypeScript/Node
            nodejs_20
            typescript
            bun
            esbuild
            tsx

            # Python/ML
            python312
            python312Packages.pip
            python312Packages.virtualenv

            # Data processing
            python312Packages.polars
            python312Packages.pandas
            python312Packages.numpy
            python312Packages.scikit-learn
            python312Packages.jupyter

            # Databases
            postgresql_15
            redis

            # Utilities
            gitFull
            gh
            cargo
            rustc
            sqlite
            duckdb
          ];

          shellHook = ''
            echo "🚀 Development environment loaded"
            echo "   Go: $(go version | cut -d' ' -f3)"
            echo "   Node: $(node --version)"
            echo "   Python: $(python3 --version | cut -d' ' -f2)"
          '';
        };
      }
    );
}
