# GOOGLE CLOUD CLI
export CLOUDSDK_PYTHON="$HOME/.pyenv/shims/python"

# The next line updates PATH for the Google Cloud SDK - suppress output
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc" 2>/dev/null; fi

# The next line enables shell command completion for gcloud - suppress output
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc" 2>/dev/null; fi
