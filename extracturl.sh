#!/usr/bin/env bash 
#===============================================================================
#
#          FILE: extracturl.sh
# 
#         USAGE: ./extracturl.sh 
# 
#   DESCRIPTION: extract urls and year from html files and put into a TSV file
#
#                This should be automated so that whenever we refresh all the htmls then this
#                can be run
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 01/28/2016 13:06
#      REVISION:  2016-01-28 19:56
#===============================================================================


echo extracting US urls
grep '<td><i><a href' *.tbl | gsed 's|\(^....\).*href="\([^"]*\)".*>\(.*\)</a>.*|\3	\1	USA	\2|' | grep -v "index.php" | sort -u  > us_urls.tsv
wc -l us_urls.tsv
cd UK
pwd
echo extracting UK urls
# if we extract from the html then we need to do a sort unique
grep '<td><i><a href' *.html | gsed 's|\(^....\).*href="\([^"]*\)".*>\(.*\)</a>.*|\3	\1	UK	\2|' | grep -v "index.php" | sort -u  > uk_urls.tsv

wc -l uk_urls.tsv
cd ..
sort us_urls.tsv UK/uk_urls.tsv > all_urls.tsv
wc -l all_urls.tsv
echo now u can import into table
