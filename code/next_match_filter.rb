#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-
#
# Check the requested match id and flag anyone who has 
# registered that a) has an invite or b) is on the ban list

# Read in utility methods and list of tournaments for current season
$: << "/home/docxstudios/web/hs/code"
if $0.match(/nmf.rb$/) then
  require "hsm"
  @DEBUG = true
else
  require "hs_methods"
end
require "tournament_urls"

@form_url = "https://doc-x.net/hs/check_match_registrations.html"
@tournament_type='single_elim'  # We only do single elim. 

@cgi = CGI.new
params = @cgi.params

# Check to see if we've got any/the correct param(s)
if params.empty? then
  bail_and_redirect(target=@form_url)
end
if params['tournament_id'].nil? then
  bail_and_redirect(target=@form_url)
end

tid = params['tournament_id'][0]

# Now we have correct params, print out some HTML bits...

puts "Content-type: text/html; charset=UTF-8"
puts ""
puts "<title>Next Match Filter</title>"
puts "</html>"
puts "<body>"

### The plan:
# Get the list of players for that tournament id

player_list = get_tournament_players(tid)
if player_list.count > 0 then
  pdebug "Our tournament has players. Moving on"
else
  puts "ERROR: Tournament ID '#{tid}' did not return any players. Please double check the tournament ID and try again."
  puts "</body>"
  puts "</html>"
  exit
end
  
# Now that we've got valid input, let's start some output
puts "<h1>Results</h1>"

puts "Checking #{player_list.length} registered players.<br>"

# - Get list of folks who have invites (SHOULD HAVE A WAY TO DO THIS)
invited_players = get_manual_invites
#puts "players with invites: #{invited_players}"

# - Get list of folks who are banned (WILL NEED TO MAKE A WAY TO DO THIS)
banned_players = get_banned_players

puts "Comparing with the #{invited_players.length} players who currently have invites for the #{@tour_stop} tour stop and the #{banned_players.length} players who are currently marked as banned.<br>"

# - Flag anyone who is in list 1 and also in list 2 or 3

#puts "Registered players: #{player_list}"
invites_intersection = player_list.intersection(invited_players)
puts "<h2>Comparison results</h2>"
if invites_intersection.length > 0 then
  puts "Intersection with invited players: <br>\n<ul>"
  invites_intersection.each do |i|
    puts "<li><h3>#{i}</h3>"
  end
  puts "</ul>"
  puts "Data gathered from <a href='https://battlefy.com/hsesports/invites'>Battlefy's list of invites</a>.<p>"
else
  puts "No invited players found registered in this tournament."
end
puts "<p><hr><p>"
banned_intersection = player_list.intersection(banned_players)
if banned_intersection.length > 0 then
  puts "Intersection with banned players: <br>\n<ul>"
  banned_intersection.each do |i|
    puts "<li><h3>#{i}</h3>"
  end
  puts "</ul>"
  puts "Data gathered from <a href='/hs/view_banlist.rb'>the banlist</a>.<p>"
else
  puts "No banned players found registered in this tournament."
end


# Print HTML closing flags
puts "</body>\n"
puts "</html>\n"
