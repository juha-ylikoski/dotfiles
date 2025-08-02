PREFIX ?= /usr
BINDIR ?= $(PREFIX)/bin
SHAREDIR ?= $(PREFIX)/share/hyprevents

current_dir = $(shell pwd)


install: ~/.config/hypr \
	~/.config/kitty \
	~/.config/mako \
	~/.config/swaylock \
	~/.config/waybar \
	~/.config/wlogout \
	~/.config/wofi \
	~/.config/nvim \
	~/.config/htop \
	~/.bashrc \
	~/.config/mimeapps.list


.PHONY: ~/.bashrc
~/.bashrc:
	bash -c 'if ! grep -q "source ~/dotfiles/.config/shell/bashrc" ~/.bashrc;then echo "installing bashrc" && echo "source ~/dotfiles/.config/shell/bashrc"  >> ~/.bashrc ;fi'

~/.config/nvim:
	git clone https://github.com/juha-ylikoski/kickstart.nvim.git ~/.config/nvim

~/.config/%:
	ln -s $(current_dir)/.config/$(shell basename $@) $@

hyprcwd:
	@install -Dm755 pkgs/hyprcwd --target-directory "$(BINDIR)"
