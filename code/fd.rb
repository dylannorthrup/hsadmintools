#!/usr/bin/env ruby
#

require 'open-uri'
require 'json'
require 'cgi'

cgi = CGI.new
params = cgi.params

def bail_and_redirect()
  target_url = 'http://doc-x.net/hs/find_dupes.html'
  cgi.out( "status" => "REDIRECT", "Location" => target_url, "type" => "text/html") {
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

params['b1'] = '000000000000000000000000'
params['b2'] = '000000000000000000000000'

if params.empty? then
  bail_and_redirect
end
if params['b1'].nil? and pramas['b2'].nil?
  bail_and_redirect
end

puts "Content-type: text/plain"
puts ""

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
  puts "Full URL: #{full_url}"
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
  return if t_url.nil?
#  puts "t_url: #{t_url}"
  8.downto(1) do |current_round|
    data_json = get_round(round=current_round, tourney_url=t_url)
    if data_json.length() > 0 then
      puts "---> Using player list from round #{current_round}"
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
#  puts "Round URL: #{url}"
  data_json = find_active_round(t_url=url)
  return data_json
end

def get_users(dj=nil?)
  return if dj.nil?
  r_ary = []
  dj.each do |f|
    r_ary.push(f['top']['name']) unless f['top']['name'].nil?
    r_ary.push(f['bottom']['name']) unless f['bottom']['name'].nil?
  end
  return r_ary
end

puts "Getting data for tournament 1 (#{b1})"
#dj1 = get_json_data(b1)
dj1 = JSON.parse(File.read('/home/docxstudios/web/hs/code/t1.json'))
puts "Getting data for tournament 2 (#{b2})"
#dj2 = get_json_data(b2)
dj2 = JSON.parse(File.read('/home/docxstudios/web/hs/code/t2.json'))

d1_users = get_users(dj1)
puts "d1_users: #{d1_users.length}"
d2_users = get_users(dj2)
puts "d2_users: #{d2_users.length}"

puts "Comparing user lists"
puts "+++++++++++++++++++++++++"
d1_users.each do |u|
  u1 = u['name']
#  puts "= Checking #{u}"
  if d2_users.include?(u) then
    puts "* Double dipper: #{u}"
  end
end

puts "+++++++++++++++++++++++++"
puts "Comparison complete"


