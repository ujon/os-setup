# macOS

[English](README.md) · [한국어](README.ko.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [日本語](README.ja.md) · [Русский](README.ru.md) · [Français](README.fr.md) · [हिन्दी](README.hi.md) · [اردو](README.ur.md)

macOS 설정입니다.

## 빠른 설치

전체 설정을 설치하고 Homebrew 패키지를 대화형으로 선택합니다.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ujon/os-setup/main/macos/install.sh)"
```

방향키로 이동하고 Space로 선택한 다음 Enter를 눌러 설치합니다.

## 수동 설치

### Homebrew

#### 설치

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### 패키지

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

#### 의존성 설치

Oh My Zsh와 플러그인을 설치합니다.

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
```

#### 설치 또는 업데이트

`.zshrc`를 이 보일러플레이트로 교체합니다.

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

에이전트 파일을 만들고 선택적으로 Git을 초기화합니다.

#### 설치 또는 업데이트

```sh
mkdir -p "$HOME/.local/bin"
curl -fsSL https://raw.githubusercontent.com/ujon/os-setup/main/macos/init-project.sh \
  -o "$HOME/.local/bin/init-project"
chmod +x "$HOME/.local/bin/init-project"
```

실행:

```sh
init-project [directory]
```

### SSH

#### 키 생성

계정마다 키를 하나씩 만듭니다.

```sh
mkdir -p "$HOME/.ssh"
ssh-keygen -t ed25519 -C "your_email@example.com"
ssh-keygen -t ed25519 -C "personal_email@example.com" -f "$HOME/.ssh/id_ed25519_personal"
```

#### `~/.ssh/config`에 호스트 등록

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
