#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
#
#

# Read in utility methods and list of tournaments for current season
$: << "/home/docxstudios/web/hs/code"
if $0.match(/ct8.rb$/) then
  require "hsm"
  @DEBUG = true 
else
  require "hs_methods"
end
require "tournament_urls"

# Uncomment these and set them appropriately if you want to see what's
# giong on with a specific player or bracket
#@tracked_player = 'TechnoGoose#2886'
#@tracked_bracket = '5d999f3eee6bff69e6e49485|5da0a0bbb2f36e17303a97b9'

@top_x = 8
@threshold = 5
@threshold_text = 'five'

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

puts "<h1> Players who've made Top #{@top_x} #{@threshold_text} or more times</h1>"
puts "Players with #{@threshold} wins are marked in <font color='green'>green</font>.<br />"
puts "Players with #{@threshold - 1} wins are marked in <font color='orange'>orange</font>.<br />"
puts "<font color='orange'>Orange players</font> should be monitored during the tournaments they are in. This tool cannot currently account for matches in progress. If an  <font color='orange'>orange</font> makes the Top #{@top_x}, they should concede as they have already qualified with their Top #{@top_x} placement.<br />"
puts "Data last refreshed at <tt>#{Time.now.utc.to_s}</tt><p>"
puts ""

pdebug "FYI, we're tracking player #{@tracked_player}"

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
  info = get_player_info(k, v)
  if v >= @threshold then
    puts "<li> <b><font color='green'>#{info}</font></b>"
  elsif v == @threshold - 1 then
    puts "<li> <b><font color='orange'>#{info}</font></b>"
  else
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


