# Runtime Reproducibility (Hybrid Brew+Nix)

## Ownership
- Homebrew:
  - system packages
  - GUI applications
  - host-level developer CLIs
- Nix flakes:
  - deterministic project toolchains
  - reproducible `nix develop` shells
- mise:
  - lightweight version manager for non-Nix workflows
- direnv:
  - guarded per-project activation layer

## Precedence
1. Project-local reproducible runtime (`nix develop`, `.envrc`, mise local)
2. User-level runtime tooling
3. Global PATH tools from Homebrew

## Determinism Rules
- Commit and maintain `flake.lock`.
- Keep `flake.nix` minimal and language/runtime focused.
- Avoid shell hooks that mutate runtime outside project scope.

## Verification
Run `./bin/runtime-verify.sh` and require pass for:
- Homebrew availability
- Nix + flake lock availability
- mise and direnv availability
- runtime mode/profile variable sanity
