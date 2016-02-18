#!/usr/bin/env bash 
#===============================================================================
#
#          FILE: extracttable.sh 
# 
#         USAGE: extracttable.sh 
# 
#   DESCRIPTION: extract table from htmls
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 01/27/2016 23:37
#      REVISION:  2016-02-18 10:41
#===============================================================================

year=$(date +%Y)
SOURCE="./html"
TARGET="./tbl"
echo "Starting with $year working back to 1930"

while [ $year -gt 1930 ] ; do
    url="${SOURCE}/${year}.html"
    echo $url
    #sed -n '/<table class="wikitable sortable"/,/<\/table>/p' $url > "${year}.tbl"
    # 1997.html and earlier don't have sortable
    sed -n '/<table class="wikitable/,/<\/table>/p' $url > "${TARGET}/${year}.tbl"
    wc -l "${TARGET}/$year.tbl"
    (( year-- ))
done

echo "checking if gross rank data has come in . e.g. 1961 1962, pls remove that table"
grep '<th>Rank' ${TARGET}/*.tbl
grep '<th>Gross' ${TARGET}/*.tbl
