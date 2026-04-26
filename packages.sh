PARALLEL_JOBS=3

run_parallel() {
    local func="$1"
    shift
    local -a pkgs=("$@")

    for ((i=0; i<${#pkgs[@]}; i+=PARALLEL_JOBS)); do
        for ((j=i; j<i+PARALLEL_JOBS && j<${#pkgs[@]}; j++)); do
            "$func" "${pkgs[j]}" &
        done
        wait
    done
}

ensure_yay() {
    if ! command -v yay &>/dev/null; then
        echo "[+] Installing yay..."

        sudo pacman -S --needed --noconfirm git base-devel

        rm -rf /tmp/yay
        git clone https://aur.archlinux.org/yay.git /tmp/yay

        (cd /tmp/yay && makepkg -si --noconfirm)

        hash -r
    fi
}

install_pacman_one() {
    local pkg="$1"
    [[ -z "$pkg" || "$pkg" == \#* ]] && return

    sudo pacman -S --needed --noconfirm "$pkg" \
        && echo "[OK pacman] $pkg" \
        || echo "[FAIL pacman] $pkg"
}

install_pacman() {
    mapfile -t pkgs < pkglists/pacman.txt

    for pkg in "${pkgs[@]}"; do
        install_pacman_one "$pkg"
    done
}

install_aur_one() {
    local pkg="$1"
    [[ -z "$pkg" || "$pkg" == \#* ]] && return

    yay -S --needed --noconfirm "$pkg" \
        && echo "[OK aur] $pkg" \
        || echo "[FAIL aur] $pkg"
}

install_aur() {
    mapfile -t pkgs < pkglists/aur.txt
    run_parallel install_aur_one "${pkgs[@]}"
}

install_all() {
    ensure_yay
    install_pacman
    install_aur

    sudo pacman -R --noconfirm firefox-esr 2>/dev/null || true
    sudo pacman -S --noconfirm firefox || true

    chsh -s "$(which zsh)" || true
}

run_packages() {
    ensure_yay
    install_pacman
    install_aur
}
