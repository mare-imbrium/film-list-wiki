#!/usr/bin/env bash 
#===============================================================================
#
#          FILE: qfilm.sh
# 
#         USAGE: qfilm.sh keywords (names | year | title)
# 
#   DESCRIPTION: searches all_film.tsv for given strings.
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#          1. if no rows, gives 1 as count due to newline in echo
#         NOTES: ---
#         TODO   
#        AUTHOR: senti
#  ORGANIZATION: 
#       CREATED: 02/11/2016 12:38
#      REVISION:  2016-02-17 10:41
#===============================================================================

VERSION="1.0.0"
APPNAME=$( basename $0 )
cd $FILM_DATA_DIR
file=./all_film.tsv
if [[ ! -f "$file" ]]; then
    echo "File: $file not found" 1<&2
    exit 1
fi
DELIM=$'\t'

OPT_VERBOSE=
OPT_DEBUG=
GREP_FLAGS=
AWK_FLAGS=
OPT_COLS="1-4"
AWK_STR=
while [[ $1 = -* ]]; do
    case "$1" in
        -d|--director)  shift
            OPT_DIR=$1
            AWK_STR="${AWK_STR} && @4 ~ /$1/"
            shift
            ;;
        -t|--title)  shift
            OPT_TITLE=$1
            AWK_STR="${AWK_STR} && @1 ~ /$1/"
            shift
            ;;
        -g|--genre)  shift
            OPT_GENRE=$1
            AWK_STR="${AWK_STR} && @6 ~ /$1/"
            shift
            ;;
        -a|--actor)  shift
            OPT_ACTOR=$1
            AWK_STR="${AWK_STR} && @5 ~ /$1/"
            shift
            ;;

        --raw|--tabs)   shift
            OPT_TABS=1
            ;;
        -V|--verbose)   shift
            OPT_VERBOSE=1
            ;;
        -l|--long)   shift
            OPT_LONG=1
            OPT_COLS="1-"
            ;;
        -H|--header)   shift
            OPT_HEADER=1
            ;;
        -c|--count)   shift
            OPT_COUNT=1
            ;;
        -i|--ignore-case)   shift
            OPT_CASE=1
            GREP_FLAGS="-i"
            AWK_FLAGS="-v IGNORECASE=1"
            ;;
        --debug)        shift
            OPT_DEBUG=1
            ;;
        -h|--help)
            cat <<-! | sed 's|^     ||g'
            $APPNAME Version: $VERSION Copyright (C) 2016 senti
            This program prints film information using arguments as filtering criteria.
            It prints rows that match all criteria.

            Usage:
            $APPNAME Streep
            $APPNAME Streep "De Niro"
            $APPNAME scifi | less -S
            $APPNAME 2013 Hanks | less -S
            $APPNAME Dog   # This will search for Dog in title and names

            $APPNAME --director Eastwood
            $APPNAME --actor "De Niro"
            $APPNAME --genre scifi --director Kubrick
            $APPNAME --title Dog   # search for Dog only in titles

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
!
            # no shifting needed here, we'll quit!
            exit
            ;;
        --source)
            echo "this is to edit the source "
            vim $0
            exit
            ;;
        *)
            echo "$APPNAME: Error: Unknown option: $1" >&2   
            echo "Use -h or --help for usage" 1>&2
            exit 1
            ;;
    esac
done

if [  $# -eq 0 && -z "$AWK_STR" ]; then
    echo "Please pass some strings to filter on. Try $APPNAME --help"
    exit 1
fi
for var in "$@"
do
    AWK_STR="${AWK_STR} && @0 ~ /$var/"
done
STR=$(echo "$AWK_STR" | sed 's|@|$|g;s/ &&//;s/^/(/;s/$/)/;')
text=$( awk -F$'\t' $AWK_FLAGS "$STR" $file | cut -f1,3- | sort -k2,2 -t$'\t' )

header="Title${DELIM}Year${DELIM}Director${DELIM}Actors${DELIM}Genre${DELIM}Notes-up${DELIM}Country"
heade1="-----${DELIM}----${DELIM}--------${DELIM}------${DELIM}-----${DELIM}--------${DELIM}-------"
if [[ -n "$OPT_HEADER" ]]; then
    echo "$header" | cut -f$OPT_COLS
fi
if [[ -n "$OPT_TABS" ]]; then
    echo -e "$text"  | cut -f$OPT_COLS
else 
    # csvlook has some issue, one cannot use a pager after it, there are ascii codec errors
    #( echo "$header" ; echo -e "$text" ) | unidecode.rb | csvlook --tabs
    COLOR_UL="\\033[4m"
    COLOR_ULOFF="\\033[24m"
    #( echo -e "${COLOR_UL}$header${COLOR_ULOFF}" ; echo -e "$text" ) | cut -f$OPT_COLS | column -t -s$'\t'
    ( echo -e "$header" ; echo -e "$heade1"; echo -e "$text" ) | cut -f$OPT_COLS | column -t -s$'\t'
    echo -n "Results: "
    echo -e "$text" | wc -l
fi
if [[ -n "$OPT_COUNT" ]]; then
    echo -e "$text" | wc -l
fi
