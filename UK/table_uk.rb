#!/usr/bin/env ruby
# ----------------------------------------------------------------------------- #
#         File: table.rb
#  Description: converts table to csv. tailored for List of UK films
#     in which we need the URL of the movie, which is the first TD
#       Author:  r kumar
#         Date: 2016-01-27 - 19:21
#  Last update: 2016-02-16 19:36
#      License: MIT License
# ----------------------------------------------------------------------------- #
# = Changelog
# == 2016-02-04
# - Fixed: some files have sortkey which messes the title. Remove the element
# == 2016-02-03 
#  -  Added: country in index 7
#  -  Added: ignore row with 1956_in_film
#  -  Fixed: Crew that has Cast after a BR without saying Cast
#
# ---
# ISSUE: In some cases of "Cast and Crew" the cast comes after a BR tag without cast being mentioned.
#   So we just add it to Director. 2016-02-03 
# We need to add year after the title, that will come from the filename
# In some cases, first column seems to be date of opening so format has changed. 2015, 2016
# We already have got the url, let us forget that and try just getting the data.
# What we can do is to ignore that data prior to the first field with a url.

# table has these formats
#  title director cast genre
#  title director cast genre release-dates notes  2009, 2010
#  title "cast and crew" details genre notes  2011 onward
#  title "cast and crew" details genre ref    2015
require 'nokogiri'

file=ARGV[0]
table_string = File.open(file,"r").readlines.join("\n")
doc = Nokogiri::HTML(table_string)

year = file[0,4]
country = "UK"
delim="\t"
print_headers = false # should we print headers


_headers = false # internal variable to process only first row with TH
splitcrew = false # internal variable, should we split cast and crew field or not

doc.xpath('//table//tr').each do |row|
  heads=[]
  printme = true
  # the idea of reading headers is that the headers are different for different years.
  # In some, Details comes after cast, and then genre
  #   otherwise genre follows cast
  # After 2011, Director an Cast is clubbed in one field
  unless _headers
    # print headers only once since opening dates also uses th
    row.xpath('th').each_with_index do |cell, i|
      heads << cell.text
    end
    _headers = true
    genindex = heads.index("Genre") || heads.index("Genre(s)")
    titleindex = heads.index("Title")
    #puts heads.join("\t")
    puts ["URL","Title","Year","Director","Cast","Genre","Detail"].join(delim) if print_headers
    #puts "titleindex: #{titleindex} "
    #puts "genindex: #{genindex} "
    #gindex = genindex - titleindex
  end
  if heads.index("Cast and Crew")
    splitcrew = true
  end
  arr=[]
  skipme = true
  ctr = 0
  row.xpath('td').each_with_index do |cell, i|
    if skipme
      # keep skipping till you get the field with the href
      if cell.css("a")[0].nil?
        next
      else
        skipme = false
        #puts ":::" + cell.css("a")[0]
        # this is title
        val = cell.css("a")[0]["href"]
        if val.index("index.php")
          printme = false
          # we need to skip this entry altogether, there is no entry for this film
        end
        if val.index("/wiki/#{year}_in_film")
          printme = false
          # we need to skip this entry altogether, this is just a dummy row
        end
        arr << val
        ctr = 0
      end
    end
    # next line printed csv with quotes around field
    #print '"', cell.text.gsub("\n", ' ').gsub('"', '\"').gsub(/(\s){2,}/m, '\1'), "\", "
    # use just table delimiter
    #print cell.text.gsub("\n", ' ').gsub(/(\s){2,}/m, '\1')
    # 0 - url, 1 - title, 2 - director. 3 - cast. 4 - genre 5 - others/notes etc
    #
    # 2016-02-04 - some files have sortkey, and text() includes that so the title gets sortkey prepended
    cell.search("span.sortkey").remove
    val = cell.text.gsub("\n", ' ').gsub(/(\s){2,}/m, '\1').strip
    val ||= "NULL"
    val = "NULL" if val == ""
    case ctr
    when 0
      # title
        arr << val
    when 1
      # either director or cast and crew
      # 2016-01-31 - sometimes the string says Directors, and sometimes there is no Cast. Just a </br>
      if splitcrew
        if val.index(/Directors?:/)
          # TODO 2016-02-03 - if cast NULL check for data after a BR tag
          # HACK 2016-02-03 - Added cast after newline
          # TODO 2016-02-03 - In such cases, remove actors from directors
          if !val.index(/Cast: /)
            val = cell.text.sub("\n", ' Cast: ').gsub("\n",' ').gsub(/(\s){2,}/m, '\1').strip
          end
          director = val[/Directors?: (.*?) Cast:/,1]
          if director.nil?
            director = val[/Directors?: (.*)/,1]
          end
          cast = val[/Cast: (.*)$/,1] || "NULL"
          arr << director
          arr << cast
        else
          arr << val
        end
      else
        arr << val
      end
    when 2
      # cast in some cases, details in others
      arr << val
    when 3
      # this is genre and must go into position 4
      # that will push Details to 5 if it was there
      arr.insert(4, val)
      #
    when 4
      # notes or ref
      arr << val
    end
    ctr += 1
  end
  unless arr.empty?
    # insert year into the third slot, ie. after title
    arr.insert(2, year)
    if printme
      arr.insert(7, country)
      print arr.join(delim)
      print "\n"
    end
  end
end
