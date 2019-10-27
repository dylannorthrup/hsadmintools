#!/usr/bin/env ruby
#
#
# TEST CASES for check_top8s.rb

puts "Not implemented yet. Dylan needs to write something"
exit

# Read in utility methods and list of tournaments for current season
$: << "/home/docxstudios/web/hs/code"
# If we're using the debug version, set debug and alternate form url
if $0.match(/fd.rb$/) then
  require "hsm"
  @DEBUG = true if $0.match(/fd.rb$/)
  @form_url = 'http://doc-x.net/hs/fd.html'
else
  require "hs_methods"
end
require "tournament_urls"

@skip_match_data_stuff = true
@dup_prefix = 'zzz__'
@form_url = 'http://doc-x.net/hs/find_dupes.html'
@output = ""

@output.concat "Content-type: text/plain; charset=UTF-8\n"
@output.concat "\n"

# This replaces getting 'get_user_list(bracket_url)' for both brackets
b1_json = JSON.parse(File.read("/home/docxstudios/web/hs/code/json_examples/completed-matches.json"))
d1_users = get_users(b1_json)

b2_json = JSON.parse(File.read("/home/docxstudios/web/hs/code/json_examples/ongoing-matches.json"))
d2_users = get_users(b2_json)

@output.concat "Comparing user lists\n"
@output.concat "+++++++++++++++++++++++++\n"
#puts "Before d1_users"
#puts "#{d1_users}"
#puts "After d1_users"

d1_names = d1_users.keys.sort_by { |name| name.downcase }

total_double_dippers = 0
d1_names.each do |name|
  v = d1_users[name]
  if d2_users.keys.include?(name) then
    total_double_dippers += 1
    @output.concat "* Double dipper: #{name}\n"
  end
end

@output.concat "+++++++++++++++++++++++++\n"
@output.concat "Comparison complete\n"
@output.concat "Found #{total_double_dippers} total double dippers"

puts @output
