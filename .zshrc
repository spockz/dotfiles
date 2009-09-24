# Source the env config file
if [[ -f ~/.zsh/env ]]; then
  . ~/.zsh/env
fi

# Source the config file
if [[ -f ~/.zsh/config ]]; then
  . ~/.zsh/config
fi

# Source aliases
if [[ -f ~/.zsh/aliases ]]; then
  . ~/.zsh/aliases
fi

# Source rvm directories
if [ -s ~/.rvm/scripts/rvm ] ; then source ~/.rvm/scripts/rvm ; fi