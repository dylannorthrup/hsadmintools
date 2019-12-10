#!/usr/bin/env ruby
#

# Read in utility methods and list of tournaments for current season
$: << "/home/docxstudios/web/hs/code"
# If we're using the debug version, set debug and alternate form url
if $0.match(/fd.rb$/) then
  require "hsm"
  @DEBUG = true if $0.match(/fd.rb$/)
  @form_url = 'https://doc-x.net/hs/fd.html'
else
  require "hs_methods"
end
require "tournament_urls"

@cgi = CGI.new
params = @cgi.params

@output = ''
@skip_match_data_stuff = true
@dup_prefix = 'zzz__'
@form_url = 'https://doc-x.net/hs/find_dupes.html'
@output = ""

# If you want to test this, you can uncomment these and put in valid bracket_ids
#params['b1'] = '5d98be246313cd683c69ac92'
#params['b2'] = '5d98864aee6bff69e6e48f3d'
#
# Or, you can do the following (for the same data):
# companion> echo 'b1=5d98be246313cd683c69ac92&b2=5d98864aee6bff69e6e48f3d' | ./fd.rb

if params.empty? then
  bail_and_redirect(target=@form_url)
end
if params['b1'].nil? and pramas['b2'].nil?
  bail_and_redirect(target=@form_url)
end

@output.concat "Content-type: text/plain; charset=UTF-8\n"
@output.concat "\n"

pdebug "Params"
pdebug "#{params}"

b1 = params['b1'][0]
b2 = params['b2'][0]

# Make sure our bracket data isn't empty
if b1.nil? or b2.nil? then
  @output.concat "Something weird happened. Try refreshing your browser. Or yell at Dylan\n"
  @output.concat "DEBUG: b1='#{b1}' b2='#{b2}'\n"
end

# Make sure we're not comparing a bracket against itself
if b1 == b2 then
  @output.concat "Your brackets are identical. Probably a copy/paste error. Try again."
  puts @output
  exit
end

# Validate that our match data is well formed.
if bogus_match_data(b1) then
  tell_em_dano(b1)
end
if bogus_match_data(b2) then
  tell_em_dano(b2)
end

# For each bracket, get the list of active users in that bracket
d1_users = get_user_list(b1, true)
d2_users = get_user_list(b2, true)

# Uncomment this for capturing interesting JSON data.
#@out_dir = '/home/docxstudios/web/hs/code/json_examples'
#d1_json = get_active_round_json_data(b1, true)
#fqfn = "#{@out_dir}/#{b1}-all-matches.json"
#File.open(fqfn, 'w') { |file| file.write(d1_json.to_json) }
#d2_json = get_active_round_json_data(b2, true)
#fqfn = "#{@out_dir}/#{b2}-all-matches.json"
#File.open(fqfn, 'w') { |file| file.write(d2_json.to_json) }

# Find out which tournament was most recent tournament (so we can ignore whether
# or not the player is 'still_winning' because they shouldn't be in this new
# tournament if they're 'still_winning' in the old one).
d1_tournament_order = get_tournament_order_by_bid(b1)
d2_tournament_order = get_tournament_order_by_bid(b2)

if d1_tournament_order > d2_tournament_order
  @output.concat find_double_dippers(d1_users, d2_users)
else
  @output.concat find_double_dippers(d2_users, d1_users)
end

puts @output
