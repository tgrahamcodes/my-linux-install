#!/bin/bash

SCRIPT_DIR="."

source "$SCRIPT_DIR/wifi.sh"
source "$SCRIPT_DIR/packages.sh"
source "$SCRIPT_DIR/security.sh"
source "$SCRIPT_DIR/dotfiles.sh"


run_pipeline() {

    echo "[+] Starting install pipeline"

    wifi_setup
    # ============================================================
    # PACKAGES GATE
    # ============================================================
    read -p "Install ALL packages? (y/n): " pkg_ans
    if [[ "${pkg_ans,,}" == "y" ]]; then
        run_packages
    else
        echo "[SKIP] packages"
    fi

    # ============================================================
    # SECURITY GATE
    # ============================================================
    read -p "Install security stack? (y/n): " sec_ans
    if [[ "${sec_ans,,}" == "y" ]]; then
        run_security
    else
        echo "[SKIP] security"
    fi

    # ============================================================
    # DOTFILES GATE
    # ============================================================
    read -p "Apply dotfiles config? (y/n): " dot_ans
    if [[ "${dot_ans,,}" == "y" ]]; then
        apply_configs
    else
        echo "[SKIP] dotfiles"
    fi

    echo ""
    echo "========================"
    echo "INSTALL COMPLETE"
    echo "========================"
}
