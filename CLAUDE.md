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
  `${CHEZMOI_SOURCE_DIR:-${HOME}/.local/share/chezmoi/home}/../lib/log.sh` — never a hardcoded path.
  (`CHEZMOI_SOURCE_DIR` points to the `home/` subdir at runtime, so `/../lib/log.sh` resolves to the repo-root `lib/`.)

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

## Testing

Shell scripts are tested with [bats](https://github.com/bats-core/bats-core).
Bats helpers are git submodules under `tests/test_helper/`.

To run all tests locally:
```bash
git submodule update --init --recursive
./tests/bats/bin/bats tests/lib tests/scripts tests/dotfiles
```

### Test structure

- `tests/lib/` — unit tests for `lib/log.sh`
- `tests/scripts/` — unit tests for refactored scripts; template rendering and
  syntax checks for all `.tmpl` scripts in both home and work profiles
- `tests/dotfiles/` — content tests for rendered dotfiles (zshrc, git config,
  mise config, sheldon plugins, .chezmoiignore)
- `tests/fixtures/` — pre-seeded chezmoi config files for home and work profiles;
  work fixture uses obviously dummy data (AWS IDs `000000000001` etc.)

### Profile fixtures

`tests/fixtures/chezmoi-home.toml` and `tests/fixtures/chezmoi-work.toml`
remove the need for interactive prompts in tests. Pass them via
`chezmoi execute-template --config <fixture>` to render templates in either
profile deterministically.

### BASH_SOURCE guard requirement

Scripts that are unit tested directly must use the `BASH_SOURCE` guard pattern:
```bash
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
```
This allows bats to `source` the file and call functions without triggering
side effects. See `run_once_after_cleanup_old_tools`, `run_onchange_after_chsh`,
`run_onchange_after_configure_tmux`, and `run_onchange_after_configure_vim`.

### CI

- `.github/workflows/test.yml` — bats suite on every push/PR, ubuntu + macOS
- `.github/workflows/e2e.yml` — weekly `chezmoi apply --dry-run` for home
  profile (ubuntu + macOS) and work profile (macOS only, dummy fixture)

## Verifying changes

After `chezmoi apply`, check the debug log for errors:
cat ~/.local/share/chezmoi/home/debug-log.txt
