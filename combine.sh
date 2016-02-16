#!/usr/bin/env bash 
#===============================================================================
#
#          FILE: combine.sh
# 
#         USAGE: ./combine.sh 
# 
#   DESCRIPTION: combining us and uk films and then importing
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 02/03/2016 19:26
#      REVISION:  2016-02-16 19:29
#===============================================================================

echo "Combining UK and USA files and then importing"
today=$(date +"%Y%m%d%H%M")
wc -l uk/film.tsv film.tsv 
if [[ ! -s "film.tsv" ]]; then
    echo "us file empty exiting"
    exit 1
fi
if [[ ! -s "uk/film.tsv" ]]; then
    echo "uk file empty exiting"
    exit 1
fi
sleep 5
cp all_film.tsv "all_film.tsv.$today.bak"
sort uk/film.tsv film.tsv > t.t
wc -l t.t
if [[ ! -s "t.t" ]]; then
    echo "sort file empty exiting"
    exit 1
fi
mv t.t all_film.tsv
./import_films.sh all_film.tsv
echo done
echo You may check database using check.sh
