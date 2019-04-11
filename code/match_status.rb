#!/usr/bin/env ruby
#
#

require 'open-uri'
require 'json'
require 'cgi'

cgi = CGI.new
params = cgi.params

def bail_and_redirect()
  target_url = 'http://doc-x.net/hs/match_status.html'
  cgi.out( "status" => "REDIRECT", "Location" => target_url, "type" => "text/html") {
    "Redirecting to data input page: #{target_url}\n"
  }
  exit
end

def bogus_match_data(bid=nil?)
  return true if bid.nil?
  return false if bid.match(/^[a-f0-9]{24}$/)
  return true
end

def tell_em_dano(bid=nil)
  puts "Provided bracket ID (#{bid}) did not match pattern. Hit the back button and try again."
#  exit
end

if params.empty? then
  bail_and_redirect
end
if params['bracket_id'].nil?
  bail_and_redirect
end

puts "Content-type: text/plain"
puts ""

bracket_id = params['bracket_id'][0]

if bracket_id.nil? then
  puts "Something weird happened. Try refreshing your browser. Or yell at Dylan"
  puts "DEBUG: '#{bracket_id}'"
end

if bogus_match_data(bracket_id) then
  tell_em_dano(bracket_id)
  exit
end

@base_cf_url = 'https://dtmwra1jsgyb0.cloudfront.net/stages'
# 24 hex characters
tourney_hash = bracket_id

# Give a round number and get the results from that round
def get_round(round=nil, tourney_url=nil)
  return if round.nil?
  return if tourney_url.nil?
  full_url = "#{tourney_url}/#{round}/matches"
#  puts "Full URL: #{full_url}"
  raw_json = open(full_url, {ssl_verify_mode: 0}).read

  begin
    j_data = JSON.parse(raw_json)
  rescue JSON::ParserError, Encoding::InvalidByteSequenceError => e
    puts "Had problem parsing #{path}: #{e}"
    return Hash.new
  end
  return j_data
end

# Iterate through the rounds from top down until you find a round that has matches
def find_active_round(t_url=nil)
  8.downto(1) do |current_round|
    data_json = get_round(round=current_round, tourney_url=t_url)
    if data_json.length() > 0 then
      puts "=== ONGOING ROUND #{current_round} MATCHES ==="
      return data_json
    end
  end
  puts "Went through all rounds and did not find matches. Seems bad, dawg."
  exit
end

# Print user name (and ready status if they aren't ready)
def print_user(user=nil)
  return if user.nil?
  name = user['name']
  return if name.nil?
  if user['readyAt'].nil?
    name += " (NOT-READY)"
  end
  return name
end

def get_json_data(hash=nil?)
  return if hash.nil?
  url = "#{@base_cf_url}/#{hash}/rounds"
  data_json = find_active_round(url)
  return data_json
end

data_json = get_json_data(tourney_hash)

data_json.each do |f|
  # If the match is not complete, print that out
  if not f['isComplete'] then
    puts "Ongoing Match: #{f['matchNumber']} - #{print_user(f['top'])} vs #{print_user(f['bottom'])}"
  else
    # Byes only have one user and are complete, so skip them
    next if f['isBye']
    # If the match is complete but one of the users is not ready, note that.
    if f['bottom']['readyAt'].nil? or f['top']['readyAt'].nil? then
      puts "Completd Match-User Not Ready: #{f['matchNumber']}  - #{print_user(f['top'])} vs #{print_user(f['bottom'])}"
    end
  end
end



