#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
HYPR_DIR="$DOTFILES_DIR/dots-hypr"
PKG_FILE="$HYPR_DIR/packages.txt"

log() { printf "[INFO] %s\n" "$1"; }
warn() { printf "[WARN] %s\n" "$1"; }
ok() { printf "[OK] %s\n" "$1"; }

install_packages() {
    local file="$1"
    local installer="$2"
    local query_cmd="$3"

    if [[ ! -f "$file" ]]; then
        warn "File '$file' not found, skipping."
        return
    fi

    log "Installing packages from '$file'..."
    readarray -t packages <"$file"
    for pkg in "${packages[@]}"; do
        [[ -z "$pkg" || "$pkg" == \#* ]] && continue
        if ! $query_cmd "$pkg" &>/dev/null; then
            log "Installing $pkg..."
            $installer "$pkg"
        else
            ok "$pkg already installed"
        fi
    done
}

log "Installing required packages..."

# Pacman packages
install_packages \
    "$PKG_FILE" \
    'sudo pacman -S --needed --noconfirm' \
    'pacman -Q'
