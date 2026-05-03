# jrmcdonald/dotfiles

Chezmoi-managed dotfiles for macOS (work) and macOS/Linux (home).

## Repo layout

- `home/` — chezmoi source state (`.chezmoiroot = home`)
- `lib/` — shell libraries sourced by scripts; lives outside chezmoi source state
- `install.sh` — bootstrap script; requires curl, git, and brew

## Key concepts

- **Work vs home** is controlled by the `work` boolean in `~/.config/chezmoi/chezmoi.toml`,
  set via `promptBoolOnce` on first run. Do not use OS checks as a proxy for this.
- **Templates** use `.tmpl` suffix. Use `{{- trimming -}}` on all `{{ if }}` blocks to
  avoid blank lines in rendered output.
- **`lib/log.sh`** must be sourced using
  `${CHEZMOI_SOURCE_DIR:-${HOME}/.local/share/chezmoi}/lib/log.sh` — never a hardcoded path.

## Script naming conventions

Chezmoi runs scripts in lexicographic order within each phase. Prefix with a
two-digit number to control ordering within a phase.

| Prefix              | When it runs                              |
|---------------------|-------------------------------------------|
| `run_once_`         | Once per machine (keyed on filename)      |
| `run_onchange_`     | When the script content changes           |
| `run_before_`       | Before applying dotfiles (every apply)    |
| `run_after_`        | After applying dotfiles (every apply)     |

Prefer `run_onchange_` over `run_after_` unless the script genuinely needs to
run on every apply.

## Runtime version management

- **mise** manages Node and Java (both work only) and future runtimes
- mise reads `.java-version` files natively; `java.shorthand_vendor = "temurin"`
  is set in `~/.config/mise/config.toml` so bare version strings resolve correctly
- Do not add nvm, jenv, pyenv, or sdkman — these are replaced by mise

## Shell plugins

- **sheldon** manages zsh plugins via `~/.config/sheldon/plugins.toml`
- Update plugins with `sheldon lock --update`
- Do not add zgen or slimzsh — these are replaced by sheldon

## Verifying changes

After `chezmoi apply`, check the debug log for errors:
cat ~/.local/share/chezmoi/home/debug-log.txt
