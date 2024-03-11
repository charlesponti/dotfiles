npm_clean() {
  informer "Cleaning node_modules"
  find . -name "node_modules" -type d -prune -exec rm -rf '{}' +;

  informer "Clearing npm cache"
  npm cache clean --force
}

npm_refresh () {
  informer "Reinstalling node_modules"
  npm_clean
  npm install
}