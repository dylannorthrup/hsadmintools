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
@tour_stop='Dalaran'
@invite_url = 'https://majestic.battlefy.com/hearthstone-masters/invitees'

# Variables for the tables we're going to use (with default values) in case we 
# want to override them
@bracket_tracker_table = 'bracket_tracker'
@tournament_list_table = 'tournament_list'                                                              
@cached_standings_table = 'cached_standings'                                                              

# Adding a bit of functionality to the Hash class so we can 
# more easily delete things later on
class Hash
  # Returns a hash that includes everything but the given keys.
  #   hash = { a: true, b: false, c: nil}
  #   hash.except(:c) # => { a: true, b: false}
  #   hash # => { a: true, b: false, c: nil}
  #
  # This is useful for limiting a set of parameters to everything but a few known toggles:
  #   @person.update(params[:person].except(:admin))
  def except(*keys)
    dup.except!(*keys)
  end

  # Replaces the hash without the given keys.
  #   hash = { a: true, b: false, c: nil}
  #   hash.except!(:c) # => { a: true, b: false}
  #   hash # => { a: true, b: false }
  def except!(*keys)
    keys.each { |key| delete(key) }
    self
  end
end


def pout(msg="")
  # If @output is not defined, blank, or nil; explicitly set it to nil
  @output ||= nil
  # If we don't do the above and @output wasn't defined, we get an error here.
  if @output.nil? then
    # If we're here, it means we should print to STDERR because our calling script
    # hasn't defined an '@output' variable that it wants to print things to.
    STDERR.puts("DEBUG: #{msg}<br>")
  else
    # Otherwise, farm this out to whatever IO object @output is set to
    @output.concat("DEBUG: #{msg}<br>\n")
  end
end

def pdebug(msg="")
  return unless @DEBUG
  # If @output is not defined, blank, or nil; explicitly set it to nil
  @output ||= nil
  # If we don't do the above and @output wasn't defined, we get an error here.
  if @output.nil? then
    # If we're here, it means we should print to STDERR because our calling script
    # hasn't defined an '@output' variable that it wants to print things to.
    STDERR.puts("DEBUG: #{msg}<br>")
  else
    # Otherwise farm this out to 'pout()'
    pout("DEBUG: #{msg}<br>\n")
  end
end

def bail_and_redirect(target=nil?)
  target_url = 'https://doc-x.net/hs/'
  unless target.nil? then
    target_url = target
  end
  @cgi.out( "status" => "REDIRECT", "Location" => target_url, "type" => "text/html") {
    "Redirecting to data input page: #{target_url}\n"
  }
  exit
end

# Do the "massage URL to bracket_id" and "verify bracket id is well formed
# or bark" bits in one method
def validate_and_set_bracket_id_and_tourney_hash(bid=nil?)
  @bracket_id = derive_bracket_id_from_parameter(bid)
  if @bracket_id.nil? then
    @output.concat("<pre>\n")
    @output.concat("Something weird happened. Try manually refreshing your browser. Or yell at Dylan\n")
    @output.concat("DEBUG: '#{@bracket_id}'\n")
    @output.concat("</pre>\n")
  end

  if bogus_match_data(@bracket_id) then
    tell_em_dano(@bracket_id, params['bracket_id'][0])
    exit
  end
  @tourney_hash = @bracket_id
  return true
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
  pout("<pre>\n")
  pout("Provided bracket ID ('#{bid}' derived from '#{obid}') did not match pattern. Hit the back button and try again.\n")
  if obid.match(/info$/) then
    pout("It looks like you copied the link from the Master Tracker and not the actual bracket URL. Make sure you're using the Bracket URL if you're pasting a URL.\n")
    pout("A bracket URL will contain the text '/stage/' and '/bracket/' in it.\n")
  end
  pout("</pre>\n")
  pout("</body>\n")
  pout("</html>\n")
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
    pout("Had problem parsing #{path}: #{e}\n")
    return Hash.new
  end
  return j_data
end

def new_get_match_name(bid=@bracket_id)
  return if bid.nil?
  
  full_url = "#{@base_cf_url}/#{bid}"
  pdebug("New full url: #{full_url}")
  raw_json = open(full_url, {ssl_verify_mode: 0}).read
  pdebug("get_match_name raw json: #{raw_json}")
  begin
    j_data = JSON.parse(raw_json)
  rescue JSON::ParserError, Encoding::InvalidByteSequenceError => e
    pout "Had problem parsing #{raw_json}: #{e}"
    return "tournaments"
  end
  if j_data['name'].nil? then
    return "No name for tournament #{bid}" 
  end
  name = j_data['name'].clone
  return name
#  return "new_match_hame"
end

def get_match_name(hash=nil, t_id=nil)
#  pout("In get_match_name with t_id '#{t_id}'\n")
  return if hash.nil?
  return if t_id.nil?
#  if @tournament_hash[t_id].nil? then
#    return "No name for hash #{t_id}"
#  end
  name = @tournament_hash[t_id].clone
  name.gsub!('https://battlefy.com/hsesports/', '')
  name.gsub!(/\/.*/, '')
#  pout("get_match_name found name of #{name} for #{t_id}</pre>\n")
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
    if name == "tournaments" then
      name = new_get_match_name(@bracket_id)
    end
    #      pout("Name is #{name}\n")
    if @tournament_type == "swiss" then
      pout("<h1> Ongoing Round #{current_round} Matches (#{name})</h1>\n")
    else
      pout("<h1> Match data for Single Elimination Tournament '#{name}'</h1>\n")
      #pout("<b>List of matches that have been going for more than 10 minutes</b><p>\n")
      pout("<b>List of ongoing tournament matches.</b><p>\n")
    end
    pout("Data last refreshed at <tt>#{Time.now.utc.to_s}</tt><br>\n")
    pout("The round began at <tt>#{creation_time}</tt>\n")
    pout("<p>\n")
    if @snapshot then
      pout("")
    elsif @refresh then
      pout("<a href='https://doc-x.net/hs#{@cgi.path_info}?bracket_id=#{@bracket_id}&refresh=false'>Update and <b>stop</b> refreshing every 60 seconds.</a><br>\n")
      pout("<a href='https://doc-x.net/hs#{@cgi.path_info}?bracket_id=#{@bracket_id}&snapshot=true' target='_blank'>Take Tournament Snapshot.</a>\n")
    else
      pout("<a href='https://doc-x.net/hs#{@cgi.path_info}?bracket_id=#{@bracket_id}&refresh=true'>Update and <b>begin</b> refreshing every 60 seconds.</a><br>\n")
      pout("<a href='https://doc-x.net/hs#{@cgi.path_info}?bracket_id=#{@bracket_id}&snapshot=true'>Take Tournament Snapshot.</a> <b>Be Aware: Snapshots are always of the tournament state when you click, not whatever you see on this page.</b>\n")
    end
    pout("\n")
    pout("<ul>\n")
    ### END This is for match_status stuff. Filter out for non.ms.rb stuff? Put somewhere else?
  end
  return data_json
end

def get_single_elim_data(tourney_url)
  return if tourney_url.nil?
  @tournament_type = 'single_elim'
  data_json = Array.new
  1.upto(10) do |round|
    pdebug("Getting single_elim round data for #{round}")
    new_data = get_round(round, tourney_url)
    data_json.concat(new_data) unless new_data.nil?
  end
  return data_json
end

# Iterate through the rounds from top down until you find a round that has matches
def find_active_round(t_url=nil)
  10.downto(1) do |current_round|
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
  #pout("Went through all rounds for #{t_url} and did not find matches. Seems bad, dawg.\n")
  pdebug "Went through all rounds for #{t_url} and did not find matches. Seems bad, dawg."
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
  query = "REPLACE INTO #{@bracket_tracker_table} (bracket_id, tournament_id) VALUES('#{b_id}', '#{t_id}')"
  con.query(query)
end

def print_swiss_match(f=nil)
  # If the match is not complete, print that out
  if not f['isComplete'] then
    tourney_id = f['top']['team']['tournamentID']
    match_url = get_match_url(hash=@tourney_hash, t_id=tourney_id, m_id=f['_id'])
    pout("<li> <a href='#{match_url}' target='_blank'>Ongoing Match: #{f['matchNumber']} - #{print_user(f['top'])} vs #{print_user(f['bottom'])}</a>\n")
  else
    # Byes only have one user and are complete, so skip them
    return if f['isBye']
    # If the match is complete but one of the users is not ready, note that.
    if f['bottom']['readyAt'].nil? or f['top']['readyAt'].nil? then
      if f['bottom']['disqualified'] != true and f['top']['disqualified'] != true then
        tourney_id = f['top']['team']['tournamentID']
        match_url = get_match_url(hash=@tourney_hash, t_id=tourney_id, m_id=f['_id'])
        pout("<li> <a href='#{match_url}' target='_blank'>Completd Match-User Not Ready: #{f['matchNumber']}  - #{print_user(f['top'])} vs #{print_user(f['bottom'])}</a>\n")
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
      # Get tourney_id and use that to make match_url
      tourney_id = f['top']['team']['tournamentID']
      match_url = get_match_url(@tourney_hash, tourney_id, f['_id'])
      pout("<li> <a href='#{match_url}' target='_blank'>Ongoing Match: #{f['matchNumber']} - #{print_user(f['top'])} vs #{print_user(f['bottom'])}</a> [match last updated #{Time.at(diff).utc.strftime('%H:%M:%S')} ago]\n")
    end
  else
    # Byes only have one user and are complete, so skip them
    return if f['isBye']
  end
  return "Unprocessed"
end

def get_manual_invites()
  return if @invite_url.nil?
  raw_json = open(@invite_url, {ssl_verify_mode: 0}).read
  begin
    j_data = JSON.parse(raw_json)
  rescue JSON::ParserError, Encoding::InvalidByteSequenceError => e
    pout "Had problem parsing #{raw_json}: #{e}"
    return Hash.new
  end
#  binding.pry
  j_data.each do |invite|
    # Skip invites that aren't for this stop
    next unless invite['tourStop'] == @tour_stop
    # for now, skip invites taht don't have an actual reason listed
    slug = invite['tournamentSlug']
    next if invite['reason'].nil? and slug.nil?
    reason = invite['reason']
    unless slug.nil? then
      reason = "Winner of #{slug}"
    end
    name = invite['battletag']
    @players[name] = @invite_win_tag
    @invite_reason[name] = reason
    pdebug ("Adding #{name} with #{@players[name]} wins for this reason: #{@invite_reason[name]}")
  end
end
  
# Give a bracket ID and get the standings from that bracket
def get_standings(bracket_id=nil, cache=false)
  return if bracket_id.nil?
  # Check if info is in database already
  query = "SELECT json_blob FROM cached_standings WHERE bracket_id='#{bracket_id}'"
  results = @con.query(query)
  # If we didn't get a result, go ahead and grab it and cache it in the DB
  pdebug "Got #{results.count} results back for bid #{bracket_id}"
  if results.count == 0
    pdebug("Did not find cached info for #{bracket_id}")
    bracket_url = "https://api.battlefy.com/stages/#{bracket_id}/matches"
    pdebug "Full URL: #{bracket_url}"
    raw_json = open(bracket_url, {ssl_verify_mode: 0}).read
    # Only cache tournament data if we explicitly tell it to
    if cache
      query = "INSERT INTO cached_standings (bracket_id, json_blob) values ('#{bracket_id}', '#{Mysql2::Client.escape(raw_json)}')"
      @con.query(query)
    end
  else
    pdebug("Using cached info for #{bracket_id}")
    row = results.first
    # If we got a result, use that
    raw_json = row['json_blob'].to_s
  end

  begin
    j_data = JSON.parse(raw_json)
  rescue JSON::ParserError, Encoding::InvalidByteSequenceError => e
    pout "Had problem parsing #{raw_json}: #{e}"
    return Hash.new
  end
  return j_data
end

def get_tournament_ids
  query = "SELECT tournament_id FROM #{@bracket_tracker_table};"
  results = @con.query(query).to_a
  rows = Array.new
  results.each do |row|
    rows << row['tournament_id']
  end
  return rows
end

def get_completed_tournament_ids
  q = "SELECT tournament_id FROM #{@tournament_list_table} WHERE completed is TRUE"
  results = @con.query(q).to_a
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
  # Used to be, this came sorted from Battlefy. Now, I need to explicitly sort the match data
  # by rounds. *sigh*
  unsorted = dj
  dj = unsorted.sort_by { |k| k['roundNumber'] }
  pdebug "processing json data for #{bid}"
  pdebug "BID: #{@tracked_bracket} bracket_json for what we think is the top 8\n: #{dj.last(7).first(4)}" if bid =~ /#{@tracked_bracket}/
  # Take dj. Grab the last 7 elements (in case we're single elim, we're
  # just interested in the last 7 events), then look at the first four
  # of the resultant list (the round of 8) and get the folks from there
  dj.last(7).first(4).each do |p|
    # Double check that if we say we are in a single elim
    # tournament, we actually ARE a single elim tournament
    if type == 'single' then
      pdebug "BID: #{@tracked_bracket}==#{bid} (single) Doing checks" if bid =~ /#{@tracked_bracket}/
      return if p["matchType"].nil?
      pdebug "BID: #{@tracked_bracket} had a match Type of #{p['matchType']} in round #{p['roundNumber']}" if bid =~ /#{@tracked_bracket}/
      return unless p["matchType"] == 'winner'
      pdebug "BID: #{@tracked_bracket} matchType was 'winner' so we keep trucking" if bid =~ /#{@tracked_bracket}/
    end
    # Throw checking in here because single elim matches could be set up but
    # not have a player populated yet which throws an error
    pdebug "BID: #{@tracked_bracket} Checking if we have data for the top of the match" if bid =~ /#{@tracked_bracket}/
    unless p['top'].nil? or p['top']['team'].nil? or p['top']['team']['name'].nil? then
      name = p['top']['team']['name']
      pdebug "BID: #{@tracked_bracket} top name is #{name}" if bid =~ /#{@tracked_bracket}/
      pdebug "Adding 1 for #{name} for bracket #{bid}" if name =~ /#{@tracked_player}/
      @players[name] += 1
      if @tournament_placements[name].nil? then
         @tournament_placements[name] = Array.new
      end
      unless @tournament_placements[name].include? bid then
        @tournament_placements[name] << bid
      end
    else
      pdebug "BID: #{@tracked_bracket} Did not get user we expected for top bracket: #{p['top']}" if bid =~ /#{@tracked_bracket}/
    end
    pdebug "BID: #{@tracked_bracket} Checking if we have data for the bottom of the match" if bid =~ /#{@tracked_bracket}/
    unless p['bottom'].nil? or p['bottom']['team'].nil? or p['bottom']['team']['name'].nil? then
      name = p['bottom']['team']['name']
      pdebug "BID: #{@tracked_bracket} bottom name is #{name}" if bid =~ /#{@tracked_bracket}/
      pdebug "Adding 1 for #{name} for bracket #{bid}" if name =~ /#{@tracked_player}/
      if @tournament_placements[name].nil? then
         @tournament_placements[name] = Array.new
      end
      @players[name] += 1
      unless @tournament_placements[name].include? bid then
        @tournament_placements[name] << bid
      end
    end
    pdebug "BID: #{@tracked_bracket} thing" if bid =~ /#{@tracked_bracket}/
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
    pout "Had problem parsing #{t_json}: #{e}"
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
  ret_str = "#{name} "
  unless @invite_reason[name].nil? then
    ret_str.concat(" </td><td> '#{@invite_reason[name]}'")
    return ret_str
  end
  unless @tournament_placements[name].nil? then
    ret_str.concat("(#{num} top #{@top_x} placements: ")
    @tournament_placements[name].each do |t|
      ret_str.concat("<a href='#{@bracket_urls[t]}'>link</a>, ")
      pdebug("num is #{num}, ret_str is #{ret_str}")
    end
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
      r_hash[f['top']['name']] = { :match_id => f['matchNumber'], :still_winning => true }  unless f['top']['name'].nil?
      r_hash[f['bottom']['name']] = { :match_id => f['matchNumber'], :still_winning => true }  unless f['bottom']['name'].nil?
    else
      # For single-elim, we note if a player still_winning (i.e. matches where their "team" hs marked
      # as 'winner: false') If they are still playing in an older tournament 
      # but played in and lost in the newer tournament, we still want to drop them from the 
      # old tournament because that's a violation of the tournament policy.
      unless f['top']['team'].nil? then
        unless f['top']['team']['name'].nil?
          name = "#{f['top']['team']['name']}"
          # If a match has not completed, we count that as 'still_winning'
          # Otherwise, the match is done and we go with whatever the result was
          if f['isComplete'].nil? then
            still_winning = true
          else
            still_winning = f['top']['winner']
          end
          # If we've added them before, then we update their :still_winning attribute to whatever 
          # we derived it as above.
          if r_hash.keys.include? name 
            r_hash[name][:still_winning] = still_winning
          else
            r_hash[name] = { :match_id => f['matchNumber'], :still_winning => still_winning }
            pdebug "> Top Name is #{name} and hash is #{r_hash[name]}"
          end
        end
      end
      unless f['bottom']['team'].nil? then
        unless f['bottom']['team']['name'].nil?
          name = "#{f['bottom']['team']['name']}"
          # If a match has not completed, we count that as 'still_winning'
          # Otherwise, the match is done and we go with whatever the result was
          if f['isComplete'].nil? then
            still_winning = true
          else
            still_winning = f['bottom']['winner']
          end
          # If we've added them before, then we update their :still_winning attribute to whatever 
          # we derived it as above.
          if r_hash.keys.include? name 
            r_hash[name][:still_winning] = still_winning
          else
            r_hash[name] = { :match_id => f['matchNumber'], :still_winning => still_winning }
            pdebug "> Top Name is #{name} and hash is #{r_hash[name]}"
          end
        end
      end
    end
  end
  pdebug "get_users: Total of #{r_hash.length} users in JSON "
  return r_hash
end

def get_user_list(bid=nil, skip_mss=false)
  pdebug "Getting data for tournament '#{bid}'"
  @tournament_type = 'swiss'
  dj = get_active_round_json_data(bid, skip_mss)
  created_date = dj[0]['createdAt']
  pdebug "Tournament created at #{created_date}"
  users = get_users(dj)
  pout "Total of #{users.length} users in bracket #{bid}\n"
  return users
end

# Get the "tournament_order" for a tournament based on it's bracket_id
def get_tournament_order_by_bid(bid=nil)
  return 0 if bid.nil?
  con = get_db_con
  q = "SELECT tournament_order FROM #{@tournament_list_table} WHERE bracket_id LIKE '#{bid}'"
  results = con.query(q)
  # If we didn't get a result, then something is wonky
  if results.count == 0
    return 0
  end
  order = results.first['tournament_order']
  return order
end

# Do the comparisons between two hashes to see if there are double dippers.
# The first hash we get is for the newer tournament and the second is for the
# older tournament.
def find_double_dippers(newer_users={}, older_users={})
  ret_out = ""
  ret_out.concat "Comparing user lists\n"
  ret_out.concat "+++++++++++++++++++++++++\n"
  
  newer_names = newer_users.keys.sort_by { |name| name.downcase }
  
  total_double_dippers = 0
  newer_names.each do |name|
    if older_users.keys.include?(name) and older_users[name][:still_winning] then
      total_double_dippers += 1
      ret_out.concat "* Double dipper: #{name}\n"
    end
  end
  
  ret_out.concat "+++++++++++++++++++++++++\n"
  ret_out.concat "Comparison complete\n"
  ret_out.concat "Found #{total_double_dippers} total double dippers"
  return ret_out
end
