#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
#
#

# Read in utility methods and list of tournaments for current season
$: << "/home/docxstudios/web/hs/code"
if $0.match(/ct8.rb$/) then
  @DEBUG = true 
  require "hsm"
else
  require "hs_methods"
end
require "tournament_urls"

@top_x = 8

@players = Hash.new(0)
@tournament_placements = Hash.new()
@bracket_urls = Hash.new("undefined")

puts "Content-type: text/html; charset=UTF-8"
puts ""
puts "<html>"
puts "<head>"
puts "<title>Top #{@top_x} Finishers</title>"
puts "</head>"
puts "<body>"

puts "<h1> Players who've made Top #{@top_x} five or more times</h1>"
puts "Data last refreshed at <tt>#{Time.now.utc.to_s}</tt><p>"
puts ""

@con = get_db_con

# I *should* be able to just get the bracket_ids directly, but
# apparently I'm doing weirdness in get_b_ids_from_t_ids, so
# I will fix that later.
t_ids = get_completed_tournament_ids
bracket_ids = get_b_ids_from_t_ids(t_ids)

bracket_ids.each_pair do |bid, type|
  data_json = get_standings(bid)
  get_bracket_top_8(data_json, type, bid)
end

puts "<ul>"

@players.sort_by {|n,w| -w}.each do |k, v|
  pdebug("Printing info for #{k} (#{v})")
  if v >= 5 then
    info = get_player_info(k, v)
    puts "<li> <b><font color='green'>#{info}</font></b>"
  else
    info = get_player_info(k, v)
    puts "<li> #{info}"
  end
end

puts "</ul>"

puts "<hr>"
puts "<h2>We checked #{bracket_ids.length} tournaments to get this info</h2>"
puts "<ul>"

bracket_ids.each_pair do |bid, type|
  puts "<li> Bracket ID '#{bid}' (#{type})"
end

puts "</ul>"

puts "</body>"
puts "</html>"


