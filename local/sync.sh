#!/usr/bin/env bash

### Copy static files to base directory for easy viewing - source should still be modified in ~/.local/share/chezmoi/home (or ~/.local/share/chezmoi/system for system files)
find ./.local/share/chezmoi/home -type f | while read FILE; do
    BASENAME="$(basename "$FILE")"
    DIRNAME="$(dirname "$FILE")"
    if [[ "$FILE" != *'.tmpl' ]] && [[ "$BASENAME" != '.chezmoi'* ]] && [[ "$BASENAME" != 'symlink_'* ]] && [[ "$FILE" != *'gitkeep' ]] && [[ "$FILE" != *'.chezmoitemplates'* ]] && [ "$BASENAME" != 'chezmoi.txt.age' ] && [ "$FILE" != *'TODO' ]; then
        TARGET_DIR="$(echo "$DIRNAME" | sed 's/private_//g' | sed 's/dot_/\./g' | sed 's/executable_//' | sed 's/readonly_//g' | sed 's/\/.local\/share\/chezmoi\/home//')"
        mkdir -p "$TARGET_DIR"
        TARGET="$(echo "$FILE" | sed 's/private_//g' | sed 's/dot_/\./g' | sed 's/executable_//' | sed 's/readonly_//g' | sed 's/\/.local\/share\/chezmoi\/home//' )"
        cp "$FILE" "$TARGET"
    fi
done
