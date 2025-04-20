# File: scripts/symlink_dotfiles.sh
#!/bin/bash
set -e

DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup"

mkdir -p "$BACKUP_DIR"

for file in "$DOTFILES_DIR"/dotfiles/.*; do
  [ -f "$file" ] || continue
  filename="$(basename "$file")"
  [ "$filename" = "." ] || [ "$filename" = ".." ] && continue

  if [ -e "$HOME/$filename" ]; then
    mv "$HOME/$filename" "$BACKUP_DIR/"
  fi

  ln -sf "$file" "$HOME/$filename"
done