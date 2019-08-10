#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
#
#

require 'open-uri'
require 'json'
require 'mysql2'

def pdebug(msg="")
  return unless @DEBUG
  puts("DEBUG: #{msg}<br>\n")
end

@top_x = 8

@players = Hash.new(0)
@tournament_placements = Hash.new()
@bracket_urls = Hash.new("undefined")
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
  results = @con.query(query)
  # If we didn't get a result, go ahead and grab it and cache it in the DB
  if results.count == 0
    pdebug("Did not find cached info for #{bracket_id}")
    bracket_url = "https://api.battlefy.com/stages/#{bracket_id}/matches"
    #bracket_url = "https://dtmwra1jsgyb0.cloudfront.net/stages/#{bracket_id}/rounds/#{fr}/standings"
    pdebug "Full URL: #{bracket_url}"
    raw_json = open(bracket_url, {ssl_verify_mode: 0}).read
    query = "INSERT INTO cached_standings (bracket_id, json_blob) values ('#{bracket_id}', '#{Mysql2::Client.escape(raw_json)}')"
#    puts "GOING TO DO THIS: #{query}"
    @con.query(query)
  else
    pdebug("Using cached info for #{bracket_id}")
#    pdebug("results: #{results}")
    row = results.first
#    row = row['json_blob']
#    pdebug("row: '#{row[0]}'")
    # If we got a result, use that
    raw_json = row['json_blob'].to_s
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
  con = Mysql2::Client.new(:host => 'mysql.doc-x.net', :username => 'hs_tournaments', :password => pw, :database => 'hs_tournaments')
end

def get_tournament_ids
  query = 'SELECT tournament_id FROM bracket_tracker;'
  results = @con.query(query).to_a
  rows = Array.new
  results.each do |row| 
    rows << row['tournament_id']
  end
  return rows
end

def process_json_data(dj=nil, type=nil, bid=nil)
  return if dj.nil?
  return if type.nil?
  return if bid.nil?
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
      name = p['top']['team']['name']
      @players[name] += 1
      if @tournament_placements[name].nil? then
         @tournament_placements[name] = Array.new
      end
      unless @tournament_placements[name].include? bid then
        @tournament_placements[name] << bid
      end
    end
    unless p['bottom'].nil? or p['bottom']['team'].nil? or p['bottom']['team']['name'].nil? then
      name = p['bottom']['team']['name']
      if @tournament_placements[name].nil? then
         @tournament_placements[name] = Array.new
      end
      @players[name] += 1
      unless @tournament_placements[name].include? bid then
        @tournament_placements[name] << bid
      end
    end
  end
end

def get_b_ids_from_t_ids(tids=nil)
  return if tids.nil?
  b_ids = Hash.new
  tids.each do |tid|
    t_url = "https://api.battlefy.com/tournaments/#{tid}"
    pdebug "Retrieving info from #{t_url}"
    t_json = open(t_url, {ssl_verify_mode: 0}).read

    begin
      t_data = JSON.parse(t_json)
    rescue JSON::ParserError, Encoding::InvalidByteSequenceError => e
      puts "Had problem parsing #{t_json}: #{e}"
      return Hash.new
    end

    slug = t_data['slug']
    b_url = "https://battlefy.com/hesports/#{slug}/#{tid}/stage/"
    b_id = "000"

    unless t_data['stageIDs'][1].nil?
      # This should be a swiss tournament since it has two brackets 
      # (presumably swiss, then top 8)
      pdebug " - Adding swiss event #{t_data['stageIDs'][1]} to b_ids"
      b_id = t_data['stageIDs'][1]
      b_ids[b_id] = 'swiss'
      b_url.concat("#{b_id}/bracket/")
    else
      pdebug " - Adding possible single elim event #{t_data['stageIDs'][0]} to b_ids"
      b_id = t_data['stageIDs'][0]
      b_ids[b_id] = 'single'
      b_url.concat("#{b_id}/bracket/")
    end
    @bracket_urls[b_id] = b_url
  end
  return b_ids
end

def get_player_info(name=nil, num=nil)
  return if name.nil?
  return if num.nil?
  ret_str = "#{name} (#{num} top #{@top_x} placements: "
  @tournament_placements[name].each do |t|
    ret_str.concat("<a href='#{@bracket_urls[t]}'>link</a>, ")
    pdebug("num is #{num}, ret_str is #{ret_str}")
  end
  ret_str.gsub!(/, $/, '')
  ret_str.concat(')')
  return ret_str
end

@con = get_db_con
t_ids = get_tournament_ids
bracket_ids = get_b_ids_from_t_ids(t_ids)

bracket_ids.each_pair do |bid, type|
  data_json = get_standings(bid)
  process_json_data(data_json, type, bid)
end

puts "<ul>"

@players.sort_by {|n,w| -w}.each do |k, v|
  pdebug("Printing info for #{k} (#{v})")
  if v >= 6 then
    info = get_player_info(k, v)
    puts "<li> <b><font color='green'>#{info}</font></b>"
  else
    info = get_player_info(k, v)
    puts "<li> #{info}"
  end
end

puts "</ul>"
puts "</body>"
puts "</html>"


