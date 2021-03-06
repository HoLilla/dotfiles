#####################################################################
# Plugins                                                           #
#####################################################################

if not functions --query fisher
    set --query XDG_CONFIG_HOME; or set XDG_CONFIG_HOME "$HOME/.config"
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

#####################################################################
# Environment Variables                                             #
#####################################################################

# System Defaults
set --global --export EDITOR "vim"
set --global --export VISUAL "$EDITOR"
set --global --export LC_ALL "de_DE.UTF-8"
set --global --export LANG "$LC_ALL"

# XDG
set --global --export XDG_CONFIG_HOME "$HOME/.config"
set --global --export XDG_CACHE_HOME "$HOME/Library/Caches/"
set --global --export XDG_DATA_HOME "$HOME/.local/share"
set --global --export XDG_RUNTIME_DIR "$HOME/Library/Caches/run"

# Vim
set --global --export VIMINIT ":source $XDG_CONFIG_HOME"/vim/.vimrc

# GPG
set --global --export GNUPGHOME "$XDG_DATA_HOME/gnupg"
set --global --export GPG_TTY (tty)

# Favourites
set --global --export CODEDIR (grealpath $HOME/Code)

# Golang
set --global --export GOCODEDIR "$CODEDIR/golang"
set --global --export GOPATH "$GOCODEDIR"

# Git Duet
set --global --export GIT_DUET_CO_AUTHORED_BY "1"
set --global --export GIT_DUET_SET_GIT_USER_CONFIG "1"
set --global --export GIT_DUET_AUTHORS_FILE "$XDG_CONFIG_HOME/git-duet/authors.yml"

# pb-git-hooks
set --global --export GIT_AUTHORS_EXEC "GOOGLE_APPLICATION_CREDENTIALS=\"$XDG_CONFIG_HOME/gcloud/application_sops_credentials.json\" sops -d $XDG_CONFIG_HOME/git-authors/authors.yml"

# Shell Name
set --global --export SHELL_NAME "fish"

# Not committed
if [ -f "$HOME/.config/envsecret/envsecret.sourceable.fish" ]
    set OLD_IFS "$IFS"
    set IFS ""

    if set --query GOOGLE_APPLICATION_CREDENTIALS
      set --local GOOGLE_APPLICATION_CREDENTIALS_OLD "$GOOGLE_APPLICATION_CREDENTIALS"
      set GOOGLE_APPLICATION_CREDENTIALS_OLD "$GOOGLE_APPLICATION_CREDENTIALS"
    end

    set --global --export  GOOGLE_APPLICATION_CREDENTIALS "$XDG_CONFIG_HOME/gcloud/application_sops_credentials.json"
    set --local ENV_SECRETS (
      sops \
        exec-file \
        "$HOME/.config/envsecret/envsecret.sourceable.fish" \
        'cat "{}"'
    )
    if set --query GOOGLE_APPLICATION_CREDENTIALS_OLD
      set --global --export GOOGLE_APPLICATION_CREDENTIALS "$GOOGLE_APPLICATION_CREDENTIALS_OLD"
    else
      set --erase GOOGLE_APPLICATION_CREDENTIALS
    end

    eval "$ENV_SECRETS"
    set IFS "$OLD_IFS"
end

#####################################################################
# Path                                                              #
#####################################################################

set --global --export PATH "$GOCODEDIR/bin" $PATH
set --global --export PATH "$HOME/.bin" $PATH
set --global --export PATH (brew --prefix)"/opt/mysql-client/bin" $PATH
set --global --export PATH (brew --prefix)"/texlive/2019/bin/x86_64-darwin/" $PATH
set --global --export PATH "$HOME/.cargo/bin" $PATH

#####################################################################
# Autocomplete                                                      #
#####################################################################

brew command command-not-found-init > /dev/null; and . (brew command-not-found-init)

if type --quiet kitty
    kitty + complete setup fish | source $argv
end


#####################################################################
# Terminal Style                                                    #
#####################################################################

# Colours
set --global --export CLICOLOR 1
set --global --export LS_COLORS (dircolors -c $colorfile | string split ' ')[3]

# History Search
source (brew --prefix)"/opt/fzf/shell/key-bindings.fish"

## Starship
if type --quiet starship
    starship init fish | source
end

