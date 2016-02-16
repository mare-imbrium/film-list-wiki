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
#      REVISION:  2016-02-16 19:30
#===============================================================================

year=2016
host=https://en.wikipedia.org/wiki/List_of_American_films_of_

while [ $year -gt 1930 ] ; do
    url="${host}${year}"
    echo $url
    curl "$url" > ${year}.html
    sleep 3
    (( year-- ))
done
