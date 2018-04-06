# .bashrc
# -*- shell-script -*-

[ -f /etc/bashrc ] && source /etc/bashrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#Bind commands
## bind 'set completion-ignore-case on'
## bind 'set show-all-if-ambiguous on'

#Exports and things
## export HISTIGNORE="&:ls:exit:lo:ll:history"
export HISTIGNORE="exit::history"
export HISTCONTROL=erasedups
export HISTSIZE=10000
shopt -s histappend

shopt -s checkwinsize
# complete on a single <tab>
set show-all-if-ambiguous on
#set show-all-if-unmodified on

function maybe_source {
    [ -r "$1" ] && source "$1"
}

maybe_source /usr/local/etc/bash_completion
[[ -x $HOME/bin/sssh ]] && type -t _ssh >/dev/null && complete -F _ssh sssh
maybe_source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash

#Display a PDF of a given man page
function pdfman() {
        man -t $@ | pstopdf -i -o /tmp/$1.pdf && open /tmp/$1.pdf
}

#Aliases that do things
## alias ip='ipconfig getifaddr en0'
## alias ipext='curl -s http://checkip.dyndns.org/ | grep -o '[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*.[0-9]*''
## alias ll='ls -AlhG'
alias ls='ls -F'
alias ll='ls -l'
## alias egrep='egrep --color=auto'
## alias fgrep='fgrep --color=auto'
## alias grep='grep --color=auto'
## alias h='history'
alias hg='history | grep'
## alias vi='/usr/bin/vim'
## alias texted='open /Applications/TextEdit.app'
## alias rot13="tr '[A-Za-z]' '[N-ZA-Mn-za-m]'"
## alias psgrep='ps aux |grep -v grep |grep -i'
alias psgrep='ps -ef | grep -v grep | grep'
alias null='cat >/dev/null'
alias Z=suspend
alias uncolor='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'
alias kbprod='kubectl --context=bf2-prod'
alias kbdev='kubectl --context=bf2-dev'
alias kbtest='kubectl --context=bf2-test'
alias whatismyip='curl http://neuropunks.org/~cryptographrix/ 2>/dev/null && echo'

if [[ -d /home/tumblr-push ]]; then
    # pushshell related
    alias pscp="sudo scp -i /home/tumblr-push/.ssh/id_rsa -P 2222"
fi

if [[ -d /etc/mock ]]; then
    alias mock5='mock -r centos-5.8-x86_64'
    alias mock6='mock -r SL-6-x86_64'
    alias mock7='mock -r SL-7-x86_64'
fi

# prompt as I like even when puppet testing
# use ~marantz instead of $HOME for sudo -s
pc=~marantz/src/dotfile/prompt-command
if [[ -r $pc ]]; then
   unset PROMPT_COMMAND
   . $pc
fi
unset pc

PATH="/Users/marantz/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/marantz/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/marantz/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/marantz/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/marantz/perl5"; export PERL_MM_OPT;
