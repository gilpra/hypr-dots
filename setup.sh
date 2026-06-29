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

# Enable Fish shell
if command -v fish >/dev/null 2>&1; then
    current_shell=$(basename "$SHELL")
    if [[ "$current_shell" != "fish" ]]; then
        log "Setting fish as default shell..."
        if chsh -s "$(command -v fish)"; then
            ok "Fish shell activated"
        else
            warn "Failed to change shell, run 'chsh -s $(command -v fish)' manually."
        fi
    fi
fi

# Ensure stow installed
if ! command -v stow >/dev/null 2>&1; then
    log "stow not found, installing..."
    sudo pacman -S --needed --noconfirm stow
    ok "stow installed"
fi

log "Creating symlinks using stow..."
cd "$DOTFILES_DIR"
stow --target="$HOME" dots-hypr

ok "Setup completed"
