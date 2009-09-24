# Source the env config file
if [ -f ~/.bash/env ]; then
	. ~/.bash/env
fi

# Source the config file
if [ -f ~/.bash/config ]; then
	. ~/.bash/config
fi

# Source aliases
if [ -f ~/.bash/aliases ]; then
	. ~/.bash/aliases
fi

# Enable auto-completion for the port command
if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

# Source rvm directories
if [ -s ~/.rvm/scripts/rvm ] ; then source ~/.rvm/scripts/rvm ; fi
