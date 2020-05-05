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
# going on with a specific player or bracket
#@tracked_player = 'LoNa#3413'
#@tracked_player = 'Kuonet#1814'
#@tracked_bracket = '5dd338cdfe769736b01c8162|5dd2eebb1e95f55148ebbd99'
#@tracked_bracket = '5e0f72e86dc2fe43ae922889'

@top_x = 8
@top_x_threshold = 5
@top_x_threshold_text = 'five'
@invite_win_tag = 999

@players = Hash.new(0)
@tournament_placements = Hash.new()
@invite_reason = Hash.new()
@bracket_urls = Hash.new("undefined")
@invite_span_open="<span style='color: rgb(83, 67, 44); background-color: rgba(83, 67, 44, 0.1)'>"

puts "Content-type: text/html; charset=UTF-8"
puts ""
puts "<html>"
puts "<head>"
puts "<style>"
puts "  td, th {border-bottom: 1px solid; vertical-align: top;}"
puts "  table {border-bottom: 1px solid; vertical-align: top; width: 100%; height: 100%;}"
puts "</style>"
puts "<title>Top #{@top_x} Finishers</title>"
puts "</head>"
puts "<body>"

puts "<h1> Players who've made Top #{@top_x} #{@top_x_threshold_text} or more times (or were invited for one reason or another)</h1>"
puts "Players who have an invite are marked in #{@invite_span_open}brown with a darker background</span>.<br />"
puts "Players with #{@top_x_threshold} wins are marked in <font color='green'>green</font>.<br />"
puts "Players with #{@top_x_threshold - 1} wins are marked in <font color='orange'>orange</font>.<br />"
puts "<font color='orange'>Orange players</font> should be monitored during the tournaments they are in. This tool cannot currently account for matches in progress. If an  <font color='orange'>orange</font> makes the Top #{@top_x}, they should concede as they have already qualified with their Top #{@top_x} placement.<br />"
puts "Data last refreshed at <tt>#{Time.now.utc.to_s}</tt><p>"
puts ""

pdebug "FYI, we're tracking player(s) #{@tracked_player}"
pdebug "FYI, we're tracking bracket(s) #{@tracked_bracket}"

@con = get_db_con

# First off, let's get the folks who are manually invited.
get_manual_invites()

# I *should* be able to just get the bracket_ids directly, but
# apparently I'm doing weirdness in get_b_ids_from_t_ids, so
# I will fix that later.
t_ids = get_completed_tournament_ids
bracket_ids = get_b_ids_from_t_ids(t_ids)

bracket_ids.each_pair do |bid, type|
  data_json = get_standings(bid)
  get_bracket_top_8(data_json, type, bid)
end


outer_style="style='border: 1px solid; border-collapse: collapse; vertical-align: top;'"
@sorted_players = @players.sort_by {|n,w| -w}
puts "<table #{outer_style} width=100%>"
puts "<tr #{outer_style}><th #{outer_style}>On the list</th><th #{outer_style}>Not yet on the list</th></tr>"
puts "<tr #{outer_style}><td #{outer_style}><table style='color: rgb(83, 67, 44); background-color: rgba(83, 67, 44, 0.1)'><tr><th>Battle Tag</th><th>Invite reason</th><tr>"

@sorted_players.each do |k, v|
  if v >= @invite_win_tag then
    info = get_player_info(k, v)
    puts "<tr><td align=left>#{info}</td></tr>"
  end
end


puts "</table></td><td #{outer_style}><table>"
puts "<tr><th>Grinding for the dream</th></tr><tr><tr><td align=left><ul>"

@sorted_players.each do |k, v|
  pdebug("Printing info for #{k} (#{v})")
  info = get_player_info(k, v)
  # skip invited folks, since took care of them up above
  next if v >= @invite_win_tag 
  if v >= @top_x_threshold then
    puts "<li> <b><font color='green'>#{info}</font></b>"
  elsif v == @top_x_threshold - 1 then
    puts "<li> <b><font color='orange'>#{info}</font></b>"
  else
    puts "<li> #{info}"
  end
end

puts "</ul></td></tr></table></td></tr>"
puts "</table"

puts "<hr>"
puts "<h2>We checked #{bracket_ids.length} tournaments to get this info</h2>"
puts "<ul>"

bracket_ids.each_pair do |bid, type|
  puts "<li> Bracket ID '#{bid}' (#{type})"
end

puts "</ul>"

puts "</body>"
puts "</html>"


