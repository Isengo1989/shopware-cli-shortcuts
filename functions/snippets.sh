#!/bin/bash

. ./global.sh

function missingsnippets {
echo -n "Enter locale [e.g. de_CH or fr_CH]: "
read locale
$DOCROOT sw:snippets:find:missing $locale
echo ".ini Files will be in snippetsExport"
}

function importsnippets {
echo -n "Enter folder from your Shopware Root Path [e.g. snippets]: "
read folder
$DOCROOT sw:snippets:to:db --source $folder
echo "Check your database"
}

function exportsnippets {
echo -n "Enter locale [e.g. de_CH or fr_CH]: "
read locale
$DOCROOT sw:snippets:to:ini --source $folder
echo ".ini Files will be in snippetsExport"
}



ESC=$(printf "\e")
PS3="$ESC[42m $ESC[97m $ESC[1m Please choose your options: $ESC[0m"
options=("Export missing Snippets" "Import snippets" "Export snippets" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Export missing Snippets")
            missingsnippets
            break
            ;;
        "Import snippets")
            importsnippets
            break
            ;;
         "Export snippets")
            exportsnippets
            break
            ;;
        "Quit")
            echo "You are leaving snippets."
            exit
            ;;
        *) echo invalid option;;
    esac
done
