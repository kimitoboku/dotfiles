fpath+=(~/.zsh/zsh-completions/src)

HISTFILE=~/.zhisotry
HISTSIZE=100000
SAVEHIST=100000
REPORTTIME=60

export PATH=$PATH:$HOME/bin

autoload -Uz colors vcs_info compinit select-word-style
colors
compinit -c

select-word-style bash

zstyle ':vcs_info:*' enable hg git svn
zstyle ':vcs_info:*' formats '[%b] '
zstyle ':vcs_info:*' actionformats '[%b|%a] '

setopt no_beep print_eight_bit
setopt auto_cd auto_pushd
setopt append_history extended_history hist_ignore_dups
setopt hist_ignore_space hist_reduce_blanks inc_append_history
setopt auto_list auto_menu auto_param_slash auto_remove_slash
setopt list_types list_packed
setopt magic_equal_subst equals mark_dirs combining_chars
unset promptcr


source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval `dircolors ~/.zsh/dircolors-solarized/dircolors.ansi-light`
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

function man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;34m") \
        LESS_TERMCAP_md=$(printf "\e[1;34m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
            man "$@"
}


function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src


function peco_select_history(){
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}

zle -N peco_select_history
bindkey '^r' peco_select_history



if [ "$(uname)" = "Darwin" ]; then
    alias awk="gawk"
    alias sed="gsed"
    alias date="gdate"
fi

alias ls="ls --color"
alias epush="emacsclient -n"
alias e="emacsclient -n"


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

eval "$(direnv hook bash)"


export PATH=$PATH:/usr/local/go/bin
