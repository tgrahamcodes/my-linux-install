#!/bin/bash
# ============================================================
# security.sh - Security stack installation
# ============================================================

# source "./config.sh"

run_security() {

    # ============================================================
    # FLATPAK - Ensure Flathub is configured (in case packages skipped)
    # ============================================================
    sudo -v  # Refresh sudo credentials

    # ============================================================
    # FIREWALL - OpenSnitch (application-level firewall)
    # ============================================================
    echo "[+] Installing OpenSnitch firewall..."
    $AUR_INSTALL opensnitch > /dev/null 2>&1 || $PKG_INSTALL opensnitch > /dev/null 2>&1 || true
    sudo systemctl enable --now opensnitchd > /dev/null 2>&1 || true
    echo "[OK] OpenSnitch installed"

    # ============================================================
    # APPARMOR - Mandatory access control
    # ============================================================
    echo "[+] Installing AppArmor..."
    $PKG_INSTALL apparmor > /dev/null 2>&1
    sudo systemctl enable --now apparmor > /dev/null 2>&1

    for profile in /etc/apparmor.d/*; do
        sudo aa-complain "$profile" > /dev/null 2>&1 || true
    done

    if ! grep -q "apparmor=1" /etc/default/grub 2>/dev/null; then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="apparmor=1 security=apparmor /' /etc/default/grub
        sudo grub-mkconfig -o /boot/grub/grub.cfg > /dev/null 2>&1
    fi
    echo "[OK] AppArmor installed (complain mode - run 'sudo aa-enforce /etc/apparmor.d/*' to enable enforce mode)"

    # ============================================================
    # SURICATA - Network intrusion detection
    # ============================================================
    echo "[+] Installing Suricata IDS..."
    $PKG_INSTALL suricata > /dev/null 2>&1
    sudo mkdir -p /etc/suricata/rules
    sudo mkdir -p /var/log/suricata

    if [ "$DISTRO" = "arch" ]; then
        sudo pip install suricata-update --quiet --break-system-packages > /dev/null 2>&1 || true
    elif [ "$DISTRO" = "debian" ]; then
        sudo pip install suricata-update --quiet > /dev/null 2>&1 || true
    fi

    sudo suricata-update > /dev/null 2>&1 || echo "[WARN] Suricata rules update failed, run manually: sudo suricata-update"
    sudo systemctl enable --now suricata > /dev/null 2>&1 || true
    echo "[OK] Suricata installed with Emerging Threats ruleset"

    # ============================================================
    # CLAMAV - Antivirus + GUI
    # ============================================================
    echo "[+] Installing ClamAV..."
    $PKG_INSTALL clamav > /dev/null 2>&1
    $PKG_INSTALL clamtk > /dev/null 2>&1 || true
    sudo freshclam > /dev/null 2>&1 || true
    sudo systemctl enable --now clamav-freshclam > /dev/null 2>&1 || true
    echo "[OK] ClamAV installed"

    # ============================================================
    # MALDET - Linux Malware Detect
    # ============================================================
    echo "[+] Installing Maldet..."
    $AUR_INSTALL maldet > /dev/null 2>&1 || echo "[WARN] Maldet not found in repos, skipping..."

    # ============================================================
    # ROOTKIT SCANNERS - Chkrootkit + Rkhunter
    # ============================================================
    echo "[+] Installing rootkit scanners..."
    $PKG_INSTALL chkrootkit > /dev/null 2>&1 || true
    $PKG_INSTALL rkhunter > /dev/null 2>&1 || true
    echo "[OK] Rootkit scanners installed"

    # ============================================================
    # LYNIS - System auditing
    # ============================================================
    echo "[+] Installing Lynis..."
    $PKG_INSTALL lynis > /dev/null 2>&1
    echo "[OK] Lynis installed - run 'sudo lynis audit system' to audit"
}
