.DEFAULT_GOAL := show-help
THIS_FILE := $(lastword $(MAKEFILE_LIST))
ROOT_DIR:=$(shell dirname $(realpath $(THIS_FILE)))

.PHONY: show-help
# See <https://gist.github.com/klmr/575726c7e05d8780505a> for explanation.
## This help screen
show-help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)";echo;sed -ne"/^## /{h;s/.*//;:d" -e"H;n;s/^## //;td" -e"s/:.*//;G;s/\\n## /---/;s/\\n/ /g;p;}" ${MAKEFILE_LIST}|LC_ALL='C' sort -f|awk -F --- -v n=$$(tput cols) -v i=29 -v a="$$(tput setaf 6)" -v z="$$(tput sgr0)" '{printf"%s%*s%s ",a,-i,$$1,z;m=split($$2,w," ");l=n-i;for(j=1;j<=m;j++){l-=length(w[j])+1;if(l<= 0){l=n-i-length(w[j])-1;printf"\n%*s ",-i," ";}printf"%s ",w[j];}printf"\n";}'

.PHONY: setup-home
## Install and link all packages for home
setup-home:
	cp dotbot/tools/git-submodule/install "$(ROOT_DIR)/install"
	"$(ROOT_DIR)/install"

.PHONY: setup-work
## Install and link all packages for work
setup-work: setup-home
	./git/bin/copy-work

.PHONY: generate-secret-envs
## Generate secrets env file from 1password
generate-secret-envs:
		"$(ROOT_DIR)/1password/bin/generate-envsecret"

.PHONY: format
## Format what we can
format: format-shell format-brewfile format-markdown format-yaml

.PHONY: format-markdown
## Format markdown files
format-markdown:
	fish -c "cd $(ROOT_DIR)/ && gfmfmt **.md"

.PHONY: format-shell
## Format shell scripts
format-shell:
	shfmt -w -s $(shell shfmt -f $(shell find "$(ROOT_DIR)" -maxdepth 1 -mindepth 1 -type d -not -name dotbot ))
	find "$(ROOT_DIR)" -name "*.fish" -o -name "*.fish.template" -exec fish_indent -w {} \;

.PHONY: format-brewfile
## Orders the brew file
format-brewfile:
	cat $(ROOT_DIR)/brew/Brewfile | sort | uniq | sed '/^[[:space:]]*$$/d' > $(ROOT_DIR)/brew/Brewfile.1
	mv $(ROOT_DIR)/brew/Brewfile.1 brew/Brewfile
	grep '^t' $(ROOT_DIR)/brew/Brewfile > brew/Brewfile.1
	grep -v '^t' $(ROOT_DIR)/brew/Brewfile >> $(ROOT_DIR)/brew/Brewfile.1
	mv $(ROOT_DIR)/brew/Brewfile.1 $(ROOT_DIR)/brew/Brewfile

.PHONY: format-yaml
## Format any yaml files
format-yaml:
	fish -c "prettier --write **.yml **.yaml"

.PHONY: fish-generate-gnu-utils-functions
## Regenerate the config files for gnu utils in fish
generate-gnu-utils-functions:
	"$(ROOT_DIR)/fish/bin/generate-gnu-utils-functions"
