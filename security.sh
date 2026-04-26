setup_apparmor() {
    sudo pacman -S --needed --noconfirm apparmor
    sudo systemctl enable --now apparmor

    if ! grep -q "apparmor=1" /etc/default/grub; then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="apparmor=1 security=apparmor /' /etc/default/grub
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi
}

setup_opensnitch() {
    yay -S --needed --noconfirm opensnitch \
        || sudo pacman -S --needed --noconfirm opensnitch

    sudo systemctl enable --now opensnitchd || true
}

setup_suricata() {
    sudo pacman -S --needed --noconfirm suricata \
        || yay -S --needed --noconfirm suricata \
        || { echo "[FAIL] suricata not available"; return; }

    yay -S --needed --noconfirm suricata-update 2>/dev/null || true

    sudo mkdir -p /etc/suricata/rules /var/log/suricata

    suricata-update || true
    sudo systemctl enable --now suricata || true
}

optional_security() {
    read -p "Install extra security tools? (y/n): " s
    [[ "${s,,}" != "y" ]] && return

    sudo pacman -S --needed --noconfirm clamav clamtk rkhunter lynis

    yay -S --needed --noconfirm chkrootkit 2>/dev/null \
        || sudo pacman -S --needed --noconfirm chkrootkit || true

    yay -S --needed --noconfirm maldet 2>/dev/null || true

    sudo freshclam || true
    sudo systemctl enable --now clamav-freshclam || true
}

run_security() {
    setup_apparmor
    setup_opensnitch
    setup_suricata
    optional_security
}
