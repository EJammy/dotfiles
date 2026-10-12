# Dotfiles

Files in this repo mirror their location under `$HOME` (e.g. `.config/nvim` →
`~/.config/nvim`). `etc/` and `files/` are system files and are not installed by
`install.sh`.

## How install works

`install.sh` calls `install <path> [target]` for each dotfile. It symlinks
`<repo>/<path>` to `$HOME/<target>` (target defaults to `<path>`). An existing
symlink is left alone; an existing file is moved to `<target>.bak` first.

## Adding a new dotfile

1. Move the file into the repo at the same path it has under `$HOME`.
2. Add `install <path>` to `install.sh`, next to related entries.
3. Run `./install.sh` (or create just that symlink by hand) to link it back.

Link whole directories (like `.config/nvim`) when the app owns the directory;
link individual files when the directory has other machine-local state.

## Agent instruction files

* `.config/AGENTS.md`, `.config/goose/AGENTS.md`: global instructions for other
  agents.
* `.claude/CLAUDE.md`: global Claude Code instructions, linked to
  `~/.claude/CLAUDE.md`.
