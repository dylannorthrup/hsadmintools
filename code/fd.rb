#!/usr/bin/env ruby
#

# Read in utility methods and list of tournaments for current season
$: << "/home/docxstudios/web/hs/code"
require "hs_methods"
require "tournament_urls"

@cgi = CGI.new
params = @cgi.params

@DEBUG = true if $0.match(/fd.rb$/)
@dup_prefix = 'zzz__'
@target_url = 'http://doc-x.net/hs/find_dupes.html'

# If you want to test this, you can uncomment these and put in valid bracket_ids
#params['b1'] = '000000000000000000000000'
#params['b2'] = '000000000000000000000000'

if params.empty? then
  bail_and_redirect(target=@target_url)
end
if params['b1'].nil? and pramas['b2'].nil?
  bail_and_redirect(target=@target_url)
end

puts "Content-type: text/plain; charset=UTF-8"
puts ""

pdebug "Params"
pdebug "#{params}"

b1 = params['b1'][0]
b2 = params['b2'][0]

if b1.nil? or b2.nil? then
  puts "Something weird happened. Try refreshing your browser. Or yell at Dylan"
  puts "DEBUG: b1='#{b1}' b2='#{b2}'"
end

# This was short-circuited previously. DEBUG WHY THIS IS
if bogus_match_data(b1) then
  tell_em_dano(b1)
end
if bogus_match_data(b2) then
  tell_em_dano(b2)
end

# 24 hex characters
t1_hash = b1
t2_hash = b2

d1_users = get_user_list(b1)
d2_users = get_user_list(b2)

puts "========== FOR SINGLE ELIM TOURNAMENTS ================================ "
puts "If the single elim tournament is the newest tournament, you should also "
puts "drop players with '#{@dup_prefix}' in front of their names since they "
puts "played, but lost quickly in the new single elim tournament"
puts "========== FOR SINGLE ELIM TOURNAMENTS ================================ "
puts ""
puts "Comparing user lists"
puts "+++++++++++++++++++++++++"
d1_users.each do |u|
  if d2_users.include?(u) then
    puts "* Double dipper: #{u}"
  end
end

puts "+++++++++++++++++++++++++"
puts "Comparison complete"


