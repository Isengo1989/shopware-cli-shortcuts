#!/bin/bash

# Defines the path to your SW console executeable
DOCROOT="/var/www/shopware"

# Asks after every execution if you want to stay in script | 0 = off | 1 = on
STAY=0

# If you want to choose between shops uncomment this and set paths to your instances
#ESC=$(printf "\e")
#PS3="$ESC[42m $ESC[97m $ESC[1m Please choose your shop: $ESC[0m"
#options=("Shop1" "Shop2" "Shop3" "Quit")
#select opt in "${options[@]}"
#do
#    case $opt in
#        "Shop1")
#            DOCROOT="/var/www/shop1"
#            break
#            ;;
#        "Shop2")
#            DOCROOT="/var/www/shop2"
#            break
#            ;;
#         "Shop3")
#            DOCROOT="/var/www/shop3"
#            break
#            ;;
#        "Quit")
#            echo "Use default shop"
#            break
#            ;;
#        *) echo invalid option;;
#    esac
#done

CONSOLE="php $DOCROOT/bin/console"

#DIR="$(cd "$(dirname "$0")" && pwd)" TODO change path for Symlink
DIR="$(dirname "$(readlink -f "$0")")"

# comment will simply generate the shell output Headline
function comment {
test=${#1}
init="###"

while [ $test -gt 0 ]
do
   init=$init"#"
   test=$((test-1))
done

echo -e "\n"$init"###"
echo -e "## $1 ##"
echo -e $init"###\n"

}

# SNIPPET START

function missingsnippets {
echo -n "Enter locale [e.g. de_CH or fr_CH]: "
read locale
$CONSOLE sw:snippets:find:missing $locale
echo ".ini Files will be in snippetsExport of your Script"
}

function importsnippets {
echo -n "Enter folder from your Shopware Root Path [e.g. snippets]: "
read folder
$CONSOLE sw:snippets:to:db --source $folder
echo "Check your database"
}

function exportsnippets {
echo -n "Enter locale [e.g. de_CH or fr_CH]: "
read locale
$CONSOLE sw:snippets:to:ini $locale
echo ".ini Files will be in snippetsExport of your Shop Root"
}


function snippet {
ESC=$(printf "\e")
PS3="$ESC[42m $ESC[97m $ESC[1m Please choose your snippet options: $ESC[0m"
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
}
# SNIPPET END

# PLUGIN START
function pluginhelper {
$CONSOLE sw:plugin:$1 $2
}

function pluginparams {
echo -n "Enter plugin name [ENTER]: "
read pname
pluginhelper $1 $pname
}

function plugin {
  ESC=$(printf "\e")
  PS3="$ESC[41m $ESC[97m $ESC[1m Please choose your plugin options: $ESC[0m"
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
}


function compile {
echo -n "Enter Shop Id [id | id1,id2,id3 | all]: "
read id

if [[ $id = *","* ]]; then
    for i in $(echo $id | tr ',' '\n')
    do
    $CONSOLE sw:theme:cache:generate --shopId=$i
    done
elif [[ $id = "all" ]]; then
$CONSOLE sw:theme:cache:generate
else
$CONSOLE sw:theme:cache:generate --shopId=$id
fi
}

function warmup {

echo -n "See List of all Shops? [y/n]: "
read id
if [[ $id == 'y' ]]; then
$CONSOLE dbal:run-sql "SELECT id,name FROM s_core_shops WHERE active = 1"
fi

echo -n "Enter Shop Id [ENTER]: "
read id

if [[ $id = *","* ]]; then
    for i in $(echo $id | tr ',' '\n')
    do
    $CONSOLE sw:warm:http:cache $i
    done
else
$CONSOLE sw:warm:http:cache $id
fi
}

function grunter {
echo "Dump grunt json Files in web/cache"
$CONSOLE sw:theme:dump:configuration

echo "Clear http cache"
$CONSOLE sw:cache:clear

echo "Clear cache with clear_cache.sh"
/bin/sh $DOCROOT/var/cache/clear_cache.sh


echo -n "Enter Shop Id [ENTER]: "
read id

cd $DOCROOT/themes && gnome-terminal -x bash -c "grunt --shopId=$id"
}

comment "Shopware CLI Shortcuts"
ESC=$(printf "\e")
PS3="$ESC[44m $ESC[97m $ESC[1m Please choose your options: $ESC[0m"
options=("Theme compiling" "Clear cache" "Plugin [Options]" "Show cronjobs" "Warmup Cache" "Snippets" "Grunt" "Quit")
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
            $CONSOLE sw:cache:clear
            break
            ;;
         "Plugin [Options]")
            comment "PLUGINS"
            plugin
            break
            ;;
        "Show cronjobs")
            $CONSOLE  sw:cron:list
            break
            ;;
        "Warmup Cache")
            warmup
            break
            ;;
        "Snippets")
            comment "SNIPPETS"
            snippet
            break
            ;;
        "Grunt")
            comment "Grunt"
            grunter
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
if [[ $STAY == 1 ]]; then
  echo -n "Are you done? [y/n]: "
  read option
  if [[ $option == 'y' ]]; then
  exit 0
  elif [[ $option == 'n' ]]; then
  $DIR/run.sh
  fi
else
$DIR/run.sh
fi
