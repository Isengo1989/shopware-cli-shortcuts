#!/bin/bash

# Defines the path to your SW console executeable
DOCROOT="php /var/www/shopware/bin/console"

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
