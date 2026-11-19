# macOS

[English](README.md) · [한국어](README.ko.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [日本語](README.ja.md) · [Русский](README.ru.md) · [Français](README.fr.md) · [हिन्दी](README.hi.md) · [اردو](README.ur.md)

Configuration de macOS.

## Installation rapide

Installez la configuration complète et sélectionnez les paquets Homebrew de manière interactive.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ujon/os-setup/main/macos/install.sh)"
```

Utilisez les flèches pour vous déplacer, Space pour sélectionner, puis Enter pour lancer l’installation.

## Installation manuelle

### Homebrew

#### Installation

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Paquets

```sh
brew install git
brew install make
brew install n
brew install podman
brew install --cask podman-desktop
brew install --cask chatgpt
brew install --cask codex
brew install --cask claude
brew install --cask claude-code
brew install ollama
brew install --cask ollama-app
brew install --cask google-chrome
brew install --cask gitkraken
brew install --cask visual-studio-code
brew install --cask dogany/tap/cyclope
brew install --cask godot
brew install --cask jetbrains-toolbox
```

<details>
<summary>Links</summary>

- Homebrew: [Official](https://brew.sh/)
- Git: [Homebrew](https://formulae.brew.sh/formula/git) · [Official](https://git-scm.com/)
- GNU Make: [Homebrew](https://formulae.brew.sh/formula/make) · [Official](https://www.gnu.org/software/make/)
- n: [Homebrew](https://formulae.brew.sh/formula/n) · [Official](https://github.com/tj/n)
- Podman: [Homebrew](https://formulae.brew.sh/formula/podman) · [Official](https://podman.io/)
- Podman Desktop: [Homebrew](https://formulae.brew.sh/cask/podman-desktop) · [Official](https://podman-desktop.io/)
- ChatGPT: [Homebrew](https://formulae.brew.sh/cask/chatgpt) · [Official](https://learn.chatgpt.com/docs/app)
- Codex CLI: [Homebrew](https://formulae.brew.sh/cask/codex) · [Official](https://learn.chatgpt.com/docs/codex/cli)
- Claude: [Homebrew](https://formulae.brew.sh/cask/claude) · [Official](https://claude.com/download)
- Claude Code: [Homebrew](https://formulae.brew.sh/cask/claude-code) · [Official](https://claude.com/product/claude-code)
- Ollama: [Homebrew](https://formulae.brew.sh/formula/ollama) · [Official](https://ollama.com/)
- Ollama App: [Homebrew](https://formulae.brew.sh/cask/ollama-app) · [Official](https://ollama.com/)
- Google Chrome: [Homebrew](https://formulae.brew.sh/cask/google-chrome) · [Official](https://www.google.com/chrome/)
- GitKraken: [Homebrew](https://formulae.brew.sh/cask/gitkraken) · [Official](https://www.gitkraken.com/)
- Visual Studio Code: [Homebrew](https://formulae.brew.sh/cask/visual-studio-code) · [Official](https://code.visualstudio.com/)
- Cyclope: [Homebrew](https://github.com/dogany/homebrew-tap) · [Official](https://github.com/dogany/cyclope)
- Godot: [Homebrew](https://formulae.brew.sh/cask/godot) · [Official](https://godotengine.org/)
- JetBrains Toolbox: [Homebrew](https://formulae.brew.sh/cask/jetbrains-toolbox) · [Official](https://www.jetbrains.com/toolbox-app/)

</details>

### Zsh

#### Installation des dépendances

Installez Oh My Zsh et les extensions :

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
```

#### Installation ou mise à jour

Remplacez `.zshrc` par ce modèle :

```sh
curl -fsSL https://raw.githubusercontent.com/ujon/os-setup/main/macos/.zshrc \
  -o "$HOME/.zshrc"
exec zsh
```

<details>
<summary>Links</summary>

- [Oh My Zsh](https://ohmyz.sh/)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

</details>

### init-project

Crée les fichiers des agents et initialise Git si nécessaire.

#### Installation ou mise à jour

```sh
mkdir -p "$HOME/.local/bin"
curl -fsSL https://raw.githubusercontent.com/ujon/os-setup/main/macos/init-project.sh \
  -o "$HOME/.local/bin/init-project"
chmod +x "$HOME/.local/bin/init-project"
```

Exécution :

```sh
init-project [directory]
```

### SSH

#### Génération des clés

Une clé par compte :

```sh
mkdir -p "$HOME/.ssh"
ssh-keygen -t ed25519 -C "your_email@example.com"
ssh-keygen -t ed25519 -C "personal_email@example.com" -f "$HOME/.ssh/id_ed25519_personal"
```

#### Enregistrement des hôtes dans `~/.ssh/config`

```sh
mkdir -p "$HOME/.ssh"
cat >> "$HOME/.ssh/config" <<'EOF'
Host *
  AddKeysToAgent yes
  UseKeychain yes

# Default account
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes

# Extra account: git clone git@personal.github.com:<user>/<repo>.git
Host personal.github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_personal
  IdentitiesOnly yes
EOF
```

<details>
<summary>Links</summary>

- [GitHub SSH keys](https://github.com/settings/keys)
- [Connecting to GitHub with SSH](https://docs.github.com/authentication/connecting-to-github-with-ssh)

</details>
