#!/bin/bash

##########################################################
#                                                        #
#  LaraShell is an bash script that allows you to quick  #
#  start your new awesome Laravel based app              #
#                                                        #
#  Author: Simonarde Lima (simonarde@gmail.com)          #
#                                                        #
##########################################################

PHP=$(which php)
GIT=$(which git)
WGET=$(which wget)

#Change this to your paths
COMPOSER="/path/to/composer.phar"
REPOS="/path/to/your/repos/folder"
PROJECTS="/path/to/your/projects/folder"


if [ $# -eq 0 ]
  then
    echo "You need to inform me the name of your new awesome app :-)"
    echo "Usage: larashell.sh your-new-app"
    exit 0
fi

# Creating repo
cd $REPOS
mkdir -p $REPOS/$1.git
cd $REPOS/$1.git
$(echo $GIT) init --bare $REPOS/$1.git

# Cloning repo to your projects folder
cd $PROJECTS
$(echo $GIT) clone file://$REPOS/$1.git $1

# Getting the latest version of Laravel Framework
cd $PROJECTS/$1
$(echo $WGET) http://cabinet.laravel.com/latest.zip
unzip latest.zip
rm $PROJECTS/$1/latest.zip

# Installing using Composer and making a copy of .env
cp -rp $PROJECTS/$1/.env.example $PROJECTS/$1/.env
$(echo $PHP) $COMPOSER install

# Generating a new key
$(echo $PHP) $PROJECTS/$1/artisan key:generate

# First Commit
cd $PROJECTS/$1
$(echo $GIT) add $PROJECTS/$1
$(echo $GIT) -c user.name='LaraShell' -c user.email='larashell@larashell' commit -m 'First Commit'

# Using Artisan's serve command to fire up your awesome app :-)
$(echo $PHP) $PROJECTS/$1/artisan serve