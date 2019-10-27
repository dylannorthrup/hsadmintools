#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
#

# Read in utility methods and list of tournaments for current season
$: << "/home/docxstudios/web/hs/code"
require "hs_methods"
require "tournament_urls"

puts "Running truncate on cached_standings"

@con = get_db_con
q = 'DELETE FROM cached_standings'
#q = 'TRUNCATE cached_standings'
@con.query(q)
puts "Truncate complete. #{@con.affected_rows} rows were deleted."

puts "Refreshing cache"


@players = Hash.new(0)
@tournament_placements = Hash.new()
@bracket_urls = Hash.new("undefined")

# I *should* be able to just get the bracket_ids directly, but
# apparently I'm doing weirdness in get_b_ids_from_t_ids, so
# I will fix that later.
t_ids = get_completed_tournament_ids
bracket_ids = get_b_ids_from_t_ids(t_ids)

bracket_ids.each_pair do |bid, type|
  puts "* Updated #{bid}"
  data_json = get_standings(bid)
end

puts "Cache refresh complete. Exiting."
