#!/usr/bin/env bash 
#===============================================================================
#
#          FILE: geturl.sh
# 
#         USAGE: ./geturl.sh <part of title>
# 
#   DESCRIPTION: fetches the URL for a movie title given pattern or part of movie title
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 01/28/2016 21:14
#      REVISION:  2016-01-28 23:57
#===============================================================================

# if person needs no ignore case then ? if too many matches e.g Kes
# also if year is passed then we need to query year too

PATT="$@"
sqlite3 urls.sqlite <<!
select url from url where title like "%${PATT}%";
!
