export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$PATH"

ZSH_THEME="robbyrussell"

plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Shortcut
alias ll="ls -l"
alias cc="clear"
alias nn="sudo lsof -PiTCP -sTCP:LISTEN"
