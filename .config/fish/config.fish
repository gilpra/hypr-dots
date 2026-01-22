# Jika sesi login dan berada di tty1
if status is-login
    if test -z "$DISPLAY" && test (tty) = /dev/tty1
        exec Hyprland
    end
end

# Inisialisasi Starship jika sesi interaktif
if status --is-interactive
    starship init fish | source
    zoxide init fish | source
end


# Menampilkan Fastfetch jika terminal adalah foot
function fish_greeting
    if test "$TERM" = alacritty
        fastfetch -c ~/.config/fastfetch/presets/simple.jsonc
    end
end

###########
## ALIAS ##
###########

alias c=clear
alias mi=micro
alias start='sudo systemctl start '
alias stop='sudo systemctl stop '
alias ff=fastfetch
alias fishconfig='micro ~/.config/fish/config.fish'

# Paket manajemen
alias paccek='yay -Q | grep '
alias upgrade='yay -Syu && flatpak upgrade'

# Git
alias gi='git init'
alias gs='git status'
alias ga='git add .'
alias gcm='git commit -m '
alias gp='git push'
alias gc='git clone '
alias gf='git fetch'
alias grh='git reset --hard '
alias grr='git remote remove '

# Perintah sistem
alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias hw='hwinfo --short' # Informasi hardware
alias update='sudo pacman -Syu'
alias mirror="sudo cachyos-rate-mirrors"
alias ls='eza -al --color=always --group-directories-first --icons' # Pengganti ls dengan eza

# Membersihkan orphaned packages
function cleanup
    set orphaned (pacman -Qtdq)
    if test -n "$orphaned"
        sudo pacman -Rns $orphaned
    else
        echo "There are no packages to clean."
    end
end

# Mendapatkan error dari journalctl
alias jctl="journalctl -p 3 -xb"
alias clrjctl="sudo journalctl --vacuum-time=1s"

