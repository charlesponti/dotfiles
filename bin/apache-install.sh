# Stop system Apache
sudo apachectl stop

# Remove system Apache from LaunchDaemons
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null

# Install and start apache
brew install httpd
sudo brew services start httpd

# Start apachectl
sudo apachectl start

# Create index.html to serve
echo "<h1> My User Web Root </h1>" > ~/Sites/index.html

# Restart apachectl
sudo apachectl -k restart