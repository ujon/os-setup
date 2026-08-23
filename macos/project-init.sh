#!/bin/sh

set -eu

project_dir="${1:-$PWD}"

if [ ! -d "$project_dir" ]; then
  echo "Error: directory does not exist: $project_dir" >&2
  exit 1
fi

project_dir="$(cd "$project_dir" && pwd -P)"

check_link() {
  link_path="$1"
  expected_target="$2"

  if [ -e "$link_path" ] && [ ! -L "$link_path" ]; then
    echo "Error: a regular file or directory already exists: $link_path" >&2
    exit 1
  fi

  if [ -L "$link_path" ] && [ "$(readlink "$link_path")" != "$expected_target" ]; then
    echo "Error: symbolic link points to an unexpected target: $link_path" >&2
    echo "Current target: $(readlink "$link_path")" >&2
    echo "Expected target: $expected_target" >&2
    exit 1
  fi
}

check_link "$project_dir/CLAUDE.md" "AGENTS.md"
check_link "$project_dir/.claude/skills" "../.agents/skills"

if [ -e "$project_dir/.claude/settings.json" ]; then
  echo "Error: .claude/settings.json already exists." >&2
  echo "Initialization stopped to protect the existing settings." >&2
  exit 1
fi

mkdir -p \
  "$project_dir/.agents/skills" \
  "$project_dir/.claude"

if [ ! -e "$project_dir/AGENTS.md" ]; then
  touch "$project_dir/AGENTS.md"
fi

if [ ! -L "$project_dir/CLAUDE.md" ]; then
  ln -s "AGENTS.md" "$project_dir/CLAUDE.md"
fi

if [ ! -L "$project_dir/.claude/skills" ]; then
  ln -s "../.agents/skills" "$project_dir/.claude/skills"
fi

command tee "$project_dir/.claude/settings.json" >/dev/null <<'JSON'
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "defaultMode": "bypassPermissions",
    "allow": [
      "Bash",
      "Read",
      "Edit",
      "Write",
      "WebFetch",
      "WebSearch"
    ]
  },
  "attribution": {
    "commit": "",
    "pr": ""
  }
}
JSON

printf "Initialize a Git repository? [y/N] "
IFS= read -r git_answer

case "$git_answer" in
  y|Y|yes|YES|Yes)
    if ! command -v git >/dev/null 2>&1; then
      echo "Error: Git is not installed or is not available in PATH." >&2
      exit 1
    fi

    if [ ! -d "$project_dir/.git" ]; then
      git -C "$project_dir" init
    else
      echo "Git repository already exists: $project_dir"
    fi

    gitignore_file="$project_dir/.gitignore"
    marker="# OS"

    if [ ! -f "$gitignore_file" ] || ! grep -Fqx "$marker" "$gitignore_file"; then
      if [ -s "$gitignore_file" ]; then
        printf '\n' >>"$gitignore_file"
      fi

      command tee -a "$gitignore_file" >/dev/null <<'GITIGNORE'
# OS

## macOS
.DS_Store
.AppleDouble
.LSOverride
._*
.Spotlight-V100
.Trashes

## Windows
Thumbs.db
Thumbs.db:encryptable
ehthumbs.db
ehthumbs_vista.db
Desktop.ini
$RECYCLE.BIN/

## Linux
*~
.directory
.Trash-*
.nfs*
GITIGNORE
    fi

    echo "Git initialization completed."
    ;;
  *)
    echo "Git initialization skipped."
    ;;
esac

echo "Project initialized successfully: $project_dir"
