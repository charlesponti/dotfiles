npm_clean() {
  informer "Cleaning node_modules"
  find . -name "node_modules" -type d -prune -exec rm -rf '{}' +
  npm cache clean --force
}

npm_refresh () {
  informer "Reinstalling node_modules"
  node_modules_clean
  node_modules_install
}