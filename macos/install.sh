#!/bin/bash

set -euo pipefail

readonly raw_base_url="https://raw.githubusercontent.com/ujon/os-setup/main/macos"

# Each entry is "type|name|label|description".
packages=(
  "formula|git|Git|Distributed version control system"
  "formula|make|GNU Make|Utility for directing compilation"
  "formula|n|n|Node.js version management"
  "formula|podman|Podman|OCI container and pod management"
  "cask|podman-desktop|Podman Desktop|Container and Kubernetes desktop app"
  "cask|chatgpt|ChatGPT|ChatGPT desktop app"
  "cask|codex|Codex CLI|OpenAI Codex CLI"
  "cask|claude|Claude|Claude desktop app"
  "cask|claude-code|Claude Code|Anthropic Claude Code"
  "formula|ollama|Ollama|Local large language model runtime"
  "cask|ollama-app|Ollama App|Local large language model desktop app"
  "cask|google-chrome|Google Chrome|Google web browser"
  "cask|gitkraken|GitKraken|Git desktop client"
  "cask|visual-studio-code|Visual Studio Code|Source code editor"
  "cask|dogany/tap/cyclope|Cyclope|Window management tool"
  "cask|godot|Godot|Game engine"
  "cask|jetbrains-toolbox|JetBrains Toolbox|JetBrains IDE manager"
)
readonly package_count=${#packages[@]}

package_types=()
package_names=()
package_labels=()
package_descriptions=()

for entry in "${packages[@]}"; do
  IFS="|" read -r package_type package_name package_label package_description <<<"$entry"
  package_types+=("$package_type")
  package_names+=("$package_name")
  package_labels+=("$package_label")
  package_descriptions+=("$package_description")
done

selected=()
visible_indices=()
selector_active=0
frame=""
mark=""
temp_dir=""
install_all=0
dry_run=0

usage() {
  cat <<'EOF'
Usage: install.sh [--all] [--dry-run]

Interactively installs the macOS setup.

Options:
  --all      Install every Homebrew package without opening the selector.
  --dry-run  Select packages and print the result without installing anything.
  -h, --help Show this help.
EOF
}

while (($# > 0)); do
  case "$1" in
    --all)
      install_all=1
      ;;
    --dry-run)
      dry_run=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Error: this installer supports macOS only." >&2
  exit 1
fi

if [[ -t 1 && "${TERM:-}" != "dumb" ]]; then
  cyan=$'\033[36m'
  green=$'\033[32m'
  dim=$'\033[2m'
  bold=$'\033[1m'
  reset=$'\033[0m'
else
  cyan=""
  green=""
  dim=""
  bold=""
  reset=""
fi

readonly ansi_hide_cursor=$'\033[?25l'
readonly ansi_show_cursor=$'\033[?25h'
readonly ansi_clear_screen=$'\033[2J\033[H'
readonly ansi_cursor_home=$'\033[H'
readonly ansi_clear_line=$'\033[K'
readonly ansi_clear_below=$'\033[J'
readonly ansi_begin_sync=$'\033[?2026h'
readonly ansi_end_sync=$'\033[?2026l'

restore_cursor() {
  if ((selector_active)); then
    printf '%s' "$ansi_show_cursor" >&3 2>/dev/null || true
    exec 3>&-
    selector_active=0
  fi
}

cleanup() {
  restore_cursor

  if [[ -n "$temp_dir" ]]; then
    rm -rf "$temp_dir"
  fi
}

trap cleanup EXIT
trap 'cleanup; exit 130' INT TERM

step() {
  printf '\n%s==>%s %s\n' "$cyan" "$reset" "$1"
}

selected_count() {
  local count=0
  local value

  for value in "${selected[@]}"; do
    count=$((count + value))
  done

  printf '%d' "$count"
}

select_every_package() {
  local value="$1"
  local i

  for ((i = 0; i < package_count; i++)); do
    selected[i]=$value
  done
}

toggle_all() {
  if (( $(selected_count) == package_count )); then
    select_every_package 0
  else
    select_every_package 1
  fi
}

rebuild_visible_indices() {
  local search="$1"
  local i

  visible_indices=(-1)
  shopt -s nocasematch

  for ((i = 0; i < package_count; i++)); do
    if [[ -z "$search" || "${package_labels[i]}" == *"$search"* || "${package_names[i]}" == *"$search"* ]]; then
      visible_indices+=("$i")
    fi
  done

  shopt -u nocasematch
}

set_mark() {
  local index="$1"
  local count="$2"

  if ((index == -1)); then
    if ((count == package_count)); then
      mark="${green}●${reset}"
    elif ((count > 0)); then
      mark="${green}◉${reset}"
    else
      mark="○"
    fi
  elif ((selected[index])); then
    mark="${green}●${reset}"
  else
    mark="○"
  fi
}

add_line() {
  frame+="$1$ansi_clear_line"$'\n'
}

render_selector() {
  local cursor="$1"
  local search="$2"
  local row index pointer count description

  count="$(selected_count)"
  frame=""

  add_line "${dim}Found ${package_count} packages${reset}"
  add_line "${bold}Select Homebrew packages${reset}"
  add_line "${dim}Search:${reset} ${search}▌${reset}"
  add_line "${dim}↑↓ move, space select, enter confirm, type search, backspace clear${reset}"
  add_line ""

  for ((row = 0; row < ${#visible_indices[@]}; row++)); do
    index=${visible_indices[row]}
    if ((row == cursor)); then
      pointer="${cyan}❯${reset} "
    else
      pointer="  "
    fi

    set_mark "$index" "$count"

    if ((index == -1)); then
      add_line "${pointer}${mark} ${bold}Select All${reset} ${dim}(${count}/${package_count})${reset}"
      add_line "  ${dim}────────────────────────────────────────${reset}"
    else
      add_line "${pointer}${mark} ${package_labels[index]}"
    fi
  done

  if ((${#visible_indices[@]} == 1)); then
    add_line "  ${dim}No matching packages${reset}"
  fi

  index=${visible_indices[cursor]}
  if ((index == -1)); then
    description="Select or clear all ${package_count} packages."
  else
    description=${package_descriptions[index]}
  fi

  add_line ""
  add_line "${dim}Description${reset}"
  frame+="${dim}${description}${reset}${ansi_clear_line}"

  # One write per frame, redrawn in place: no full-screen erase, no flicker.
  printf '%s%s%s%s%s' \
    "$ansi_begin_sync" "$ansi_cursor_home" "$frame" "$ansi_clear_below" "$ansi_end_sync" >&3
}

select_packages() {
  local cursor=0
  local search=""
  local key rest index

  if ! { exec 3<>/dev/tty; } 2>/dev/null; then
    echo "Error: an interactive terminal is required. Use --all for non-interactive installation." >&2
    exit 1
  fi

  selector_active=1
  printf '%s%s' "$ansi_hide_cursor" "$ansi_clear_screen" >&3

  while true; do
    rebuild_visible_indices "$search"
    if ((cursor >= ${#visible_indices[@]})); then
      cursor=$((${#visible_indices[@]} - 1))
    fi
    render_selector "$cursor" "$search"

    key=""
    IFS= read -rsn1 key <&3

    if [[ "$key" == $'\033' ]]; then
      rest=""
      IFS= read -rsn2 -t 1 rest <&3 || true
      key+="$rest"
    fi

    case "$key" in
      $'\033[A')
        cursor=$(((cursor - 1 + ${#visible_indices[@]}) % ${#visible_indices[@]}))
        ;;
      $'\033[B')
        cursor=$(((cursor + 1) % ${#visible_indices[@]}))
        ;;
      " ")
        index=${visible_indices[cursor]}
        if ((index == -1)); then
          toggle_all
        else
          selected[index]=$((1 - selected[index]))
        fi
        ;;
      "")
        break
        ;;
      $'\177'|$'\b')
        if [[ -n "$search" ]]; then
          search=${search%?}
          cursor=0
        fi
        ;;
      *)
        if [[ "$key" == [[:print:]] ]]; then
          search+="$key"
          cursor=0
        fi
        ;;
    esac
  done

  printf '%s' "$ansi_clear_screen" >&3
  restore_cursor
}

print_selection() {
  local i

  printf 'Selected %d of %d Homebrew packages.\n' "$(selected_count)" "$package_count"
  for ((i = 0; i < package_count; i++)); do
    if ((selected[i])); then
      printf '  - %s\n' "${package_labels[i]}"
    fi
  done
}

select_every_package 0

if ((install_all)); then
  select_every_package 1
else
  select_packages
fi

print_selection

if ((dry_run)); then
  echo "Dry run complete. No changes were made."
  exit 0
fi

step "Installing Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Error: Homebrew is not available in PATH." >&2
  exit 1
fi

brew_bin="$(command -v brew)"
eval "$("$brew_bin" shellenv)"

printf -v shellenv_line 'eval "$(%s shellenv)"' "$brew_bin"
zprofile_path="$HOME/.zprofile"
if ! grep -Fqx "$shellenv_line" "$zprofile_path" 2>/dev/null; then
  if [[ -s "$zprofile_path" ]]; then
    printf '\n' >>"$zprofile_path"
  fi
  printf '# Homebrew\n%s\n' "$shellenv_line" >>"$zprofile_path"
fi

if (( $(selected_count) > 0 )); then
  step "Installing selected Homebrew packages"
  for ((i = 0; i < package_count; i++)); do
    if ((!selected[i])); then
      continue
    fi

    if [[ "${package_types[i]}" == "cask" ]]; then
      "$brew_bin" install --cask "${package_names[i]}"
    else
      "$brew_bin" install "${package_names[i]}"
    fi
  done
fi

step "Installing Oh My Zsh"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes /bin/sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh is already installed."
fi

zsh_custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$zsh_custom_dir/plugins"

for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
  plugin_path="$zsh_custom_dir/plugins/$plugin"
  if [[ ! -e "$plugin_path" ]]; then
    git clone --depth=1 "https://github.com/zsh-users/$plugin" "$plugin_path"
  else
    echo "$plugin is already installed."
  fi
done

temp_dir="$(mktemp -d "${TMPDIR:-/tmp}/os-setup.XXXXXX")"

step "Installing the Zsh configuration"
curl -fsSL "$raw_base_url/.zshrc" -o "$temp_dir/zshrc"

if cmp -s "$temp_dir/zshrc" "$HOME/.zshrc"; then
  echo "The Zsh configuration is already up to date."
else
  if [[ -e "$HOME/.zshrc" || -L "$HOME/.zshrc" ]]; then
    zshrc_backup="$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
    mv "$HOME/.zshrc" "$zshrc_backup"
    echo "Existing .zshrc backed up to: $zshrc_backup"
  fi
  install -m 0644 "$temp_dir/zshrc" "$HOME/.zshrc"
fi

step "Installing project-init"
curl -fsSL "$raw_base_url/project-init.sh" -o "$temp_dir/project-init"
mkdir -p "$HOME/.local/bin"
install -m 0755 "$temp_dir/project-init" "$HOME/.local/bin/project-init"

printf '\n%sSetup complete.%s Run %sexec zsh%s to reload your shell.\n' \
  "$green" "$reset" "$bold" "$reset"
