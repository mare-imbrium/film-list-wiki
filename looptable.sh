#!/usr/bin/env bash 
#===============================================================================
#
#          FILE: looptable.sh
# 
#         USAGE: ./looptable.sh 
# 
#   DESCRIPTION: creates film.tsv from all the tbl files by calling table.rb
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 01/29/2016 15:11
#      REVISION:  2016-02-18 10:42
#===============================================================================
out=film.tsv
DIR=/Volumes/Pacino/dziga_backup/rahul/Downloads/MOV/amerfilms
if [[  -f "$out" ]]; then
    rm $out
fi
for file in $DIR/tbl/*.tbl ; do
    echo $file
    $DIR/table.rb $file >> $out
done
wc -l $out
echo "Switching column 2 and 1 so title is first in database"
awk -F $'\t' ' { t = $1; $1 = $2; $2 = t; print; } ' OFS=$'\t' $out | sponge $out
echo "taking first 8 columns for sqlite"
cut -f1-8 $out | sponge $out
echo quoting double quotes for sqlite
gsed 's|"|\\"|g' $out | sponge $out
echo
echo Now you may run looptable.sh in the UK directory
echo Then run combine.sh which will import both film.tsv into the database
