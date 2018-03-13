#!/bin/bash

. global.sh

function compile {
echo -n "Enter Shop Id [id | id1,id2,id3 | all]: "
read id

if [[ $id = *","* ]]; then
    for i in $(echo $id | tr ',' '\n')
    do
    $DOCROOT sw:theme:cache:generate --shopId=$i
    done
elif [[ $id = "all" ]]; then
$DOCROOT sw:theme:cache:generate
else
$DOCROOT sw:theme:cache:generate --shopId=$id
fi
}

function warmup {

echo -n "See List of all Shops? [y/n]: "
read id
if [[ $id == 'y' ]]; then
$DOCROOT dbal:run-sql "SELECT id,name FROM s_core_shops WHERE active = 1"
fi

echo -n "Enter Shop Id [ENTER]: "
read id

if [[ $id = *","* ]]; then
    for i in $(echo $id | tr ',' '\n')
    do
    $DOCROOT sw:warm:http:cache $i
    done
else
$DOCROOT sw:warm:http:cache $id
fi
}

comment "Shopware CLI Shortcuts"
ESC=$(printf "\e")
PS3="$ESC[44m $ESC[97m $ESC[1m Please choose your options: $ESC[0m"
options=("Theme compiling" "Clear cache" "Plugin [Options]" "Show cronjobs" "Warmup Cache" "Snippets" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Theme compiling")
            comment "Theme compiling"
            compile
            break
            ;;
        "Clear cache")
            comment "Clear cache"
            $DOCROOT sw:cache:clear
            break
            ;;
         "Plugin [Options]")
            comment "PLUGINS"
            ./plugins.sh
            break
            ;;
        "Show cronjobs")
            $DOCROOT  sw:cron:list
            break
            ;;
        "Warmup Cache")
            warmup
            break
            ;;
        "Snippets")
            comment "SNIPPETS"
            ./snippets.sh
            break
            ;;
        "Quit")
            echo "Bye,bye...(Visit my blog and show some <3 - https://the-cake-shop.de/)"
            exit
            ;;
        *) echo invalid option;;
    esac
done

#Stay or leave
echo -n "Are you done? [y/n]: "
read option
if [[ $option == 'y' ]]; then
exit 0
elif [[ $option == 'n' ]]; then
./sw.sh
fi
