#!/usr/bin/env bash

COMM=$(brew --prefix sqlite)/bin/sqlite3

$COMM --version
MYTABLE="movie"
MYFILE="film.tsv"
echo "This is ONLY TO TEST OUT AND CHECK THE DATA BEFORE INSERTING INTO THE TABLE WITH USA DATA "
echo
echo "Creating $MYTABLE with films of movies from wikipedias list of films for USA and UK"
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


MYDATABASE="uk.sqlite"

echo "Creating $MYDATABASE "


$COMM $MYDATABASE << !
DROP TABLE $MYTABLE;

CREATE TABLE $MYTABLE (
	title VARCHAR, 
	url VARCHAR, 
	year INTEGER, 
	director VARCHAR, 
	actors VARCHAR, 
    genre VARCHAR,
    remarks VARCHAR,
    country VARCHAR
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
echo "checking for empty title, director, actors, genre"
$COMM $MYDATABASE << !
select count(1) from $MYTABLE where title = "" or title = "NULL";
select count(1) from $MYTABLE where director = "" or director = "NULL";
select count(1) from $MYTABLE where actors = "" or actors = "NULL";
select count(1) from $MYTABLE where genre = "" or genre = "NULL";
!
