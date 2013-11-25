# Advice: put .zshrc,.history in Dropbox, then symlink them

# Go crazy on these, why limit it?
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/Dropbox/git/dotfiles/.history

#------------------------------------------
# Options
#------------------------------------------
# why would you type 'cd dir' if you could just type 'dir'?
setopt AUTO_CD

# If I type cd and then cd again, only save the last one
setopt HIST_IGNORE_DUPS APPEND_HISTORY INC_APPEND_HISTORY SHARE_HISTORY

zmodload zsh/complist
autoload -U compinit && compinit
autoload -U zmv         # mv on stereoids

#------------------------------------------
# Autocompletion
#------------------------------------------
zstyle ':completion:::::' completer _complete _approximate
zstyle ':completion:*' menu select

zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*' verbose yes

# allow approximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# colorizer auto-completion for kill
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"

# case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
#zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete
zstyle ':completion:*' completer _expand _force_rehash _complete _approximate _ignored

# generate descriptions with magic.
zstyle ':completion:*' auto-description 'specify: %d'

# Don't prompt for a huge list, page it!
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Don't prompt for a huge list, menu it!
zstyle ':completion:*:default' menu 'select=0'

# Have the newer files last so I see them first
zstyle ':completion:*' file-sort modification reverse

# color code completion!!!!  Wohoo!
zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=36=31"

#------------------------------------------
# Colors
#------------------------------------------
# set colors to make terminal pretty!

autoload colors; colors
export CLICOLOR=1

export LS_OPTIONS='--color=auto'
export LSCOLORS=Exfxcxdxbxegedabagacad

PROMPT="%{$fg[cyan]%}[%n@%m] % ~%{$reset_color%} "
RPROMPT="[%{$fg[yellow]%}%3c%{$reset_color%}][%{$fg[red]%}%?%{$reset_color%}]" # prompt for right side of screen

#------------------------------------------
# Key Bindings
#------------------------------------------
# From http://zshwiki.org/home/zle/bindkeys

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}
key[ShiftedLeft]=${terminfo[kLFT]}
key[ShiftedRight]=${terminfo[kRIT]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
bindkey '^R' history-incremental-search-backward
bindkey '^E' history-incremental-search-forward

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
function zle-line-init () {
    echoti smkx
}
function zle-line-finish () {
    echoti rmkx
}
zle -N zle-line-init
zle -N zle-line-finish



setopt no_list_beep

# directory in titlebar
chpwd() {
  [[ -t 1 ]] || return
  case $TERM in
    sun-cmd) print -Pn "\e]l%~\e\\"
      ;;
    *xterm*|rxvt|(dt|k|E)term) print -Pn "\e]2;%~\a"
      ;;
  esac
}

# call chpwd when first loaded
chpwd

extract () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar x $1     ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.txz)       tar Jxvf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)           echo "don't know how to extract '$1'..." ;;
      esac
  else
      echo "'$1' is not a valid file!"
  fi
}

#------------------------------------------
# Sam's own stuff to follow
# Aliases
#------------------------------------------
source ~/.zshrc_private

alias vi='vim'
alias ls='ls -ltrah'
alias psx="ps aux | grep -i" 
alias reload="source ~/.zshrc"

# Play safe!
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

# Typos
alias cd..="cd .."

alias history='history -n 99'
alias flushdns="sudo killall -HUP mDNSResponder; dscacheutil -flushcache"

alias sshprint='~/sshprint.sh'
alias sshprintstaple='~/sshprintstaple.sh'
alias alert='~/alert.sh'

[[ -s "/Users/wongsam/.rvm/scripts/rvm" ]] && source "/Users/wongsam/.rvm/scripts/rvm"  # This loads RVM into a shell session.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
alias gotosandbox='cd ~/Dropbox/Computing/Sandbox/'

# Plain lazy
alias 1='ping www.google.com'
alias 11='while [ 1 ]; do; sleep 1; ping www.google.com; done;' 


# SSHs
#alias sshkathy='ssh kathy@192.168.1.105'
alias sshkathy='ssh -L 8081:localhost:8080 -L 8889:localhost:5900 -L 8888:localhost:8888 -D 60001 -p 60022 kathy@blah.samwong.hk'
alias sshkathyDirect='ssh kathy@kathypc.samwong.hk'
alias sshpeter='ssh peter@peterpc.samwong.hk'
alias sshsam='ssh sam@sampc.samwong.hk'
alias sshmacbook='ssh samwong@Sam-Wongs-Awesome-MacBook.local'
#alias sshmacbook='ping -noq -c 3 -t 2 192.168.0.10 > /dev/null; if [ $? -eq 0 ]; then; ssh sam@192.168.0.10; else; ssh sam@192.168.0.5; fi;'
#alias sshamazon='ssh -D 60001 ubuntu@ec2-54-242-39-159.compute-1.amazonaws.com'
alias sshamazon='ssh -D 60001 -i HomepageKey.pem ubuntu@ec2-54-242-39-159.compute-1.amazonaws.com'
alias sshskld='ssh -D 60001 sw2309@shell1.doc.ic.ac.uk'
alias sshsklx='ssh -X sw2309@shell1.doc.ic.ac.uk'
#alias sshmacmini='ssh product@192.168.208.82'
alias sshgp='ssh -p 65022 dev@gaopeng000.com'
alias sshgps='ssh -t -p 65022 dev@gaopeng000.com "cd /home/dev/www/lp/lp/sam/; bash"'
alias sshskl='ssh sw2309@shell1.doc.ic.ac.uk'
alias sshhome='ssh -p 443 -D 60001 -i ~/.ssh/opensshprivate.ssh root@blah.samwong.hk'
alias sshlcd='ssh -X -D 60001 -p 8989 -i ~/.ssh/opensshprivate.ssh home@blah.samwong.hk'
alias sshlcddirect='ssh -X -D 60001 sam@lcd.samwong.hk'
alias sshpi='ssh pi@192.168.0.102'
alias sshCathedral='ssh -XYC sw2309@cathedral.ma.ic.ac.uk'
alias activateVirtualEnv='source ~/ENV/bin/activate'

# ssh - fu
alias wakehome='ssh -p 443 -i ~/.ssh/opensshprivate.ssh root@blah.samwong.hk "ether-wake 6C:F0:49:D8:30:27"'
alias checklog='~/Dropbox/Shared\ With\ Sam/logcheck'
alias livelog='sshkathy "tail -n 50 -F ~/Desktop/programV2/logs/catalina.out"'
alias stayon='while [ 1 ]; do; echo "connecting at `date`"; sshkathy; echo "disconnect at `date`"; sleep 1800; wakehome; done;'
alias rsynccmd="while [ 1 ];do date;wakehome;rsync -avzP --stats --progress --rsh='ssh -p60022' kathy@kathypc.samwong.hk:/path/to/source /path/to/destination; done;"
alias du='du -hd 1'


# Mount stuff
alias mountSkl='mkdir -p ~/MountPoints/DoC; sshfs sw2309@shell3.doc.ic.ac.uk:/homes/sw2309/ ~/MountPoints/DoC' 
alias mountMath='mkdir -p ~/MountPoints/Math; sshfs sw2309@cathedral.ma.ic.ac.uk:/home/ma/s/sw2309 ~/MountPoints/Math' 
alias mountMacbook='mkdir -p ~/MountPoints/Macbook; sshfs samwong@192.168.0.10:/ ~/MountPoints/Macbook' 
#alias mountMacbook='sudo mkdir /Volumes/all; ping -noq -c 3 -t 2 192.168.0.10 > /dev/null; if [ $? -eq 0 ]; then; echo "Ping succeed, mounting .10"; sudo mount_nfs -o vers=4,proto=tcp,port=2049 192.168.0.10:/ /Volumes/all; else; echo "Ping on .10 failed, mounting .5"; sudo mount_nfs -o vers=4,proto=tcp,port=2049 192.168.0.5:/ /Volumes/all; fi;'

#------------------------------------------
# PATH settings
#------------------------------------------
# Homebrew:
PATH=/usr/local/share/python:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH

# Rails
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# Custom bins
PATH=$PATH:$HOME/bin

# Newer git:
PATH=/usr/local/git/bin:$PATH

# Android
tePATH=$PATH:$ANDROID_HOME/platform-tools
