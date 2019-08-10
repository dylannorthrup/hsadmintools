#!/usr/bin/env ruby
#

require 'open-uri'
require 'json'
require 'cgi'

@cgi = CGI.new
params = @cgi.params

@DEBG=false
@DEBUG = true if $0.match(/fd.rb$/)

def pdebug(msg="")
  return unless @DEBUG
  puts("DEBUG: #{msg}<br>\n")
end

def bail_and_redirect
  target_url = 'http://doc-x.net/hs/find_dupes.html'
  @cgi.out( "status" => "REDIRECT", "Location" => target_url, "type" => "text/html") {
    "Redirecting to data input page: #{target_url}\n"
  }
  exit
end

def bogus_match_data(bid=nil?)
  ### Short Circuit
  return false
  ### Short Circuit
  return true if bid.nil?
  return false if bid.match(/^[a-f0-9]{24}$/)
  return true
end

def tell_em_dano(bid=nil)
  puts "Provided bracket ID (#{b1}) did not match pattern. Hit the back button and try again."
  exit
end

#params['b1'] = '000000000000000000000000'
#params['b2'] = '000000000000000000000000'

if params.empty? then
  bail_and_redirect
end
if params['b1'].nil? and pramas['b2'].nil?
  bail_and_redirect
end

puts "Content-type: text/plain; charset=UTF-8"
puts ""

puts "Params"
puts "#{params}"

b1 = params['b1'][0]
b2 = params['b2'][0]

if b1.nil? or b2.nil? then
  puts "Something weird happened. Try refreshing your browser. Or yell at Dylan"
  puts "DEBUG: b1='#{b1}' b2='#{b2}'"
end

if bogus_match_data(b1) then
  tell_em_dano(b1)
end
if bogus_match_data(b2) then
  tell_em_dano(b2)
end

@base_cf_url = 'https://dtmwra1jsgyb0.cloudfront.net/stages'
# 24 hex characters
t1_hash = b1
t2_hash = b2

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
    puts("Had problem parsing #{path}: #{e}\n")
    return Hash.new
  end
  return j_data
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

def extract_json_data(data_json=nil, current_round=nil)
  return if data_json.nil?
  return if current_round.nil?
  @active_round = current_round
  return data_json
end



# Iterate through the rounds from top down until you find a round that has matches
def find_active_round(t_url=nil)
  8.downto(1) do |current_round|
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
  puts("Went through all rounds and did not find matches. Seems bad, dawg.\n")
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
    name += " (NOT-READY)"
  end
  return name
end

def get_json_data(hash=nil?)
  return if hash.nil?
  url = "#{@base_cf_url}/#{hash}/rounds"
  puts "Round URL: #{url}"
  data_json = find_active_round(t_url=url)
  return data_json
end

def get_users(dj=nil?)
  return if dj.nil?
  r_ary = []
  pdebug("Getting users from #{@tournament_type} tournament")
  dj.each do |f|
    if @tournament_type == 'swiss' then
      r_ary.push(f['top']['name']) unless f['top']['name'].nil?
      r_ary.push(f['bottom']['name']) unless f['bottom']['name'].nil?
    else
      # For single-elim, we only add players who are active (i.e. have a match
      # without a 'winner' attribute)
      unless f['top']['team'].nil? then
        if f['top']['winner'].nil? then
          r_ary.push(f['top']['team']['name']) unless f['top']['team']['name'].nil?
        end
      end
      unless f['bottom']['team'].nil? then
        if f['bottom']['winner'].nil? then
          r_ary.push(f['bottom']['team']['name']) unless f['bottom']['team']['name'].nil?
        end
      end
    end
  end
  return r_ary
end

def get_user_list(bid=nil)
  puts "Getting data for tournament '#{bid}'"
  @tournament_type = 'swiss'
  dj = get_json_data(bid)
  users = get_users(dj)
  puts "Total of #{users.length} users in bracket #{bid}"
end

d1_users = get_user_list(b1)
d2_users = get_user_list(b2)

puts "Comparing user lists"
puts "+++++++++++++++++++++++++"
d1_users.each do |u|
  u1 = u['name']
  if d2_users.include?(u) then
    puts "* Double dipper: #{u}"
  end
end

puts "+++++++++++++++++++++++++"
puts "Comparison complete"


