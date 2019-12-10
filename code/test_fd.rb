#!/usr/bin/env ruby
#
#
# TEST CASES for find_dupes.rb

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

@skip_match_data_stuff = true
@dup_prefix = 'zzz__'
@form_url = 'https://doc-x.net/hs/find_dupes.html'
@output = ""

@output.concat "Content-type: text/plain; charset=UTF-8\n"
@output.concat "\n"

# This replaces getting 'get_user_list(bracket_url)' for both brackets
b1_json = JSON.parse(File.read("/home/docxstudios/web/hs/code/json_examples/completed-matches.json"))
d1_users = get_users(b1_json)

b2_json = JSON.parse(File.read("/home/docxstudios/web/hs/code/json_examples/ongoing-matches.json"))
d2_users = get_users(b2_json)

# We run this with d2_users first since it's the newer tournament
@output.concat find_double_dippers(d2_users, d1_users)

puts @output

################################
#
# Now, time to check the results
#
################################

# A quick method to check the candidates we expect actually showed up in the output
def check_candidates(output_string, candidates)
  return if output_string.nil?
  return if candidates.nil?
  candidates.each do |d|
    dd_string = "* Double dipper: #{d}"
    if output_string.include? dd_string then
      print "."
    else
      puts "\nDid not find #{d} in output (searched for #{dd_string})"
    end
  end
  puts " candidate check complete"
end

puts "======================================="
puts "CHECKING RESULTS AGAINST WHAT WE EXPECT"
puts "======================================="
puts "We should have 29 double dippers:"
dd_candidates = [ "Abarval#2124", "ChaboDennis#2598", "chpatro#2321", "Cosmo#2546", "Daugron#2835",
  "DevilMat#21846", "DrEddy#2380", "eg99#2317", "goodwill#21810", "gtapack#2770", "Kapucha#21492",
  "Kemba#2115", "Memory#2171", "Mikel#22328", "Naru41#1699", "Sindo#21453", "TmwKOxyd#2380",
  "Yocto94#2937", "Zavada#2273", "znp#2294", ]

puts "Checking for players who are winning in both tournaments"
check_candidates(@output, dd_candidates)

dd_candidates = [ "Hansil#3471", "Janetzky#2644", "LostHead#2546", "Reliquary#2115", "Rellow#21696",
  "TechnoGoose#2886", "TheRabbin#2401", "Ynek972#2331", "Zehirmann#2834", ]

puts "Checking for players who already lost in the newest tournament"
check_candidates(@output, dd_candidates)
