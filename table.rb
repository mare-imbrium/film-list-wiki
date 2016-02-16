#!/usr/bin/env ruby -w
# ----------------------------------------------------------------------------- #
#         File: table.rb
#  Description: converts table to csv. tailored for List of American films
#     in which we need the URL of the movie, which is the first TD
#       Author:  r kumar
#         Date: 2016-01-27 - 19:21
#  Last update: 2016-02-04 13:20
#      License: MIT License
# ----------------------------------------------------------------------------- #
# = Changelog
# == 2016-02-04
# - Fixed: some files have sortkey which messes the title. Remove the element
# == 2016-02-02
# - Added: country
# - Added: check for movie in italic without URL, don't print
#
# 2016-02-02 - there are still some tables in 1961 and 1961 which have Rank Gross in them. So you get
#  blank fields, the file has three tabs in a row. We could remove them there itself
#  I cannot deal with it here, since there are several tables here, and i 
#  can only get the title of the first one.

require 'nokogiri'

file=ARGV[0]
table_string = File.open(file,"r").readlines.join("\n")
doc = Nokogiri::HTML(table_string)

year = file[0,4]
country = "USA"
delim="\t"
doc.xpath('//table//tr').each do |row|
  arr=[]
  printme = true
  skipme = true
  row.xpath('td').each_with_index do |cell, i|
    if skipme
      if cell.css("a")[0].nil?
        # some movie don't have a URL, instead of index.php they have the title in italics 
        # this means that actor comes as title and so forth 2016-02-02
        if !cell.css("i").empty?
          # We should be skipping this too since no entry in wikipedia 2016-02-02.
          val =  cell.text.gsub("\n", ' ').gsub(/(\s){2,}/m, '\1').strip
          arr << val
          skipme = false
          printme = false
        else
          next
        end
        
      else
        skipme = false
        val = cell.css("a")[0]["href"]
        if val.index("index.php")
          printme = false
          # we need to skip this entry altogether, there is no entry for this film in wikipedia
        end
        #puts ":::" + cell.css("a")[0]
        arr << val
      end
    end
    # next line printed csv with quotes around field
    #print '"', cell.text.gsub("\n", ' ').gsub('"', '\"').gsub(/(\s){2,}/m, '\1'), "\", "
    # 2016-02-04 - some files have sortkey, and text() includes that so the title gets sortkey prepended
    cell.search("span.sortkey").remove
    val =  cell.text.gsub("\n", ' ').gsub(/(\s){2,}/m, '\1').strip
    val ||= "NULL"
    val = "NULL" if val == ""
    arr << val
  end
  unless arr.empty?
    arr.insert(2, year)
    if printme
      arr.insert(7, country)
      print arr.join(delim)
      print "\n"
    end
  end
end
