# next lets set some enviromental/shell pref stuff up
# setopt NOHUP
#setopt NOTIFY
#setopt NO_FLOW_CONTROL
setopt APPEND_HISTORY
# setopt AUTO_LIST		# these two should be turned off
# setopt AUTO_REMOVE_SLASH
# setopt AUTO_RESUME		# tries to resume command of same name
unsetopt BG_NICE		# do NOT nice bg commands
setopt CORRECT			# command CORRECTION
setopt EXTENDED_HISTORY		# puts timestamps in the history
# setopt HASH_CMDS		# turns on hashing
setopt HIST_ALLOW_CLOBBER
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY SHARE_HISTORY
setopt ALL_EXPORT

# setopt MENUCOMPLETE
# Set/unset  shell options
setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent noclobber
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash

# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile


PATH="/sw/bin:/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin/:/Users/thijs/bin:$PATH"
HISTFILE=$HOME/.zhistory
HISTSIZE=1000
SAVEHIST=1000
HOSTNAME="`hostname`"
PAGER='less'
EDITOR='mate -w'
    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
   colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
   eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
   eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
   (( count = $count + 1 ))
    done
    PR_NO_COLOR="%{$terminfo[sgr0]%}"
#PS1="$PR_BLUE%n@%m$PR_NO_COLOR:$PR_BLUE%~$PR_NO_COLOR
#%(!.#.$) "
#RPS1="$PR_BLUE(%D{%H:%M:%S %d-%m})$PR_NO_COLOR"
#LANGUAGE=
LC_ALL='nl_NL.UTF-8'
LANG='nl_NL.UTF-8'
DISPLAY=:0

unsetopt ALL_EXPORT
# # --------------------------------------------------------------------
# # aliases
# # --------------------------------------------------------------------
alias man='LC_ALL=C LANG=C man'
alias l='ls -l'
alias la='ls -la'
alias screens='screen -ls'
alias ls='ls -G'

bindkey "^[[3~" delete-char

autoload -U compinit
compinit
bindkey '^r' history-incremental-search-backward
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history
bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[F"  end-of-line
bindkey "^[[4~" end-of-line
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand
WORDCHARS=${WORDCHARS//\/}
bindkey '\e^?' backward-delete-word

# Before a command execution
preexec() {
	# Define timer and cmd for growl notification
	export PREEXEC_TIME=$(date +'%s')
	export PREEXEC_CMD="\"$1\" finished."
}

# After a command execution
precmd() {
	# Growl notify
	# Time after which trigger a growl notification
	DELAY_AFTER_NOTIFICATION=5
	
	# Get the start time, or set it to now if not set
	start=${PREEXEC_TIME:-`date +'%s'`}

	stop=$(date +'%s')
	
	let elapsed=$stop-$start
	
	if [ $elapsed -gt $DELAY_AFTER_NOTIFICATION ] && [ PREEXEC_CMD != "" ]; then
		growlnotify -n "Terminal" -m "Took $elapsed seconds." ${PREEXEC_CMD:-Some command}
	fi
	export PREEXEC_CMD=
	export PREEXEC_TIME=
}

###########################################
#   iTerm Tab and Title Customization     #
###########################################

function set_title_tab {

      function settab   {

            # file settab  -- invoked only if iTerm or Konsole is running 

            #  Set iterm window tab to current directory and penultimate directory if the
            #  shell process is running.  Truncate to leave the rightmost $rlength characters.
            #
            #  Use with functions settitle (to set iterm title bar to current directory)
            #  and chpwd

            # The $rlength variable prints only the 20 rightmost characters. Otherwise iTerm truncates
            # what appears in the tab from the left.


            # Chage the following to change the string that actually appears in the tab:

            tab_label="$PWD:h:t/$PWD:t"

            rlength="20"   # number of characters to appear before truncation from the left

            echo -ne "\e]1;${(l:rlength:)tab_label}\a"
      }

      function settitle   {
            # Function "settitle"  --  set the title of the iterm title bar. use with chpwd and settab

            # Change the following string to change what appears in the Title Bar label:


            title_lab=$HOST:r:r:$PWD

            # Change the title bar label dynamically:

            echo -ne "\e]2;$USER@$title_lab\a"
      }

	# Set tab and title bar dynamically using above-defined functions

      function title_tab_chpwd { settab ; settitle }
		
	# Now we need to run it:
	title_tab_chpwd

	# Set tab or title bar label transiently to the currently running command
			
	function title_tab_preexec {  echo -ne "\e]1; [$(history $HISTCMD | cut -b7- )] \a"  } 
	function title_tab_precmd  { settab }

 
	typeset -ga preexec_functions
	preexec_functions+=title_tab_preexec

	typeset -ga precmd_functions
	precmd_functions+=title_tab_precmd

	typeset -ga chpwd_functions
	chpwd_functions+=title_tab_chpwd
 
}

####################

set_title_tab

chpwd() {
      local VCS_STR=""       # Version control information
      local BM_MATCH=""      # Bookmark information
      local PROMPT_CHAR="$"
      # Look for a git repository,
      # Parse current branch when found.
      GIT_BRANCH=$(git branch 2>/dev/null)
      HG_SUMM=$(hg summary 2>/dev/null)

      if [[ "$GIT_BRANCH" != "" ]] then
            VCS_STR="★ git [$(echo $GIT_BRANCH | grep "*" | awk '{print $2}') - $(git show | head -1 | awk '{print $2}')] "
            PROMPT_CHAR="➔"
      elif [[ -d ".svn" ]] then
            SVN_INFO=$(svn info)
            VCS_STR="★ svn [$(echo $SVN_INFO | grep "Repository Root:" | awk '{print $3}') - $(echo $SVN_INFO | grep "Revision" | awk '{print $2}')] "
            PROMPT_CHAR="➱"
      elif [[ "$HG_SUMM" != "" ]] then
            VCS_STR="★ hg [$(echo $HG_SUMM | grep "branch" | awk '{print $2}') - $(echo $HG_SUMM | grep "parent" | awk '{print $2}')] "
            PROMPT_CHAR="↔"
      fi

      # Look for a bookmark at the current directory
      #
      BM_MATCH=$(bm -m | awk -F' ' '{ if ($1 == "'$PWD'") print $2 }' | head -1)
      
      if [ "$BM_MATCH" != "" ]
      then
      BM_MATCH=" ★ $(echo $BM_MATCH | sed -e 's/\[//g' -e 's/\]//g')"
      fi

      # Set the normal prompt (on the left)
      #
      PROMPT="$PR_BLUE%n@%m$PR_NO_COLOR:$PR_BLUE%~$PR_NO_COLOR:"
      PROMPT="$PROMPT $PR_YELLOW$VCS_STR$PR_NO_COLOR"

      PROMPT="$PROMPT
%(!.#.$PROMPT_CHAR) "


      # Set the right prompt
      #
      
      RPROMPT="$PR_BLUE(%D{%H:%M:%S %d-%m}"
      RPROMPT=$RPROMPT$BM_MATCH")$PR_NO_COLOR"
}
# Change the prompt at the start of zsh

chpwd

source /usr/share/bm/bm.bash