#!/bin/bash

# When WiFi doesn't setup automatically
wifi_setup() {
    read -p "Connect WiFi? (y/n): " c
    [[ "${c,,}" != "y" ]] && return

    read -s -p "WiFi Password: " pass
    echo

    nmcli dev wifi connect "$WIFI_SSID" password "$pass" \
        && echo "[OK] WiFi connected" \
        || echo "[FAIL] WiFi connection failed"
}
