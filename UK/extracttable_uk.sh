#!/usr/bin/env bash 
#===============================================================================
#
#          FILE: extracttable.sh 
# 
#         USAGE: extracttable.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 01/27/2016 23:37
#      REVISION:  2016-02-03 19:20
#===============================================================================

year=2016

while [ $year -gt 1930 ] ; do
    url="${year}.html"
    echo $url
    #sed -n '/<table class="wikitable sortable"/,/<\/table>/p' $url > "${year}.tbl"
    # 1997.html and earlier don't have sortable
    # there are other wikitables too such as minor releases and box office and failures etc
    #sed -n '/<table class="wikitable/,/<\/table>/p' $url > "${year}.tbl"
    sed -n '/<h2>.*Major_[Rr]eleases/,/<h2>/p' $url > "${year}.tbl"
    if [[ ! -s "${year}.tbl" ]]; then
        sed -n '/<table class="wikitable/,/<\/table>/p' $url > "${year}.tbl"
    fi
    
    wc -l "$year.tbl"
    (( year-- ))
done
echo "Checking for movies with no URL"
grep '^<td><i>[^<]' *.tbl
echo "If any rows appeared remove them from tbl files before running looptable.sh"
