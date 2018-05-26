##################### Colors
C_DEFAULT="\[\033[m\]"
C_WHITE="\[\033[1m\]"
C_BLACK="\[\033[30m\]"
C_RED="\[\033[31m\]"
C_GREEN="\[\033[32m\]"
C_YELLOW="\[\033[33m\]"
C_BLUE="\[\033[34m\]"
C_PURPLE="\[\033[35m\]"
C_LIGHTGRAY="\[\033[37m\]"
C_DARKGRAY="\[\033[1;30m\]"

##################### Add Git info to prompt
source ~/.git-prompt.sh
source ~/.git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1

pluralize() {
  if [ $2 -eq 1 -o $2 -eq -1 ]
  then
    echo ${1}
  else
    echo ${1}s
  fi
}

time_since_last_commit() {
  local now=`date +%s`
  local last_commit=`git log --pretty=format:'%at' -1`
  local seconds_since_last_commit=$((now - last_commit))
  local d=$((seconds_since_last_commit/60/60/24))
  local h=$((seconds_since_last_commit/60/60%24))
  local m=$((seconds_since_last_commit/60%60))

  if [[ $d > 0 ]]; then
    echo $d $(pluralize "day" $d)
  elif [[ $h > 0 ]]; then
    echo $h $(pluralize "hour" $h)
  elif [[ $m > 0 ]]; then
    echo $m $(pluralize "min" $m)
  else
    echo $seconds_since_last_commit $(pluralize "second" $seconds_since_last_commit)
  fi
}

git_prompt() {
  local g="$(__gitdir)"
  if [ -n "$g" ]; then
    local SINCE_LAST_COMMIT="$(time_since_last_commit)${NORMAL}"
    local GIT_PROMPT=`__git_ps1 "(%s|${SINCE_LAST_COMMIT})"`
    echo ${GIT_PROMPT}
  fi
}

PS1="$C_RED\h: $C_BLUE\w $C_GREEN\$(git_prompt) \n$C_DEFAULT\$ "

##################### Aliases and helper functions

alias hpc='script/heroku_production run rails console'
alias tfl='tail -f log/development.log'

alias r='rails'
alias be='bundle exec'
alias bi='bundle install'
alias berc='bundle exec rails c'
alias bers='bundle exec rails s'
alias bert='bundle exec rake test:all'
alias beri='bundle exec ruby -Itest'
alias berj='bundle exec rake teaspoon'
alias ss='script/server'
alias st='script/test'

alias p='python'

alias vimc='vim `git dimn`' # Opens files different than master, Check .gitconfig for 'dimn' alias
alias spellcheck='grep \".*\" | grep -v "#{" | aspell --sug-mode=normal -a |  uniq' # Find spelling errors in strings surrounded by "quotes"

if [[ $OSTYPE = darwin* ]]; then
  alias ll='ls -alFG'
  alias la='ls -ACG'
  alias ls='ls -CFG'
elif [ $OSTYPE == 'linux-gnu' ]; then
  alias ll='ls --color=auto -alF'
  alias la='ls --color=auto -ACF'
  alias ls='ls --color=auto -CF'
fi

alias g='grep --color=always -rnI --exclude-dir=log'

##################### Ssh-agent launch

source ~/.git-ssh-agent-launch.sh

##################### History options

export CLICOLOR=1
HISTCONTROL=ignoreboth
shopt -s histappend
export HISTSIZE=10000 # Store 10k history entries
export HISTTIMEFORMAT="%d/%m/%y %T "

##################### MISC options

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
export EDITOR='vim'

##################### Bash completion options

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [[ $OSTYPE = darwin* ]]; then
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi
fi

##################### PATH modifications

export PATH="/usr/local/heroku/bin:$PATH"

if [ $OSTYPE == 'linux-gnu' ]; then
  export PATH=$HOME/npm/bin:$PATH
fi

if [[ $OSTYPE = darwin* ]]; then
  if [ -f /opt/dev/dev.sh ]; then
    source /opt/dev/dev.sh
  else
    source /usr/local/share/chruby/chruby.sh
    source /usr/local/share/chruby/auto.sh
    source ~/.autoenv/activate.sh
  fi
fi

export PATH="$HOME/.yarn/bin:$PATH"
export GOPATH=$HOME
export PATH=$GOPATH/bin:$PATH

# Make python3 the default python on mac. Add PATH that contains python shortcuts creates by homebrew
export PATH=/usr/local/opt/python/libexec/bin:$PATH

# Activate virtualenv automatically. Installed by 'brew install autoenv'
source /usr/local/opt/autoenv/activate.sh


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/Hammad/google-cloud-sdk/path.bash.inc' ]; then source '/Users/Hammad/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/Hammad/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/Hammad/google-cloud-sdk/completion.bash.inc'; fi
