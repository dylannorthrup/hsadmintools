#!/usr/bin/env ruby
#
# This manages the folks on the banlist sql table. It can
# add them or deactivate them (though they are still present
# for tracking purposes).

# Read in utility methods 
$: << "/home/docxstudios/web/hs/code"
# Set debug and alternate form_url if we're running 
# the debug version
if $0.match(/ubl.rb$/) then
  require "hsm"
  @DEBUG = true 
  @form_url = "https://doc-x.net/hs/ubl.html"
else
  require "hs_methods"
  @form_url = "https://doc-x.net/hs/update_banlist.html"
end

@view_banlist_url = "https://doc-x.net/hs/view_banlist.rb"

@cgi = CGI.new
params = @cgi.params

# Check to see if we've got parameters
if params.empty? then
  bail_and_redirect(target=@form_url)
end
['password', 'battletag', 'banaction', 'judge'].each do |key|
  pdebug "Checking for #{key}"
  if params[key][0].nil? then
    pdebug("Did not get this key: '#{key}'. Redirecting.")
    bail_and_redirect(target=@form_url)
  else
    if key == 'password' then
      pdebug("Here's what we got for '#{key}': ItsASecretToEveryone ... #{params[key].nil?}")
    else
      pdebug("Here's what we got for '#{key}': #{params[key]} ... #{params[key].nil?}")
    end
  end
end

# Make these easily referenceable
password  = params['password'][0]
battletag = params['battletag'][0]
action    = params['banaction'][0]
judge     = params['judge'][0]
if params['notes'][0].nil?
  notes     = ""
else
  notes     = params['notes'][0]
end

def print_msg_and_exit(msg=nil)
  puts "#{msg}\n</body>\n</html>"
  exit
end

def print_error_and_exit(msg=nil)
  print_msg_and_exit(msg="#{msg}<p>\nIf you'd like to correct the issue and try again, <a href='javascript:history.back()'>click here</a> to do so.")
end

puts "Content-type: text/html; charset=utf-8

<html>\n<head>\n<title>Processing Banlist Update</title>\n</head>\n<body>\n<h1>Processing Banlist Update</h1>\n"

pw = File.open("/home/docxstudios/hs_banlist.pw").read.chomp
if password != pw
  print_error_and_exit(msg="The password entered was incorrect")
end

if invalid_battletag(battletag)
  print_error_and_exit(msg="The battletag provided, '#{battletag}', is invalid per <a href='https://us.battle.net/support/en/article/26963'>Blizzard's rules</a>")
end

if action !~ /^(ban|unban)$/
  print_error_and_exit(msg="Somehow we got an invalid action.")
end

if judge !~ /^\p{L}[\p{L} ]\p{L}+$/
  print_error_and_exit(msg="The judge name was not what I'd expect to see in Discord chat.")
end

# By the time we got here, we should have a battletag, an
# action, and the name of a judge. We might also have some
# notes.  The only other thing we need now a database 
# connection so we can persist this info!

dbcon = get_db_con

# First thing is to check to see if we already have a 
# row in the table for this battletag.

current_entry_query="SELECT id, battletag, notes, updated_by, active FROM banlist WHERE battletag LIKE '#{dbcon.escape(battletag)}'"

results = dbcon.query(current_entry_query)
# If we didn't get results, make sure we're banning, then
# do the ban...
if results.count == 0
  if action == 'unban'
    print_error_and_exit("The battletag '#{battletag}' was not in the database, so I cannot unban them.")
  end
  ban_query="INSERT INTO banlist (battletag, updated_by, notes, active) VALUES ('#{dbcon.escape(battletag)}', '#{dbcon.escape(judge)}', '#{Time.now}: #{dbcon.escape(notes)} -- ENTERED BY #{dbcon.escape(judge)}', True)"
  dbcon.query(ban_query)
  print_msg_and_exit(msg="Inserted '#{battletag}' into banlist.<p>\n<a href='#{@view_banlist_url}'>Click here</a> to view the current banlist.")
end

# If we did get results (or, rather, a result), grab 
# the info so we can proceed appropriately.
row = results.first
id = row['id']
old_notes = row['notes']
new_notes = dbcon.escape("#{old_notes}<br>\n===<br>\n#{Time.now}: #{notes} -- ENTERED BY #{judge}")
# Assume we're banning.
active_value = true
# And be happily proven wrong
if action == "unban"
  active_value = false
end

ban_query="UPDATE banlist SET notes='#{new_notes}', updated_by='#{dbcon.escape(judge)}', active=#{active_value} WHERE id=#{id}"
dbcon.query(ban_query)

print_msg_and_exit(msg="Updated entry for '#{battletag}' in banlist setting their ban status to #{active_value}.<p>\n<a href='#{@view_banlist_url}'>Click here</a> to view the current banlist.")
