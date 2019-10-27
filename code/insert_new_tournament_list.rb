#!/usr/bin/env ruby
#
# This reads in the list of tournaments updates the database with them

# Read in utility methods and list of tournaments for current season
$: << "/home/docxstudios/web/hs/code"
require "hs_methods"
require "tournament_urls"

# So we don't need to wait for a newline to flush output
$stdout.sync = true

# We clear out the table
print "Truncating table... "
con = get_db_con
q = "TRUNCATE tournament_list"
con.query(q)
puts "done!"

puts "Beginning addition of tournament ids"
@tournament_hash.each_key do |k|
  print "\rWorking on #{k} . . "
  q = "INSERT INTO tournament_list (tournament_id) values ('#{k}')"
  print ". Runninq query: #{q}"
  con.query(q)
  print " . . . query complete"
end
print "\rAll tournaments added."
puts "=== Program run complete"

#query = "SELECT tournament_id, bracket_id FROM tournament_list WHERE completed is FALSE"
