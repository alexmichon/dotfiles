ttyctl -f

ZSH_HOME="$HOME/.zsh"

# History
HISTFILE=$HOME/.zsh_history
SAVEHIST=1000
setopt inc_append_history
setopt extended_history
setopt share_history
setopt hist_ignore_all_dups

# Dirstack
autoload -Uz add-zsh-hook

DIRSTACKFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dirs"
if [[ -f "$DIRSTACKFILE" ]] && (( ${#dirstack} == 0 )); then
	dirstack=("${(@f)"$(< "$DIRSTACKFILE")"}")
	[[ -d "${dirstack[1]}" ]] && cd -- "${dirstack[1]}"
fi
chpwd_dirstack() {
	print -l -- "$PWD" "${(u)dirstack[@]}" > "$DIRSTACKFILE"
}
add-zsh-hook -Uz chpwd chpwd_dirstack

DIRSTACKSIZE='20'

setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME

## Remove duplicate entries
setopt PUSHD_IGNORE_DUPS

## This reverts the +/- operators.
setopt PUSHD_MINUS

# Completion
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
zstyle ':completion:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
setopt completealiases

# Plugins
if [ -f $ZSH_HOME/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source $ZSH_HOME/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTHSUGGEST_HIGHLIGHT_STYLE='fg=blue'
fi

if [ -f $ZSH_HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source $ZSH_HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Rehash
zshcache_time="$(date +%s%N)"

autoload -Uz add-zsh-hook

rehash_precmd() {
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}

add-zsh-hook -Uz precmd rehash_precmd

for file in $HOME/.{aliases,functions,zsh_prompt,zsh_keys}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		source "$file"
	fi
done

# FZF
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
