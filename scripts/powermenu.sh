#!/bin/bash
# Nebula Shell — Power Menu

options="Lock\nLogout\nSuspend\nReboot\nShutdown"

selected=$(echo -e "$options" | wofi --dmenu --prompt "Power Menu" --width 200 --height 250 --hide-search)

case $selected in
    Lock)
        hyprctl dispatch exit
        ;;
    Logout)
        hyprctl dispatch exit
        ;;
    Suspend)
        systemctl suspend
        ;;
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
esac
