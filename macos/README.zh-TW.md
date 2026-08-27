# macOS

[English](README.md) · [한국어](README.ko.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [日本語](README.ja.md) · [Русский](README.ru.md) · [Français](README.fr.md)

macOS 設定。

## 快速安裝

安裝完整設定，並以互動方式選擇 Homebrew 套件。

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ujon/os-setup/main/macos/install.sh)"
```

使用方向鍵移動，按 Space 選取，然後按 Enter 安裝。

## Homebrew

### 安裝

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 套件

```sh
brew install git
brew install n
brew install podman
brew install --cask chatgpt
brew install --cask codex
brew install --cask claude
brew install --cask claude-code
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
- n: [Homebrew](https://formulae.brew.sh/formula/n) · [Official](https://github.com/tj/n)
- Podman: [Homebrew](https://formulae.brew.sh/formula/podman) · [Official](https://podman.io/)
- ChatGPT: [Homebrew](https://formulae.brew.sh/cask/chatgpt) · [Official](https://learn.chatgpt.com/docs/app)
- Codex CLI: [Homebrew](https://formulae.brew.sh/cask/codex) · [Official](https://learn.chatgpt.com/docs/codex/cli)
- Claude: [Homebrew](https://formulae.brew.sh/cask/claude) · [Official](https://claude.com/download)
- Claude Code: [Homebrew](https://formulae.brew.sh/cask/claude-code) · [Official](https://claude.com/product/claude-code)
- Google Chrome: [Homebrew](https://formulae.brew.sh/cask/google-chrome) · [Official](https://www.google.com/chrome/)
- GitKraken: [Homebrew](https://formulae.brew.sh/cask/gitkraken) · [Official](https://www.gitkraken.com/)
- Visual Studio Code: [Homebrew](https://formulae.brew.sh/cask/visual-studio-code) · [Official](https://code.visualstudio.com/)
- Cyclope: [Homebrew](https://github.com/dogany/homebrew-tap) · [Official](https://github.com/dogany/cyclope)
- Godot: [Homebrew](https://formulae.brew.sh/cask/godot) · [Official](https://godotengine.org/)
- JetBrains Toolbox: [Homebrew](https://formulae.brew.sh/cask/jetbrains-toolbox) · [Official](https://www.jetbrains.com/toolbox-app/)

</details>

## Zsh

### 安裝相依套件

安裝 Oh My Zsh 和外掛程式：

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
```

### 安裝或更新

以此範本取代 `.zshrc`：

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

## 自訂指令碼

### project-init

建立代理程式檔案，並可選擇初始化 Git。

#### 安裝或更新

```sh
mkdir -p "$HOME/.local/bin"
curl -fsSL https://raw.githubusercontent.com/ujon/os-setup/main/macos/project-init.sh \
  -o "$HOME/.local/bin/project-init"
chmod +x "$HOME/.local/bin/project-init"
```

執行：

```sh
project-init [directory]
```
