# zsh login profile

# Nix (if installed)
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

export NIX_CONFIG="extra-experimental-features = nix-command flakes"
