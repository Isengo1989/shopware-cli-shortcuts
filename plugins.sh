#!/bin/bash

. global.sh

function pluginhelper {
$DOCROOT sw:plugin:$1 $2
}

function pluginparams {
echo -n "Enter plugin name [ENTER]: "
read pname
pluginhelper $1 $pname
}


ESC=$(printf "\e")
PS3="$ESC[41m $ESC[97m $ESC[1m Please choose your options: $ESC[0m"
options=("List all" "Activate" "Deactivate" "Install" "Uninstall" "Refresh" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "List all")
            pluginhelper list
            break
            ;;
        "Activate")
            pluginparams activate
            break
            ;;
         "Deactivate")
            pluginparams deactivate
            break
            ;;
        "Install")
            pluginparams install
            break
            ;;
        "Uninstall")
            pluginparams uninstall
            break
            ;;
        "Refresh")
            pluginhelper refresh
            break
            ;;
        "Quit")
            echo "You are leaving plugins."
            exit
            ;;
        *) echo invalid option;;
    esac
done
