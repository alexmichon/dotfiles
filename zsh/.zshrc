# Set up the prompt
autoload -Uz promptinit
promptinit

autoload -U colors && colors

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
setopt histignorealldups
setopt sharehistory
setopt incappendhistory
setopt extendedhistory
setopt histignorespace

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select

# Key bindings
bindkey -v
bindkey '\C ' autosuggest-execute
bindkey '^[k' up-history
bindkey '^[j' down-history
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# Plugins
[[ -d "$HOME/.zsh/zsh-autosuggestions" ]] && source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -d "$HOME/.zsh/zsh-syntax-highlighting" ]] && source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ -n "$SSH_CONNECTION" ]]; then
	START_TMUX=true
fi

# Source files
files=( "aliases" "exports" "functions" "zsh_promp" )
for f in "${files[@]}"; do
	if [[ -f "$HOME/.$f" ]]; then
		source "$HOME/.$f"
	fi
done

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Tmux
if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ "$START_TMUX" == "true" ]]; then
  tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi

