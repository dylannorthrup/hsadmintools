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

@my_url = "https://doc-x.net/hs/view_banlist.rb"
@cgi = CGI.new
params = @cgi.params

# We should not have parameters
unless params.empty? then
  bail_and_redirect(target=@form_url)
end

puts "Content-type: text/html; charset=UTF-8\n\n"
puts "<html>
<head>
<meta http-equiv='expires' content='10'>
<meta http-equiv='refresh' content='10'>
<title>View Hearthstone Banlist</title>
</head>
<body>
<h1>Current Hearthstone Banlist</h1>"
puts "Data retrieved at " + Time.now.inspect + "<P>\n<hr>"

dbcon = get_db_con
query="SELECT battletag, notes FROM banlist WHERE active=1"
pdebug query
results = dbcon.query(query)

if results.count == 0 
  puts "No banned folks on the banlist. OUR PLAYERS ARE SO AWESOME!!!!!\n</body>\n</html>"
  exit
end

puts "Currently active players on the banlist..."
puts "<table border=1><tr><th>Battletag</th><th>Notes</th></tr>"
results.each do |row|
  puts "<tr><td valign=top>#{row['battletag']}</td><td>#{row['notes']}</tr>"
end
  
puts "</table>
<p>
<hr>
<p>
If you want to modify the results of this output, visit the <a href='/hs/update_banlist.html'>Update Banlist</a> page.
</body>
</html>"

