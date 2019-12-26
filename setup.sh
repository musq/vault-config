#!/usr/bin/env bash

# https://superuser.com/a/202654

CURRENT_DIR="$(readlink -f $(dirname "${BASH_SOURCE[0]}"))"

DOMAIN="tug.ro"
USER="$(whoami)"

DOTFILES_SYSTEM_DIR="$CURRENT_DIR/../dotfiles-system"
DOTFILES_SYSTEM_GIT_REPO="https://github.com/musq/dotfiles-system.git"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Setup dotfiles-system dir

if [ ! -d "$DOTFILES_SYSTEM_DIR" ]; then

    git clone --recurse-submodules \
        "$DOTFILES_SYSTEM_GIT_REPO" \
        "$DOTFILES_SYSTEM_DIR"

fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Source utility functions

. "$DOTFILES_SYSTEM_DIR/src/os/utils.sh" \
    && . "$DOTFILES_SYSTEM_DIR/src/os/contract/utils.sh" \
    && . "$DOTFILES_SYSTEM_DIR/src/os/install/nix/utils.sh"

cd "$CURRENT_DIR"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Ask sudo password, if necessary

if [ "$(user_has_sudo)" != "no_sudo" ]; then
    ask_for_sudo
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Vault

print_in_purple "\n ● Vault\n\n"

nix_install "Vault" "nixpkgs.vault-bin"

execute \
    "setcap cap_ipc_lock=+ep $(readlink -f $(which vault))" \
    "Allow Vault to use mlock" \
    "sudo"

add_user "vault" "Vault" "system"

harden "/var/lib/vault" "vault" "vault" 640 750
harden "/var/log/vault" "vault" "vault" 640 750

create_symlink "$(pwd)/vault.service" "/lib/systemd/system/vault.service" "-y"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Nginx

print_in_purple "\n ● Nginx\n\n"

create_symlink \
    "$(pwd)/$DOMAIN.vault.conf" \
    "/etc/nginx/conf.d/partials/$DOMAIN.vault.conf" "-y"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Systemd

print_in_purple "\n ● Systemd\n\n"

execute \
    "systemctl enable vault \
        && systemctl reload-or-restart vault" \
    "Reload Vault" \
    "sudo"

execute \
    "systemctl enable nginx \
        && systemctl reload-or-restart nginx" \
    "Reload Nginx" \
    "sudo"

print_in_purple "\n"
