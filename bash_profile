# stuff done only once in top level shell

[[ -r "$HOME/src/dotfile/bash_path" ]] && source "$HOME/src/dotfile/bash_path"

# must do before interactive shell test
# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# if not an interactive shell, we are done
[ -z "$PS1" ] && return

## [[ -x /usr/bin/emacs ]] && export EDITOR="/usr/bin/emacs"
## [[ -x "$HOME/bin/emacs" ]] && export EDITOR="$HOME/bin/emacs"
if [[ -x /usr/bin/less ]]; then
   export PAGER=/usr/bin/less
   export LESS='eiMqRwX'
fi
[[ -x $HOME/go ]] && export GOPATH="$HOME/go"

# Hiding the beer mug emoji when finishing a build
#export HOMEBREW_NO_EMOJI=1

function maybe_source {
    [ -r "$1" ] && source "$1"
}

maybe_source "$HOME/.bashrc"

# only do this for login shells since I don't use brew much
if [[ -x "/usr/local/bin/brew" ]]; then
    maybe_source `brew --repository`/Library/Contributions/brew_bash_completion.sh
fi
