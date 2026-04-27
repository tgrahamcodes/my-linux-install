#!/bin/bash
# ============================================================
# packages.sh - Install and remove packages
# ============================================================

#source "./config.sh"

run_packages() {

    # ============================================================
    # SYSTEM UPDATE
    # ============================================================
    echo "[+] Updating system packages..."
    eval "$PKG_UPDATE" > /dev/null 2>&1
    echo "[OK] System updated"

    # ============================================================
    # YAY (AUR HELPER) - Arch only, install if not present
    # ============================================================
    if [ "$DISTRO" = "arch" ]; then
        if ! command -v yay &> /dev/null; then
            echo "[+] Installing yay AUR helper..."
            sudo pacman -S --noconfirm --quiet git base-devel > /dev/null 2>&1
            git clone https://aur.archlinux.org/yay.git /tmp/yay > /dev/null 2>&1
            cd /tmp/yay && makepkg -si --noconfirm > /dev/null 2>&1
            cd - > /dev/null
            echo "[OK] yay installed"
        else
            echo "[OK] yay already installed"
        fi
    fi

    # ============================================================
    # FLATPAK - Ensure Flathub is configured
    # ============================================================
    echo "[+] Setting up Flatpak and Flathub..."
    $PKG_INSTALL flatpak > /dev/null 2>&1
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo > /dev/null 2>&1
    echo "[OK] Flatpak configured"

    # ============================================================
    # REMOVE BLOATWARE - KDE default apps we don't need
    # ============================================================
    echo "[+] Removing unwanted default applications..."

    if [ "$DISTRO" = "arch" ]; then
        REMOVE_PKGS=(
            libreoffice-fresh libreoffice-still
            kde-games ksudoku kmines kpat kshisen ksquares kblocks kbounce
            kapman kdiamond kgoldrunner kiriki kjumpingcube klickety klines
            lskat palapeli picmi
            elisa amarok
            kmail kontact korganizer akonadi akonadi-calendar akonadi-contacts
            kdenlive dragon dragonplayer
            okular gwenview
            konversation
            konsole xterm yakuake
            krunner
        )
    elif [ "$DISTRO" = "debian" ]; then
        REMOVE_PKGS=(
            libreoffice
            aisleriot gnome-games
            rhythmbox
            kmail kontact
            kdenlive
            totem
            eog
            konversation
            gnome-terminal xterm
        )
    fi

    for pkg in "${REMOVE_PKGS[@]}"; do
        $PKG_REMOVE "$pkg" > /dev/null 2>&1 || true
    done
    echo "[OK] Bloatware removed"

    # ============================================================
    # BROWSER - Replace Firefox ESR with regular Firefox
    # ============================================================
    echo "[+] Installing Firefox..."
    $PKG_REMOVE firefox-esr > /dev/null 2>&1 || true
    $PKG_INSTALL firefox > /dev/null 2>&1
    echo "[OK] Firefox installed"

    # ============================================================
    # SHELL - Zsh, Oh My Zsh, Oh My Posh
    # ============================================================
    echo "[+] Installing Zsh and shell customization tools..."
    $PKG_INSTALL zsh > /dev/null 2>&1
    chsh -s $(which zsh)

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null 2>&1
    fi

    if [ "$DISTRO" = "arch" ]; then
        sudo pacman -S --noconfirm --quiet oh-my-posh > /dev/null 2>&1 || $AUR_INSTALL oh-my-posh-bin > /dev/null 2>&1
    elif [ "$DISTRO" = "debian" ]; then
        curl -s https://ohmyposh.dev/install.sh | bash -s > /dev/null 2>&1
    fi
    echo "[OK] Zsh configured"

    # ============================================================
    # TERMINAL - Alacritty
    # ============================================================
    echo "[+] Installing Alacritty terminal..."
    $PKG_INSTALL alacritty > /dev/null 2>&1
    echo "[OK] Alacritty installed"

    # ============================================================
    # APP LAUNCHER - Albert (Raycast alternative)
    # ============================================================
    echo "[+] Installing Albert launcher..."
    $AUR_INSTALL albert > /dev/null 2>&1
    echo "[OK] Albert installed"

    # ============================================================
    # EDITORS - Zed, VS Code, Neovim
    # ============================================================
    echo "[+] Installing code editors..."

    $AUR_INSTALL zed > /dev/null 2>&1 || true
    $AUR_INSTALL visual-studio-code-bin > /dev/null 2>&1 || true
    $PKG_INSTALL neovim git nodejs npm ripgrep fd > /dev/null 2>&1
    echo "[OK] Editors installed"

    # ============================================================
    # NERD FONTS
    # ============================================================
    echo "[+] Installing Nerd Fonts (this may take a while)..."
    $AUR_INSTALL nerd-fonts > /dev/null 2>&1
    echo "[OK] Nerd Fonts installed"

    # ============================================================
    # SYSTEM TOOLS - Cleaning and maintenance
    # ============================================================
    echo "[+] Installing system maintenance tools..."
    $PKG_INSTALL bleachbit > /dev/null 2>&1
    $AUR_INSTALL stacer > /dev/null 2>&1 || true
    $PKG_INSTALL pacman-contrib > /dev/null 2>&1 || true
    echo "[OK] System tools installed"

    # ============================================================
    # SNAPSHOTS - Timeshift
    # ============================================================
    echo "[+] Installing Timeshift..."
    $AUR_INSTALL timeshift > /dev/null 2>&1 || $PKG_INSTALL timeshift > /dev/null 2>&1
    echo "[OK] Timeshift installed"

    # ============================================================
    # GRAPHICS - GIMP
    # ============================================================
    echo "[+] Installing GIMP..."
    $PKG_INSTALL gimp > /dev/null 2>&1 || true
    echo "[OK] GIMP installed"

    # ============================================================
    # PROTON SUITE - Mail Bridge, Thunderbird, VPN, Drive
    # ============================================================
    echo "[+] Installing Proton applications..."
    $AUR_INSTALL proton-mail-bridge > /dev/null 2>&1 || true
    $PKG_INSTALL thunderbird > /dev/null 2>&1
    $AUR_INSTALL protonvpn > /dev/null 2>&1 || true
    $AUR_INSTALL proton-drive > /dev/null 2>&1 || echo "[WARN] Proton Drive not found, skipping..."
    echo "[OK] Proton suite installed"
}
