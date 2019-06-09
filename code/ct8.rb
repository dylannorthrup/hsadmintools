#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
#
#

require 'open-uri'
require 'json'
require 'mysql'

def pdebug(msg="")
  return unless @DEBUG
  puts("DEBUG: #{msg}<br>\n")
end

@top_x = 8

@players = Hash.new(0)
@DEBUG = false
@DEBUG = true if $0.match(/ct8.rb$/)

puts "Content-type: text/html; charset=UTF-8"
puts ""
puts "<html>"
puts "<head>"
puts "<title>Top #{@top_x} Finishers</title>"
puts "</head>"
puts "<body>"

# Give a round number and get the results from that round
def get_standings(bracket_id=nil)
  return if bracket_id.nil?
  # Check if info is in database already
  query = "SELECT json_blob FROM cached_standings WHERE bracket_id='#{bracket_id}'"
#  puts "Executing query '#{query}'"
  results = @con.query(query)
  row = results.fetch_row
  # If we didn't get a result, go ahead and grab it and cache it in the DB
  if row.nil? 
    pdebug("Did not find cached info for #{bracket_id}")
    bracket_url = "https://api.battlefy.com/stages/#{bracket_id}/matches"
    #bracket_url = "https://dtmwra1jsgyb0.cloudfront.net/stages/#{bracket_id}/rounds/#{fr}/standings"
    pdebug "Full URL: #{bracket_url}"
    raw_json = open(bracket_url, {ssl_verify_mode: 0}).read
    query = "INSERT INTO cached_standings (bracket_id, json_blob) values ('#{bracket_id}', '#{Mysql.escape_string(raw_json)}')"
#    puts "GOING TO DO THIS: #{query}"
    @con.query(query)
  else
    pdebug("Using cached info for #{bracket_id}")
    # If we got a result, use that
    raw_json = row[0]
  end

  begin
    j_data = JSON.parse(raw_json)
  rescue JSON::ParserError, Encoding::InvalidByteSequenceError => e
    puts "Had problem parsing #{raw_json}: #{e}"
    return Hash.new
  end
  return j_data
end

puts "<h1> Players who've made Top #{@top_x} six or more times</h1>"
puts "Data last refreshed at <tt>#{Time.now.utc.to_s}</tt><p>"
puts ""
#puts "<ul>"

def get_db_con
  pw = File.open("/home/docxstudios/hs_tournaments.pw").read.chomp
  con = Mysql.new 'mysql.doc-x.net', 'hs_tournaments', pw, 'hs_tournaments'
end

def get_tournament_ids
  query = 'SELECT tournament_id FROM bracket_tracker;'
  rows = @con.query(query)
  return rows
end

def process_json_data(dj=nil, type=nil)
  return if dj.nil?
  return if type.nil?
  # Take dj. Grab the last 7 elements (in case we're single elim, we're
  # just interested in the last 7 events), then look at the first four
  # of the resultant list (the round of 8) and get the folks from there
  dj.last(7).first(4).each do |p|
    # Double check that if we say we are in a single elim
    # tournament, we actually ARE a single elim tournament
    if type == 'single' then
      return if p["matchType"].nil?
      return unless p["matchType"] == 'winner'
    end
    # Throw checking in here because single elim matches could be set up but
    # not have a player populated yet which throws an error
    unless p['top'].nil? or p['top']['team'].nil? or p['top']['team']['name'].nil? then
      @players[p['top']['team']['name']] += 1
    end
    unless p['bottom'].nil? or p['bottom']['team'].nil? or p['bottom']['team']['name'].nil? then
      @players[p['bottom']['team']['name']] += 1
    end
  end
end

def get_b_ids_from_t_ids(tids=nil)
  return if tids.nil?
  b_ids = Hash.new
  #@tournament_hash.each_key do |t|
  tids.each do |tid|
    t = tid[0]
    t_url = "https://api.battlefy.com/tournaments/#{t}"
    pdebug "Retrieving info from #{t_url}"
    t_json = open(t_url, {ssl_verify_mode: 0}).read

    begin
      t_data = JSON.parse(t_json)
    rescue JSON::ParserError, Encoding::InvalidByteSequenceError => e
      puts "Had problem parsing #{t_json}: #{e}"
      return Hash.new
    end

    unless t_data['stageIDs'][1].nil?
      # This should be a swiss tournament since it has two brackets 
      # (presumably swiss, then top 8)
      pdebug " - Adding swiss event #{t_data['stageIDs'][1]} to b_ids"
      b_ids[t_data['stageIDs'][1]] = 'swiss'
    else
      pdebug " - Adding possible single elim event #{t_data['stageIDs'][0]} to b_ids"
      b_ids[t_data['stageIDs'][0]] = 'single'
    end
  end
  return b_ids
end

@con = get_db_con
t_ids = get_tournament_ids
bracket_ids = get_b_ids_from_t_ids(t_ids)

bracket_ids.each_pair do |bid, type|
#  puts "<pre>#{bid}</pre>"
#  if b[1].nil?
#    final_round=8
#  else
#    final_round=b[1]
#  end
  # puts "<li> Working on #{bid} (#{type})"
  data_json = get_standings(bid)
  process_json_data(data_json, type)
end
#puts "</ul>"

#puts "<hr>"
puts "<ul>"

@players.sort_by {|n,w| -w}.each do |k, v|
  if v >= 6 then
    puts "<li> <b><font color='green'>#{k} (#{v} top #{@top_x} placements)</font></b>"
  else
    puts "<li> #{k} (#{v} top #{@top_x} placements)"
  end
end

puts "</ul>"
puts "</body>"
puts "</html>"


