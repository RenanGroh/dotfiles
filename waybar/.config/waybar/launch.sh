#! /bin/sh



# --------------------------------------
# Quit running waybar instances
# --------------------------------------

killall waybar

#---------------------------------------
# Load the config based on the username
# --------------------------------------

if [[ $USER = "renxn" ]]
then
    waybar -c ~/.dotfiles/waybar/myconfig & -s ~/.dotfiles/waybar.css
else
    waybar &
fi
