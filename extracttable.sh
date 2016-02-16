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
#      REVISION:  2016-02-16 19:31
#===============================================================================

year=2016

while [ $year -gt 1930 ] ; do
    url="${year}.html"
    echo $url
    #sed -n '/<table class="wikitable sortable"/,/<\/table>/p' $url > "${year}.tbl"
    # 1997.html and earlier don't have sortable
    sed -n '/<table class="wikitable/,/<\/table>/p' $url > "${year}.tbl"
    wc -l "$year.tbl"
    (( year-- ))
done

echo "checking if gross rank data has come in . e.g. 1961 1962, pls remove that table"
grep '<th>Rank' *.tbl
grep '<th>Gross' *.tbl
