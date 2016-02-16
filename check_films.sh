#!/usr/bin/env bash 
#===============================================================================
#
#          FILE: check_films.sh
# 
#         USAGE: ./check_films.sh 
# 
#   DESCRIPTION: check for null titles, directors actors
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 02/02/2016 22:29
#      REVISION:  2016-02-16 19:29
#===============================================================================

source ~/bin/sh_colors.sh

#!/usr/bin/env bash

COMM=$(brew --prefix sqlite)/bin/sqlite3
MYDATABASE=movies.sqlite
MYTABLE=movie
LOG=db.log
echo "" > $LOG
date >> $LOG
echo "" > $LOG

echo "Count for null titles , director, actors, genre" >> $LOG
$COMM $MYDATABASE << ! >> $LOG
select count(1) from $MYTABLE where title = "" or title = "NULL";
select count(1) from $MYTABLE where director = "" or director = "NULL";
select count(1) from $MYTABLE where actors = "" or actors = "NULL";
select count(1) from $MYTABLE where genre = "" or genre = "NULL";
!

echo "" > $LOG
echo "== Null TITLES " >> $LOG
$COMM $MYDATABASE << ! >> $LOG
select * from $MYTABLE where title = "" or title = "NULL";
!
echo "" > $LOG
echo "== Null DIRECTOR " >> $LOG
$COMM $MYDATABASE << ! >> $LOG
select title, year, genre from $MYTABLE where director = "" or director = "NULL";
!
echo "" > $LOG
echo "== Null ACTORS " >> $LOG
$COMM $MYDATABASE << ! >> $LOG
select title, year , genre from $MYTABLE where actors = "" or actors = "NULL";
!
echo "" > $LOG
echo "== Null GENRE " >> $LOG
$COMM $MYDATABASE << ! >> $LOG
select title, year, director  from $MYTABLE where genre = "" or genre = "NULL";
!
echo "" > $LOG
echo "== GENRE mismatch" >> $LOG
$COMM $MYDATABASE << ! >> $LOG
select title, year, director  from $MYTABLE where director like "%documentary%" or director like "%drama%" or 
    director like "%comedy%" or director like "%thriller%" or director like "%action%";
!
echo "" > $LOG
echo "== GENRE mismatch" >> $LOG
$COMM $MYDATABASE << ! >> $LOG
select title, year, director, actors  from $MYTABLE where actors like "%documentary%" or actors like "%drama%" or 
    actors like "%comedy%" or actors like "%thriller%" or actors like "%action%";
!
echo see $LOG
wc -l $LOG
