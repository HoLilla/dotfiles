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

# XDG
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/Library/Caches/"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_RUNTIME_DIR "$HOME/Library/Caches/run"

# Vim
set -gx VIMINIT ":source $XDG_CONFIG_HOME"/vim/.vimrc

# GPG
set -gx GNUPGHOME "$XDG_DATA_HOME/gnupg"
set -gx GPG_TTY (tty)

# Favourites
set -gx CODEDIR (grealpath $HOME/Code)

# Golang
set -gx GOCODEDIR "$CODEDIR/golang"
set -gx GOPATH "$GOCODEDIR"

# Git Duet
set -gx GIT_DUET_CO_AUTHORED_BY "1"
set -gx GIT_DUET_SET_GIT_USER_CONFIG "1"
set -gx GIT_DUET_AUTHORS_FILE "$XDG_CONFIG_HOME/git-duet/authors.yml"

# Shell Name
set -gx SHELL_NAME "fish"

# Not committed
if [ -f "$HOME/.config/envsecret/envsecret.sourceable.fish" ]
    eval (
      sops \
        exec-file \
        "$HOME/.config/envsecret/envsecret.sourceable.fish" \
        'cat "{}"'
    )
end

#####################################################################
# Path                                                              #
#####################################################################

set -gx PATH "$GOCODEDIR/bin" $PATH
set -gx PATH "$HOME/.bin" $PATH
set -gx PATH "/usr/local/opt/mysql-client/bin" $PATH
set -gx PATH "/usr/local//texlive/2019/bin/x86_64-darwin/" $PATH

#####################################################################
# Autocomplete                                                      #
#####################################################################

brew command command-not-found-init > /dev/null; and . (brew command-not-found-init)

if type -q kitty
    kitty + complete setup fish | source $argv
end


#####################################################################
# Terminal Style                                                    #
#####################################################################

# Colours
set -gx CLICOLOR 1
set -gx LS_COLORS (dircolors -c $colorfile | string split ' ')[3]

if type -q starship
    starship init fish | source
end

