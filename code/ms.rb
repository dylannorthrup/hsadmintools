#!/usr/bin/ruby -w
#
# Show Match Status

# Read in utility methods and list of tournaments for current season
$: << "/home/docxstudios/web/hs/code"
# Set debug and alternate form_url if we're running the debug version
if $0.match(/ms.rb$/) then
  require "hsm"
  @DEBUG = true 
  @form_url = "https://doc-x.net/hs/ms.html"
else
  require "hs_methods"
end
require "tournament_urls"

@form_url = "https://doc-x.net/hs/match_status.html"
@out_dir = "/home/docxstudios/web/hs/snapshots"
@tournament_type='swiss'  # Other option is 'single_elim'

@cgi = CGI.new
params = @cgi.params

# Check to see if we've got 
if params.empty? then
  bail_and_redirect(target=@form_url)
end
if params['bracket_id'].nil?
  bail_and_redirect(target=@form_url)
end

@active_round = 0
@output = ""

@refresh = true
unless params['refresh'][0].nil? then
  if params['refresh'][0] == "false" then
    @refresh = false
  end
end

@snapshot = false
unless params['snapshot'][0].nil? then
  if params['snapshot'][0] == "true" then
    @snapshot = true
  end
end

unless @snapshot then
  @output.concat("Content-type: text/html; charset=UTF-8\n")
  @output.concat("\n")
end
@output.concat("<html>\n")
@output.concat("<head>\n")
if @refresh then
  @output.concat("<meta http-equiv='refresh' content='60'>\n")
end
if @snapshot then
  @output.concat("<meta charset=UTF-8 />\n")
end
@output.concat("<title>Match status</title>\n")
@output.concat("</head>\n")
@output.concat("<body>\n")

# Populate @tourney_hash and @bracket_id global vars
validate_and_set_bracket_id_and_tourney_hash(params['bracket_id'][0])

data_json = get_active_round_json_data(@tourney_hash)

tourney_id = ''
begin
  tourney_id = data_json[0]['top']['team']['tournamentID']
rescue
  @output.concat("Ran into issue with tourney_id\n")
end
begin
  pdebug("Updating Bracket Tracker")
  update_bracket_tracker(b_id=@bracket_id, t_id=tourney_id)
rescue
  @output.concat("Ran into issue with updating bracket_tracker(#{@bracket_id}, #{tourney_id})\n")
end

data_json.each do |f|
  if @tournament_type == 'swiss'
    print_swiss_match(f)
  else
    print_single_elim_match(f)
  end
end

@output.concat("</ul>\n")
@output.concat("</body>\n")
@output.concat("</html>\n")

if @snapshot then
  now = Time.now.utc.to_s
  now.gsub!(/ UTC$/, '')
  now.gsub!(/^.* /, '')
  now.gsub!(/:/, '')
  fname = "#{@bracket_id}-round#{@active_round}-#{now}.html"
  fqfn = "#{@out_dir}/#{fname}"
  url = "/hs/snapshots/#{fname}"
  #fout = File.write(fqfn, @output)
  File.open(fqfn, 'w') { |file| file.write(@output) }
  puts "Content-type: text/html; charset=UTF-8"
  puts ""
  puts "<html>"
  puts "<head>"
  puts "<title>Match status Snapshot Taken</title>"
  puts "</head>"
  puts "<body>"
  puts "<h1>Match status Snapshot Taken</h1>"
  puts "You can access it <a href='#{url}'>https://doc-x.net#{url}</a>"
  puts "</body>"
  puts "</html>"
else
  puts @output
end
