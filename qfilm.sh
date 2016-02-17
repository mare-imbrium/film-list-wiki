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
#         TODO   query specifying director or genre. 
#        AUTHOR: senti
#  ORGANIZATION: 
#       CREATED: 02/11/2016 12:38
#      REVISION:  2016-02-17 10:41
#===============================================================================


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
            $0 Version: 1.0.0 Copyright (C) 2016 senti
            This program prints film information using arguments as filtering criteria.
            It prints rows that match all criteria.

            Usage:
            $0 Streep
            $0 Streep "De Niro"
            $0 scifi | less -S
            $0 2013 Hanks | less -S

            Options:
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
            echo "$0: Error: Unknown option: $1" >&2   
            echo "Use -h or --help for usage" 1>&2
            exit 1
            ;;
    esac
done

#if [[ -n "$AWK_STR" ]]; then
    #STR=$(echo "$AWK_STR" | sed 's|@|$|g;s/ &&//;s/^/(/;s/$/)/;')
    #awk -F$'\t' "$STR" $file
    # we need to integrate this with the rest since user may pass some free search strings
#fi
#if [  $# -eq 0 ]; then
    #echo -e "Please pass one or more search terms such as part of title or name of actor/director, or year." 1<&2
    #exit 1
#fi

# We are ANDing the search terms. all must be found.
# It would be better to do awk '/string1/ && /string3/' file
# I need to build that.
for var in "$@"
do
    AWK_STR="${AWK_STR} && @0 ~ /$var/"
done
STR=$(echo "$AWK_STR" | sed 's|@|$|g;s/ &&//;s/^/(/;s/$/)/;')
text=$( awk -F$'\t' $AWK_FLAGS "$STR" $file | cut -f1,3- | sort -k2,2 -t$'\t' )
#arg1=$1
#shift
#text=$( grep -h $GREP_FLAGS "$arg1" $file | cut -f1,3- | sort -k2,2 -t$'\t')
#for var in "$@"
#do
    #text=$(echo "$text" | grep $GREP_FLAGS "$var")
#done

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
