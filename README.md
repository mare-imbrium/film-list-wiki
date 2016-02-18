# film-list-wiki

## List of films and urls

This is meant to be a *pretty* comprehensive list of American and British films with their wikipedia
URLS.

There are two directories here, American films and British films.
Each gives two outputs. 

One is a simple film title and URL. This allows me to just get the URL of a film which can be processed by fetchupdate.rb.

The other output is film.tsv or all_films.tsv which also has year, director and starring. This allows me to have a huge list without downloading each film page from wikipedia.
The issue with the latter is that different years have different file formats so parsing changes. There is also a difference in the UK and USA htmls. THis means that the formats  can continue to change over time and they are updated.
The source wikipedia files are still in process, so the formats will change.

However, this database is still great for searching movies for directors and actors.


## CHANGELOG

- 2016-02-18 - moved html to ./html and tbl files to ./tbl and modified programs
               earlier YEAR was hardcoded to 2016, now taking from `date +%Y`

               NOT TESTED.

## TODO

Keep re-running every two months to get updates after backing up earlier file. Format of htmls could keep changing so this can be a major issue. Currently, many movies are missing from their lists. So a listing of movies for an actor or director is not exhaustive.

## ISSUES WITH DATA

- standardize the genre. e.g. there is sci-fi, scifi and science fiction.  DONE MANUALLY.
- often the same movie comes under US and UK. Since there is a difference in the number of actors i don't want to delete one of the rows.

## QUERY:

- qfilm.sh : use this to query. qfilm.sh --help to see options.

 (The following is an output of --help and may be outdated. I have linked qfilm to qfilm.sh)


       qfilm Version: 1.0.0 Copyright (C) 2016 
       This program prints film information using arguments as filtering criteria.
       It prints rows that match all criteria.

       Usage:
       qfilm Streep
       qfilm Streep "De Niro"
       qfilm scifi | less -S
       qfilm 2013 Hanks | less -S
       qfilm Dog   # This will search for Dog in title and names

       qfilm --title Dog   # search for Dog only in titles
       qfilm --director Eastwood
       qfilm --actor "De Niro"
       qfilm --genre scifi --director Kubrick

       Options:
       -d, --director STR Search for STR only in director
       -a, --actor STR   Search for STR only in actor
       -t, --title STR   Search for STR only in title
       -g, --genre STR   Search for STR only in genre
       -l, --long        Long listing, all columns
       -H, --header      Print header (for csvlook)
       -c, --count       Print rowcount at end
       -i, --ignore-case case insensitive search
       -V, --verbose     Displays more information
           --debug       Displays debug information


## HOWTO

See instruction in the README of the UK directory. they should hold true here also.

- download files
    ./download.sh 
- extract table from html -> tbl files
    ./extracttable.sh
- loop and create TSV files (uses table.rb)
    ./looptable.sh
- To combine US and UK and then import into db.
    ./combine.sh 


## NOTES

2016-02-02 - check: put data in table and test for NULL in various
fields
             check: blank in actor and genre
             check: very long director field, means that actor has
             slipped in
             check: actor or director contain thriller, drama,
             documentary and other genres
--------------------------
extract data between wikitable sortable and </table>
<table class="wikitable sortable">
first row tr to /tr is titles: title director case genre and
notes(producer).

then starts the data

first td is title, extract URL href="/wiki...."
title="..">xxx</a> preferable to take >xxx< rather than ".."

director. better to take what is inside > and </a> but if not take
multiples for title=" "

starring, same as director, multiples


we need to get british films too

://en.wikipedia.org/wiki/List_of_British_films_of_2013
://en.wikipedia.org/wiki/List_of_British_films_of_2013

the format is different. cast and crew is one with directors and cast in
one.

but we can still get the urls and year.

i have to the us and uk film urls only url, title and year, no director
etc. that we will do later.
i can combine the two adding country into one. put into table and use to
get the url out.


--
errors: 
some movies do not have a link - only name in italics. so actor becomes
name and so forth.
But if we take that then we get those single digit Month numbers as
movies, so again things go wrong.

getting tyler christopher in 2001  with drama etc
also remove index.php
2002 david ian is coming as comedy
2005 monica thriller
jill mary jones comedy 2007
freakonomics 2010 long director list
2011 aunjuanue ellis title is long has names in it
2012 bill condon - very long director list longest
2012 v/h/s
2013 david deCateau
movie_43
2013 jehane long director
v/h/s/2
2002 william gozecki underage murder
jim simpson (director) 2002
jon voight
scout taylor compton - check those that have blank genres

check director and actor field for genres like comedy documentary drama thriller science fiction 
