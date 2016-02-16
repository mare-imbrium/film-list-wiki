# HOWTO

1. first download all files for UK using  ../download_uk.sh
2. ./extracttable_uk.sh to create tbl files
3. ./looptable.sh to create film.tsv
3a. verify columns are okay since format could change
    cat film.tsv COL L

4. insert into database along with US movies

## NOTES

format is quite different from US lists.

there are many wikitables. we need only the one inside major releases

After 2011 the format changes: 
director and cast are together in one field. tat we can separate.
genre comes after notes.

even otherwise there are frequent changes of columns

I think we have url, title, year, director and cast in this order in all
files.
Now we only need to get the genre correct which is either next or after
that. 

[ ] separate tbl and html to avoid clutter.
maybe make separate files for each year so we can deal separately.
issue is that that becomes manual and cannot be repeated.

