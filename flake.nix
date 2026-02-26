{
  description = "Ultimate 2026+ hybrid runtime (Brew + Nix)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        shellPackages = with pkgs; [
          go_1_22
          golangci-lint
          go-tools
          delve
          nodejs_20
          typescript
          bun
          esbuild
          tsx
          python312
          python312Packages.pip
          python312Packages.virtualenv
          python312Packages.polars
          python312Packages.pandas
          python312Packages.numpy
          python312Packages.scikit-learn
          python312Packages.jupyter
          postgresql_15
          redis
          gitFull
          gh
          cargo
          rustc
          sqlite
          duckdb
        ];
      in {
        formatter = pkgs.nixfmt-rfc-style;
        devShells.default = pkgs.mkShell {
          buildInputs = shellPackages;

          shellHook = ''
            export DOTFILES_RUNTIME_MODE="''${DOTFILES_RUNTIME_MODE:-hybrid}"
            export DOTFILES_PROFILE="''${DOTFILES_PROFILE:-power}"
            echo "runtime mode: $DOTFILES_RUNTIME_MODE"
            echo "profile: $DOTFILES_PROFILE"
          '';
        };
      }
    );
}
