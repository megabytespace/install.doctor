### Homebrew Completions
# Source: https://docs.brew.sh/Shell-Completion#configuring-completions-in-fish
if test -d (brew --prefix)"/share/fish/completions"
    set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/completions
end

if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end

### Carapace
# Source: https://rsteube.github.io/carapace-bin/setup.html
mkdir -p ~/.config/fish/completions
carapace --list | awk '{print $1}' | xargs -I{} touch ~/.config/fish/completions/{}.fish # disable auto-loaded completions (#185)
carapace _carapace | source

### Google Cloud SDK
[ ! -f "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.fish.inc" ] || source "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.fish.inc"

### pay-respects
pay-respects fish --alias | source

### RTX
rtx activate fish | source

### Up
source "${XDG_DATA_HOME:-$HOME/.local/share}/up/up.fish"
