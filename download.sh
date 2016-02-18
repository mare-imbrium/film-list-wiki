#!/usr/bin/env bash 
#===============================================================================
#
#          FILE: download.sh
# 
#         USAGE: ./download.sh 
# 
#   DESCRIPTION: download list of american films for each year
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 01/27/2016 23:37
#      REVISION:  2016-02-18 10:37
#===============================================================================

year=$(date +%Y)
echo starting with $year
host=https://en.wikipedia.org/wiki/List_of_American_films_of_

TARGET=html
mkdir $TARGET
echo downloading to dir $TARGET

while [ $year -gt 1930 ] ; do
    url="${host}${year}"
    echo $url
    curl "$url" > ./${TARGET}/${year}.html
    sleep 3
    (( year-- ))
done
