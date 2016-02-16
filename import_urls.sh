#!/usr/bin/env bash

COMM=$(brew --prefix sqlite)/bin/sqlite3

$COMM --version
MYTABLE="url"
MYFILE="all_urls.tsv"
echo "Creating $MYTABLE with URLs of movies from wikipedias list of films for USA and UK"
echo
echo -n "checking if $MYFILE sorted"
sort --check $MYFILE
if [  $? -eq 0 ]; then
    echo "   okay"
else
    echo "   failed"
    echo -n "Sorting .."
    sort $MYFILE | sponge $MYFILE
    echo "done. "
fi
echo "Hopefully you have escaped double quotes"
echo "and checked for empty titles"


MYDATABASE="urls.sqlite"

echo "Creating $MYDATABASE "


$COMM $MYDATABASE << !
DROP TABLE $MYTABLE;

CREATE TABLE $MYTABLE (
	title VARCHAR, 
	year INTEGER, 
	country  VARCHAR, 
	url VARCHAR
);
.headers off
.mode tabs
.import $MYFILE $MYTABLE
!
echo "$MYTABLE Imported"
$COMM $MYDATABASE << !
 select count(1) from $MYTABLE;
!
echo "Creating index on title"
$COMM $MYDATABASE << !
CREATE INDEX ${MYTABLE}_title on $MYTABLE(title) ;
!
wc -l $MYFILE
echo "checking for empty title"
$COMM $MYDATABASE << !
 select * from $MYTABLE where title = "";
!
