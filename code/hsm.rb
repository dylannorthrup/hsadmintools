#!/usr/bin/ruby -w
#
# Methods used by the hearthstone utilities

require 'open-uri'
require 'json'
require 'cgi'
require 'mysql2'
require 'date'

@DEBUG = false
@base_cf_url = 'https://dtmwra1jsgyb0.cloudfront.net/stages'

def pdebug(msg="")
  return unless @DEBUG
  # If @output is not defined,blank, or nil; explicitly set it to nil
  @output ||= nil
  # If we don't do the above and @output wasn't defined, we get an error here.
  # If we're here, it means we should print to STDOUT because our calling script
  # hasn't defined an '@output' variable that it wants things printed to
  if @output.nil? then
    STDERR.puts("DEBUG: #{msg}<br>")
  else
    @output.concat("DEBUG: #{msg}<br>\n")
  end
end

def bail_and_redirect(target=nil?)
  target_url = 'http://doc-x.net/hs/'
  unless target.nil? then
    target_url = target
  end
  @cgi.out( "status" => "REDIRECT", "Location" => target_url, "type" => "text/html") {
    "Redirecting to data input page: #{target_url}\n"
  }
  exit
end

# If we get a full URL, massage it to get the bracket ID
def derive_bracket_id_from_parameter(bid=nil?)
  if bid.match(/^https/) then
    bid = bid.gsub(%r{^https://.*/stage/}, '')
    bid = bid.gsub(%r{/bracket.*$}, '')
  end
  return bid if bid.match(/^[a-f0-9]{24}$/)
  return nil
end

# Determine if the bracket ID we got is well formed (24 Hex characters).
# If it's a URL, try to massage it to extract the bits we're interested in.
# If it doesn't match what we're expecting, return false. If it does, 
# return true.
def bogus_match_data(bid=nil?)
  return true if bid.nil?
  # If we get a full URL, massage it to get the bracket ID
  if bid.match(/^https/) then
    bid.gsub!(%r{^https://.*/stage/}, '')
    bid.gsub!(%r{/bracket.*$}, '')
  end
  return false if bid.match(/^$/)
  return false if bid.match(/^[a-f0-9]{24}$/)
  return true
end

# Print out a message indicating the bracket ID we got is not valid
def tell_em_dano(bid=nil, obid=nil?)
  @output.concat("<pre>\n")
  @output.concat("Provided bracket ID ('#{bid}' derived from '#{obid}') did not match pattern. Hit the back button and try again.\n")
  if obid.match(/info$/) then
    @output.concat("It looks like you copied the link from the Master Tracker and not the actual bracket URL. Make sure you're using the Bracket URL if you're pasting a URL.\n")
    @output.concat("A bracket URL will contain the text '/stage/' and '/bracket/' in it.\n")
  end
  @output.concat("</pre>\n")
  @output.concat("</body>\n")
  @output.concat("</html>\n")
  puts @output
  exit
end

# Give a round number and get the results from that round
def get_round(round=nil, tourney_url=nil)
  return if round.nil?
  return if tourney_url.nil?
  full_url = "#{tourney_url}/#{round}/matches"
  pdebug("Full URL for this round's JSON: #{full_url}<br>\n")
  raw_json = open(full_url, {ssl_verify_mode: 0}).read

  begin
    j_data = JSON.parse(raw_json)
  rescue JSON::ParserError, Encoding::InvalidByteSequenceError => e
    @output.concat("Had problem parsing #{path}: #{e}\n")
    return Hash.new
  end
  return j_data
end

def get_match_name(hash=nil, t_id=nil)
#  @output.concat("In get_match_name with t_id '#{t_id}'\n")
  return if hash.nil?
  return if t_id.nil?
  if @tournament_hash[t_id].nil? then
    return "No name for hash #{t_id}"
  end
  name = @tournament_hash[t_id].clone
  name.gsub!('https://battlefy.com/hsesports/', '')
  name.gsub!(/\/.*/, '')
#  @output.concat("get_match_name found name of #{name} for #{t_id}</pre>\n")
  return name
end

def extract_json_data(data_json=nil, current_round=nil)
  return if data_json.nil?
  return if current_round.nil?
  @active_round = current_round
  # This is only needed for the match_status page. If we're not calling this from match_status, skip all this
  # meshugas.
  unless @skip_match_status_stuff then
  ### BEGIN This is for match_status stuff. Filter out for non ms.rb stuff? Put somewhere else?
    tournament_id = data_json[0]['top']['team']['tournamentID']
    creation_time = data_json[0]['createdAt']
    creation_time.gsub!(/\.\d\d\dZ$/, ' UTC')
    creation_time.gsub!(/-(\d\d)T(\d\d):/, '-\1 \2:')
    name = get_match_name(@tournament_hash, tournament_id)
    #      @output.concat("Name is #{name}\n")
    if @tournament_type == "swiss" then
      @output.concat("<h1> Ongoing Round #{current_round} Matches (#{name})</h1>\n")
    else
      @output.concat("<h1> Match data for Single Elimination Tournament '#{name}'</h1>\n")
      #@output.concat("<b>List of matches that have been going for more than 10 minutes</b><p>\n")
      @output.concat("<b>List of ongoing tournament matches.</b><p>\n")
    end
    @output.concat("Data last refreshed at <tt>#{Time.now.utc.to_s}</tt><br>\n")
    @output.concat("The round began at <tt>#{creation_time}</tt>\n")
    @output.concat("<p>\n")
    if @snapshot then
      @output.concat("")
    elsif @refresh then
      @output.concat("<a href='http://doc-x.net/hs#{@cgi.path_info}?bracket_id=#{@bracket_id}&refresh=false'>Update and <b>stop</b> refreshing every 60 seconds.</a><br>\n")
      @output.concat("<a href='http://doc-x.net/hs#{@cgi.path_info}?bracket_id=#{@bracket_id}&snapshot=true' target='_blank'>Take Tournament Snapshot.</a>\n")
    else
      @output.concat("<a href='http://doc-x.net/hs#{@cgi.path_info}?bracket_id=#{@bracket_id}&refresh=true'>Update and <b>begin</b> refreshing every 60 seconds.</a><br>\n")
      @output.concat("<a href='http://doc-x.net/hs#{@cgi.path_info}?bracket_id=#{@bracket_id}&snapshot=true'>Take Tournament Snapshot.</a> <b>Be Aware: Snapshots are always of the tournament state when you click, not whatever you see on this page.</b>\n")
    end
    @output.concat("\n")
    @output.concat("<ul>\n")
    ### END This is for match_status stuff. Filter out for non.ms.rb stuff? Put somewhere else?
  end
  return data_json
end

def get_single_elim_data(tourney_url)
  return if tourney_url.nil?
  @tournament_type = 'single_elim'
  data_json = Array.new
  1.upto(8) do |round|
    pdebug("Getting single_elim round data for #{round}")
    new_data = get_round(round, tourney_url)
    data_json.concat(new_data) unless new_data.nil?
  end
  return data_json
end

# Iterate through the rounds from top down until you find a round that has matches
def find_active_round(t_url=nil)
  9.downto(1) do |current_round|
    data_json = get_round(current_round, t_url)
    if data_json.length() > 0 then
      # Check to see if we're in a swiss or single-elim match
      pdebug("JSON has #{data_json.length()} elements")
      if data_json.length() == 1 then
        pdebug("We only have 1 event which seems suspicious. Going to assume this is Single Elim")
        #data_json = get_round(round=1, tourney_url=t_url)
        data_json = get_single_elim_data(t_url)
        return extract_json_data(data_json, 1)
      else
        return extract_json_data(data_json, current_round)
      end
    end
  end
  @output.concat("Went through all rounds and did not find matches. Seems bad, dawg.\n")
  exit
end

# Print user name (and ready status if they aren't ready)
def print_user(user=nil)
  return if user.nil?
  if @tournament_type == 'swiss' then
    name = user['name']
  else
    if user['team'].nil?
      name = 'team_not_defined'
    else
      name = user['team']['name']
    end
  end
  return if name.nil?
  if user['readyAt'].nil?
    name += " <font color='red'>(NOT-READY)</font>"
  end
  return name
end

# This will get the 
def get_active_round_json_data(hash=nil?, skip_match_status_stuff=nil)
  return if hash.nil?
  if skip_match_status_stuff.nil? then
    @skip_match_status_stuff = false
  else
    @skip_match_status_stuff = true
  end
  url = "#{@base_cf_url}/#{hash}/rounds"
  pdebug "Round URL: #{url}"
  data_json = find_active_round(t_url=url)
  return data_json
end

def get_match_url(hash=nil, t_id=nil, m_id=nil)
  return if hash.nil?
  return if t_id.nil?
  return if m_id.nil?
  if @tournament_hash[t_id].nil? then
    return "/hs/missing_tournament_urls.html"
  end
  return "#{@tournament_hash[t_id]}/#{hash}/match/#{m_id}"
end

def get_db_con
  pw = File.open("/home/docxstudios/hs_tournaments.pw").read.chomp
  con = Mysql2::Client.new(
    :host     => 'mysql.doc-x.net',
    :username => 'hs_tournaments',
    :password => pw,
    :database => 'hs_tournaments'
  )
  return con
end

def update_bracket_tracker(b_id=nil, t_id=nil)
  return if b_id.nil?
  return if t_id.nil?
  con = get_db_con
  query = "REPLACE INTO bracket_tracker (bracket_id, tournament_id) VALUES('#{b_id}', '#{t_id}')"
  con.query(query)
end

def print_swiss_match(f=nil)
  # If the match is not complete, print that out
  if not f['isComplete'] then
    tourney_id = f['top']['team']['tournamentID']
    match_url = get_match_url(hash=@tourney_hash, t_id=tourney_id, m_id=f['_id'])
    @output.concat("<li> <a href='#{match_url}' target='_blank'>Ongoing Match: #{f['matchNumber']} - #{print_user(f['top'])} vs #{print_user(f['bottom'])}</a>\n")
  else
    # Byes only have one user and are complete, so skip them
    return if f['isBye']
    # If the match is complete but one of the users is not ready, note that.
    if f['bottom']['readyAt'].nil? or f['top']['readyAt'].nil? then
      if f['bottom']['disqualified'] != true and f['top']['disqualified'] != true then
        tourney_id = f['top']['team']['tournamentID']
        match_url = get_match_url(hash=@tourney_hash, t_id=tourney_id, m_id=f['_id'])
        @output.concat("<li> <a href='#{match_url}' target='_blank'>Completd Match-User Not Ready: #{f['matchNumber']}  - #{print_user(f['top'])} vs #{print_user(f['bottom'])}</a>\n")
      end
    end
  end
end

def print_single_elim_match(f=nil)
  if not f['isComplete'] then
    pdebug("<pre>===\n#{f}</pre>")
    if not f['top'].nil? and not f['top']['team'].nil? and not f['top']['team']['tournamentID'].nil?
      now = Time.now
      updatedAt = DateTime.parse(f['updatedAt']).to_time.to_i
      diff = now - updatedAt
      # For these matches, we only *really* care about matches that are more than 10 minutes old
#      return unless diff.to_i >= 600
      # Also, we only print out matches if the players have not readied up
      return if f['top'].nil?
      return if f['top']['team'].nil?
      return unless f['top']['team']['readyAt'].nil?
      return if f['bottom'].nil?
      return if f['bottom']['team'].nil?
      return unless f['bottom']['team']['readyAt'].nil?
      tourney_id = f['top']['team']['tournamentID']
      match_url = get_match_url(@tourney_hash, tourney_id, f['_id'])
      @output.concat("<li> <a href='#{match_url}' target='_blank'>Ongoing Match: #{f['matchNumber']} - #{print_user(f['top'])} vs #{print_user(f['bottom'])}</a> [match duration #{Time.at(diff).utc.strftime('%H:%M:%S')}]\n")
    end
  else
    # Byes only have one user and are complete, so skip them
    return if f['isBye']
  end
  return "Unprocessed"
end

# Give a bracket ID and get the standings from that bracket
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
#    @output.concat "GOING TO DO THIS: #{query}"
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
    @output.concat "Had problem parsing #{raw_json}: #{e}"
    return Hash.new
  end
  return j_data
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

# Get top 8 players for this bracket
def get_bracket_top_8(dj=nil, type=nil, bid=nil)
  return if dj.nil?
  return if type.nil?
  return if bid.nil?
  pdebug "processing json data for #{bid}"
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
 pdebug "Adding 1 for #{name}" if name =~ /#{@tracked_player}/
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
 pdebug "Adding 1 for #{name}" if name =~ /#{@tracked_player}/
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

def add_bracket_url(bid=nil, burl=nil)
  return if bid.nil?
  return if burl.nil?
  if not defined? @bracket_urls or not @bracket_urls.is_a?(Hash) then
    @bracket_urls = Hash.new("undefined")
  end
  @bracket_urls[bid] = burl
end

# Something to get the JSON for a tournament from the battlefy API
def get_tournament_json(tid=nil)
  return if tid.nil?
  t_url = "https://api.battlefy.com/tournaments/#{tid}"
  pdebug "Retrieving info from #{t_url}"
  t_json = open(t_url, {ssl_verify_mode: 0}).read

  begin
    t_data = JSON.parse(t_json)
  rescue JSON::ParserError, Encoding::InvalidByteSequenceError => e
    @output.concat "Had problem parsing #{t_json}: #{e}"
    return { "undef" => "undef" }
  end
  return t_data
end

# Given a tournament ID, get the bracket ID for the bracket that shows
# the top X folks from that tournament.
def get_top_X_b_id_from_t_id(tid=nil)
  return if tid.nil?
  t_data = get_tournament_json(tid)

  slug = t_data['slug']
  b_url = "https://battlefy.com/hesports/#{slug}/#{tid}/stage/"
  b_id = "000"
  type = "undefined"

  unless t_data['stageIDs'][1].nil?
    # This should be a swiss tournament since it has two brackets
    # (presumably swiss, then top 8)
    pdebug " - Adding swiss event #{t_data['stageIDs'][1]} to b_ids"
    b_id = t_data['stageIDs'][1]
    type = 'swiss'
  else
    pdebug " - Adding possible single elim event #{t_data['stageIDs'][0]} to b_ids"
    b_id = t_data['stageIDs'][0]
    type = 'single'
  end
  b_url.concat("#{b_id}/bracket/")
  add_bracket_url(bid=b_id, burl=b_url)
  return { b_id => type }
end

def get_b_ids_from_t_ids(tids=nil)
  return if tids.nil?
  b_ids = Hash.new
  tids.each do |tid|
    result = get_top_X_b_id_from_t_id(tid)
    pdebug "Got '#{result}' for tid '#{tid}'"
    b_ids.merge!(result)
    pdebug "b_ids looks like this: #{b_ids}"
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

# Extract a list of active users from the JSON data provided
def get_users(dj=nil?)
  return if dj.nil?
  r_hash = Hash.new
  pdebug("Getting users from #{@tournament_type} tournament")
  dj.each do |f|
    if @tournament_type == 'swiss' then
      r_hash[f['top']['name']] = { :match_id => f['matchNumber'], :still_playing => true }  unless f['top']['name'].nil?
      r_hash[f['bottom']['name']] = { :match_id => f['matchNumber'], :still_playing => true }  unless f['bottom']['name'].nil?
    else
      # For single-elim, we note if a player names is still_playing (i.e. matches without an 'isComplete' attribute being true)
      # If they are still playing in an older tournament but played in and lost in the newer tournament, we still want to drop
      # them from the old tournament because that's a violation of the tournament policy
      still_playing = false
      unless f['isComplete'].nil? then
        still_playing = true
      end
      unless f['top']['team'].nil? then
        unless f['top']['team']['name'].nil?
          name = "#{prefix}#{f['top']['team']['name']}"
          unless r_hash[name].nil?
#            pdebug "Top Name is #{name}"
            r_hash[f['top']['name']] = { :match_id => f['matchNumber'], :still_playing => true }
            r_ary.push(name)
          end
        end
      end
      unless f['bottom']['team'].nil? then
        name = "#{prefix}#{f['bottom']['team']['name']}"
        unless r_ary.include? name
#          pdebug "Bot Name is #{name}"
          r_ary.push(name)
        end
      end
    end
  end
  # Now, let's filter out the folks who showed up as both active and inactive
  # and only keep the active ones
  bare_names = r_ary.grep_v(/^#{@dup_prefix}/)
  pdebug "Beginning bare_name comparison with #{bare_names.length} bare names"
  bare_names.each do |bn| 
#    pdebug "Checking #{bn}"
    dup_name = "#{@dup_prefix}#{bn}"
    if r_ary.include? dup_name then
#      pdebug "Removing '#{dup_name} from r_ary"
      r_ary = r_ary - [ dup_name ]
    end
  end
  pdebug "get_users: Total of #{r_hash.length} users in JSON "
  return r_ary.sort
end

def get_user_list(bid=nil)
  pdebug "Getting data for tournament '#{bid}'"
  @tournament_type = 'swiss'
  dj = get_active_round_json_data(bid)
  created_date = dj[0]['createdAt']
  pdebug "Tournament created at #{created_date}"
  users = get_users(dj)
  @output.concat "Total of #{users.length} users in bracket #{bid}"
  return users
end

