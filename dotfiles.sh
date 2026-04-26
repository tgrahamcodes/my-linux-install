#!/bin/bash

apply_configs() {
    echo "[+] Applying dotfiles"

    # get script directory (repo root)
    BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    DOTFILES="$BASE_DIR/dotfiles"

    if [ ! -d "$DOTFILES" ]; then
        echo "[WARN] dotfiles folder not found at $DOTFILES"
        return
    fi

    # ============================================================
    # ZSH
    # ============================================================
    if [ -f "$DOTFILES/zsh/.zshrc" ]; then
        cp -f "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
        echo "[OK] zsh"
    else
        echo "[SKIP] zsh"
    fi

    # ============================================================
    # KITTY
    # ============================================================
    if [ -d "$DOTFILES/kitty/.config/kitty" ]; then
        mkdir -p "$HOME/.config/kitty"
        cp -rf "$DOTFILES/kitty/.config/kitty/"* "$HOME/.config/kitty/"
        echo "[OK] kitty"
    else
        echo "[SKIP] kitty"
    fi

    # ============================================================
    # NVIM
    # ============================================================
    if [ -d "$DOTFILES/nvim/.config/nvim" ]; then
        mkdir -p "$HOME/.config/nvim"
        cp -rf "$DOTFILES/nvim/.config/nvim/"* "$HOME/.config/nvim/"
        echo "[OK] nvim"
    else
        echo "[SKIP] nvim"
    fi

    # ============================================================
    # VSCODE
    # ============================================================
    if [ -d "$DOTFILES/vscode/.config/Code/User" ]; then
        mkdir -p "$HOME/.config/Code/User"
        cp -rf "$DOTFILES/vscode/.config/Code/User/"* "$HOME/.config/Code/User/"
        echo "[OK] vscode"
    else
        echo "[SKIP] vscode"
    fi

    # ============================================================
    # ZED
    # ============================================================
    if [ -d "$DOTFILES/zed/.config/zed" ]; then
        mkdir -p "$HOME/.config/zed"

        cp -rf "$DOTFILES/zed/.config/zed/." "$HOME/.config/zed/"

        echo "[OK] zed copied"
    else
        echo "[SKIP] zed missing"
    fi

    # ============================================================
    # EZA
    # ============================================================
    if [ -d "$DOTFILES/eza/.config/eza" ]; then
        mkdir -p "$HOME/.config/eza"
        cp -rf "$DOTFILES/eza/.config/eza/"* "$HOME/.config/eza/"
        echo "[OK] eza"
    else
        echo "[SKIP] eza"
    fi

    echo "[+] Dotfiles applied"
}
