#####################################################################
# Plugins                                                           #
#####################################################################

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME "$HOME/.config"
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

#####################################################################
# Environment Variables                                             #
#####################################################################

# System Defaults
set -gx EDITOR "vim"
set -gx VISUAL "$EDITOR"
set -gx LC_ALL "de_DE.UTF-8"
set -gx LANG "$LC_ALL"

# GPG
set -gx GPG_TTY (tty)

# Favourites
set -gx CODEDIR (grealpath $HOME/Code)

# Golang
set -gx GOCODEDIR "$CODEDIR/golang"
set -gx GOPATH "$GOCODEDIR"

# Git Duet
set -gx GIT_DUET_CO_AUTHORED_BY "1"
set -gx GIT_DUET_GLOBAL "1"
set -gx GIT_DUET_SET_GIT_USER_CONFIG "1"

# Enhancd
set -gx ENHANCD_FILTER "fzf"
set -gx ENHANCD_DOT_SHOW_FULLPATH "1"

# fzf
set -gx FZF_DEFAULT_OPTS '--height 40% --cycle'

# Shell Name
set -gx SHELL_NAME "fish"

# Not committed
if [ -f "$HOME/.envsecret" ]
    source "$HOME/.envsecret"
end

#####################################################################
# Path                                                              #
#####################################################################

set -gx PATH "$GOCODEDIR/bin" $PATH
set -gx PATH "$HOME/.bin" $PATH
set -gx PATH "/usr/local/opt/mysql-client/bin" $PATH

#####################################################################
# Autocomplete                                                      #
#####################################################################

brew command command-not-found-init > /dev/null; and . (brew command-not-found-init)

#####################################################################
# Terminal Style                                                    #
#####################################################################

# Colours
set -gx CLICOLOR 1
set -gx LS_COLORS (dircolors -c $colorfile | string split ' ')[3]

starship init fish | source
test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

status --is-login; and status --is-interactive; and exec byobu-launcher