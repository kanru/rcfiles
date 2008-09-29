# {{{ Zsh options
setopt appendhistory
setopt extendedglob
setopt nobeep
setopt autocd
setopt autopushd
setopt pushdignoredups
setopt pushdsilent
setopt correct
setopt notify
setopt hash_list_all
setopt completeinword
setopt nohup
setopt dvorak
setopt prompt_subst
# }}}

# {{{ Environment
eval `dircolors -b`
export ZSHDIR=$HOME/.zsh
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
DIRSTACKSIZE=6
REPORTTIME=5

export TEXDOC_VIEWER_PDF='(evince %s)&'
export LESSCHARSET=utf-8
export PATH=${PATH}:${HOME}/bin;
export BROWSER=/home/kanru/bin/myfx.sh
export DEBEMAIL="koster@debian.org.tw"
export DEBFULLNAME="Kanru Chen"
export EMAIL="kanru@kanru.info"
export EDITOR=vim
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
#export DEBCVS=:pserver:kanru@cvs.debian.org:/cvs/webwml
# }}}

# {{{ keybindings
bindkey -e
# }}}

# {{{ Completition stuff
autoload -Uz compinit
#zmodload -i zsh/complist
compinit

#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
## correction

# Ignore completion functions for commands you don't have:
#  zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

zstyle ':completion:*'             completer _complete _prefix _correct _approximate
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:correct:*'   insert-unambiguous true
#  zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
#  zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%}'
zstyle ':completion:*:corrlctions' format $'%d (errors: %e)'
zstyle ':completion:*:correct:*'   original true
zstyle ':completion:correct:'      prompt 'correct to:'

# command for process lists, the local web server details and host completion
hosts=(`hostname`)
zstyle '*' hosts $hosts
zstyle ':completion:*:urls' local 'www' '/var/www/' 'public_html'
[ -d $ZSHDIR/cache ] && zstyle ':completion:*' use-cache on && \
    zstyle ':completion::complete:*' cache-path $ZSHDIR/cache/
# use ~/.ssh/known_hosts for completion
[ -f "$HOME/.ssh/known_hosts" ] && \
    hosts=(${${${(f)"$(<$HOME/.ssh/known_hosts)"}%%\ *}%%,*}) && \
    zstyle ':completion:*:hosts' hosts $hosts
#compdef _gnu_generic tail head feh cp mv gpg df stow uname ipacsum fetchipac
# }}}

# End of lines added by compinstall
alias cls='ls -v --color=auto'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='cls -l'
alias la='cls -A'
alias l='cls -CF'
alias ii='cls -l'
alias ic='cls --color'
alias ia='cls -A'
alias i='cls -C'
alias c='clear'
alias e='gvim'
alias g='wget'
alias m='mplayer'
alias t='telnet'
alias n='host'
alias s='ssh'
alias mk='make'
alias td='todo'
alias cgrep='grep --color'
alias svnlog='svn log|less'
alias acs='apt-cache search'
alias api='aptitude install'
alias acsh='apt-cache show'
alias au='aptitude update'
alias sa='sudo aptitude'
alias tlog='tail -f /var/log/syslog'
alias smi='sudo make install'
alias sdi='sudo dpkg -i'
alias sshn='ssh netinfo.cc.ncnu.edu.tw -p 6682'
alias p5='python2.5 /usr/bin/paster'
alias grep='grep --color'
alias src='cd ~src'
alias gi='gvim --remote-tab'

# {{{ Set prompt
# PS1=$'%{\e[1;33m%}%*%{\e[0m%} %{\e[1;31m%}%n%{\e[1;34m%}@%m:%{\e[32m%}%~ ^%j\n%{\e[1;33m%}%#%{\e[0m%} '
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
'%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
'%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
precmd () { vcs_info }
EXITCODE="%(?..%?%1v )"
JOBS="%(1j.%j .)"
local BLUE="%{[1;34m%}"
local RED="%{[1;31m%}"
local GREEN="%{[1;32m%}"
local CYAN="%{[1;36m%}"
local YELLOW="%{[1;33m%}"
local NO_COLOUR="%{[0m%}"
PS2='`%_> '       # secondary prompt, printed when the shell needs more information to complete a command.
PS3='?# '         # selection prompt used within a select loop.
PS4='+%N:%i:%_> ' # the execution trace prompt (setopt xtrace). default: '+%N:%i>'

PROMPT="${RED}${EXITCODE}${CYAN}${JOBS}${YELLOW}%* ${RED}%n${BLUE}@%m:${GREEN}%40<...<%B%~%b%<<"'${vcs_info_msg_0_}'"
${YELLOW}%# ${NO_COLOUR}"

# }}}

hash -d doc=/usr/share/doc
hash -d log=/var/log
hash -d src=/usr/src

function 0 {
	wget -c http://0rz.tw/$1;
}
function mydict () {
    dictl "$@" 2>&1 | colorit | less -R ;
}
function dormvga () {
    xrandr --output VGA --mode 1024x768 --below LVDS;
}
function labvga () {
    xrandr --output VGA --mode 1280x1024 --below LVDS;
}

# No used trash
# zstyle :compinstall filename '/home/kanru/.zshrc'
