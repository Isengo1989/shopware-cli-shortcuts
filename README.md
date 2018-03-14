
# Shopware CLI Shortcuts

## Introduction

Simple Shellscript for CLI commands in Shopware. You can set up multiple Shops and execute multiple commands like **sw:cache:clear** with just an selection via **number** (1 for Theme compiling etc.)

![Shopware CLI Script](http://the-cake-shop.de/wp-content/uploads/2018/03/Auswahl_669.png)

## Usage
1. You need to set the right path of your Shopware Installation you want to use ($DOCROOT - line 4)
2. Set the right permissions (for example`chmod u+x sw.sh`)
3. Optional: `sudo ln -s /path/to/repo/run.sh /usr/local/bin/sw-cli` to create global executable
4. Run script by **./run.sh** or **sw-cli**

**Optional:** Uncomment line 6 to 31 for multiple shop selection
