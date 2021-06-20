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
if params['bracket_id'].nil? then
  bail_and_redirect(target=@form_url)
end

# Now we have correct params, print out some HTML bits...

puts "Content-type: text/html; charset=UTF-8\n"
puts "\n"
puts "<title>Next Match Filter</title>\n"
puts "</html>\n"
puts "<body>\n"

### The plan:
# - Make sure the tournament is one in the current season
if validate_and_set_bracket_id_and_tourney_hash(params['bracket_id'][0]) then
  pdebug "Our data is validated. Moving on"
else
  puts "ERROR: Could not get validate set bracket and tourney hash. Buh Bye.\n"
  puts "</body>\n"
  puts "</html>\n"
  exit
end
  
# Now that we've got valid input, let's start some output
puts "<h1>Results</h1>"

# - Get list of folks in match (SHOULD HAVE A WAY TO DO THIS)
# Get JSON data for this tournament
# Since a) we know this is single elim and b) we are going to skip
# doing any we can shortcut a lot of checking
#t_url = "#{@base_cf_url}/#{@tourney_hash}/rounds"
registered_players = get_round_one_users(@bracket_id)
# puts "Array of registered players is #{registered_players}"

if registered_players.nil? then
  puts "ERROR: Could not get registered players for tournament. Goodbye\n"
  puts "</body>\n"
  puts "</html>\n"
  exit
end

puts "Checking #{registered_players.length} registered players.<br>"

# - Get list of folks who have invites (SHOULD HAVE A WAY TO DO THIS)
players_with_invites = get_manual_invites
#puts "players with invites: #{players_with_invites}"

puts "Comparing with the #{players_with_invites.length} players who currently have invites for the #{@tour_stop} tour stop.<br>"

# - Get list of folks who are banned (WILL NEED TO MAKE A WAY TO DO THIS)
#   - Make banlist table in DB
#   - Make way to let folks add or 'un-ban' folks in that table
# - Flag anyone who is in list 1 and also in list 2 or 3

#puts "Registered players: #{registered_players}"
intersection = registered_players.intersection(players_with_invites)
puts "<h2>Comparison results</h2>"
if intersection.length > 0 then
  puts "Intersection with invited players: <br>\n<ul>"
  intersection.each do |i|
    puts "<li>#{i}"
  end
  puts "</ul>"
else
  puts "No invited players found registered in this tournament."
end


# Print HTML closing flags
puts "</body>\n"
puts "</html>\n"
