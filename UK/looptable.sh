#!/usr/bin/env bash 
#===============================================================================
#
#          FILE: looptable.sh
# 
#         USAGE: ./looptable.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 01/29/2016 15:11
#      REVISION:  2016-02-04 14:43
#===============================================================================
out=film.tsv
#DIR=/Volumes/Pacino/dziga_backup/rahul/Downloads/MOV/amerfilms
if [[  -f "$out" ]]; then
    rm $out
fi
for file in *.tbl ; do
    echo $file
    ./table_uk.rb $file >> $out
done
echo removing index.php entries
grep -v index.php $out | sponge $out
wc -l $out
echo "Switching column 2 and 1 so title is first in database"
awk -F $'\t' ' { t = $1; $1 = $2; $2 = t; print; } ' OFS=$'\t' $out | sponge $out
echo "Taking first 8 columns for sqlite"
cut -f1-8 $out | sponge $out
echo quoting double quotes for sqlite
gsed 's|"|\\"|g' $out | sponge $out
echo done
wc -l $out
echo "Checking for movies without a url"
echo "In such cases, actor will comes as movie"
grep '^<td><i>[^<]' *.tbl
echo
echo Now you may import into database to check ./import_films.sh
echo if all okay, run combine.sh in the parent directory AFTER running looptable.sh in the parent
