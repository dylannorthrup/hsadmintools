#!/usr/bin/env ruby
#
#

require 'open-uri'
require 'json'
require 'cgi'

@cgi = CGI.new
params = @cgi.params

@tournament_hash = {
  '5c5b676c2f17380333cc85ef' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-154/5c5b676c2f17380333cc85ef/stage',
  '5c5b67e3f108a9031f9448e6' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-155/5c5b67e3f108a9031f9448e6/stage',
  '5c5b683fd34ae00315bea62f' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-156/5c5b683fd34ae00315bea62f/stage',
  '5c5b9bc26fe9d8033f7a3fe8' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-157/5c5b9bc26fe9d8033f7a3fe8/stage',
  '5c5b9c429da427034e3c7b70' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-158/5c5b9c429da427034e3c7b70/stage',
  '5c5cb449c9650a032bda54eb' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-159/5c5cb449c9650a032bda54eb/stage',
  '5c5b68a37cbf84033512aabe' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-160/5c5b68a37cbf84033512aabe/stage',
  '5c5b68eaf624fd03151db034' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-161/5c5b68eaf624fd03151db034/stage',
  '5c5b6925a3cb0903139d9616' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-162/5c5b6925a3cb0903139d9616/stage',
  '5c5b9c89d44d0d035ab5c6db' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-163/5c5b9c89d44d0d035ab5c6db/stage',
  '5c5cb4864bdb99031b712939' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-164/5c5cb4864bdb99031b712939/stage',
  '5c5cb4acd34ae00315beaa42' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-165/5c5cb4acd34ae00315beaa42/stage',
  '5c5b69d9db928b0321786787' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-166/5c5b69d9db928b0321786787/stage',
  '5c5b6a207a127c031368c7b7' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-167/5c5b6a207a127c031368c7b7/stage',
  '5c5b6a757cbf84033512aae1' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-168/5c5b6a757cbf84033512aae1/stage',
  '5c5b9ce15296690326cef556' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-169/5c5b9ce15296690326cef556/stage',
  '5c5b9d2bac7061031b746aa3' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-170/5c5b9d2bac7061031b746aa3/stage',
  '5c5cb54feb1652034cc1fc50' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-171/5c5cb54feb1652034cc1fc50/stage',
  '5c5b6ac3a3cb0903139d9623' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-172/5c5b6ac3a3cb0903139d9623/stage',
  '5c5b6b52ba4be5032b3c8a81' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-173/5c5b6b52ba4be5032b3c8a81/stage',
  '5c5b6b91796e74032103ff87' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-174/5c5b6b91796e74032103ff87/stage',
  '5c5b9dcdaacfad033f890de7' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-175/5c5b9dcdaacfad033f890de7/stage',
  '5c5cb5c1ac7061031b74720f' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-176/5c5cb5c1ac7061031b74720f/stage',
  '5c5cb71c77a7ba031914b3b4' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-177/5c5cb71c77a7ba031914b3b4/stage',
  '5c5b6bcb04a73703442fd1d6' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-178/5c5b6bcb04a73703442fd1d6/stage',
  '5c5b6d43f1ca60035865ccd1' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-179/5c5b6d43f1ca60035865ccd1/stage',
  '5c5b6d87909e3f03323ed38e' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-180/5c5b6d87909e3f03323ed38e/stage',
  '5c5b9f0e93e811033c7e260c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-181/5c5b9f0e93e811033c7e260c/stage',
  '5c5cb82cf4fc03033247cbbd' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-182/5c5cb82cf4fc03033247cbbd/stage',
  '5c5cb874f1ca60035865d32b' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-183/5c5cb874f1ca60035865d32b/stage',
  '5c5b6dbb16cf7f03530b0a58' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-184/5c5b6dbb16cf7f03530b0a58/stage',
  '5c5b6e50909e3f03323ed395' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-185/5c5b6e50909e3f03323ed395/stage',
  '5c5b6e7b16cf7f03530b0a5c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-186/5c5b6e7b16cf7f03530b0a5c/stage',
  '5c5b9f5eac7061031b746aac' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-187/5c5b9f5eac7061031b746aac/stage',
  '5c5b9fa30a224a033026868a' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-188/5c5b9fa30a224a033026868a/stage',
  '5c5cb913834360035022632c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-189/5c5cb913834360035022632c/stage',
  '5c5b6ebbd34ae00315bea64d' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-190/5c5b6ebbd34ae00315bea64d/stage',
  '5c5b6ef3f075df03265b5846' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-191/5c5b6ef3f075df03265b5846/stage',
  '5c5b6f55db928b03217867a1' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-192/5c5b6f55db928b03217867a1/stage',
  '5c5b9ffb0a224a033026868b' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-193/5c5b9ffb0a224a033026868b/stage',
  '5c5cb96aa51388033572888c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-194/5c5cb96aa51388033572888c/stage',
  '5c5cb9c493e811033c7e2ad8' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-195/5c5cb9c493e811033c7e2ad8/stage',
  '5c5b6f90f1ca60035865cce2' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-196/5c5b6f90f1ca60035865cce2/stage',
  '5c5b6fe3909e3f03323ed39d' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-197/5c5b6fe3909e3f03323ed39d/stage',
  '5c5b70231616670315082d3e' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-198/5c5b70231616670315082d3e/stage',
  '5c5ba15edb928b0321786840' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-199/5c5ba15edb928b0321786840/stage',
  '5c5ba358f4fc03033247c6b8' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-200/5c5ba358f4fc03033247c6b8/stage',
  '5c5cba0ca745ba0347ddcc7c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-201/5c5cba0ca745ba0347ddcc7c/stage',
  '5c5b7094f1ca60035865cd0e' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-202/5c5b7094f1ca60035865cd0e/stage',
  '5c5b712215433c0353bfcb53' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-203/5c5b712215433c0353bfcb53/stage',
  '5c5b717f1616670315082d44' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-204/5c5b717f1616670315082d44/stage',
  '5c5ba577f6edbb03220c78db' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-205/5c5ba577f6edbb03220c78db/stage',
  '5c5cbb70ac7061031b747279' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-206/5c5cbb70ac7061031b747279/stage',
  '5c5cbe552f17380333cc8b87' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-207/5c5cbe552f17380333cc8b87/stage',
  '5c5b71b3d34ae00315bea678' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-208/5c5b71b3d34ae00315bea678/stage',
  '5c5b71fa04a73703442fd1f1' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-209/5c5b71fa04a73703442fd1f1/stage',
  '5c5b7271be79570353ec1364' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-210/5c5b7271be79570353ec1364/stage',
  '5c5ba6267084a203203918ab' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-211/5c5ba6267084a203203918ab/stage',
  '5c5cbebe40219e033f3b736b' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-212/5c5cbebe40219e033f3b736b/stage',
  '5c5cbf45c076d10321f1ca17' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-213/5c5cbf45c076d10321f1ca17/stage',
  '5c5b72cfba4be5032b3c8abd' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-214/5c5b72cfba4be5032b3c8abd/stage',
  '5c5b745ff624fd03151db079' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-215/5c5b745ff624fd03151db079/stage',
  '5c5b74e640219e033f3b6f09' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-216/5c5b74e640219e033f3b6f09/stage',
  '5c5ba8fe7cbf84033512abbf' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-217/5c5ba8fe7cbf84033512abbf/stage',
  '5c5ba9d316cf7f03530b0aae' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-218/5c5ba9d316cf7f03530b0aae/stage',
  '5c5cbfb78d46e3033f206084' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-219/5c5cbfb78d46e3033f206084/stage',
  '5c5b7580f040e4034e55d05b' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-220/5c5b7580f040e4034e55d05b/stage',
  '5c5b762bc9650a032bda5147' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-221/5c5b762bc9650a032bda5147/stage',
  '5c5b765df4101d0346494223' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-222/5c5b765df4101d0346494223/stage',
  '5c5baf77ac7061031b746af3' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-223/5c5baf77ac7061031b746af3/stage',
  '5c5cbfe917152e0358b8fb7f' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-224/5c5cbfe917152e0358b8fb7f/stage',
  '5c5cc01b909e3f03323ed6b3' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-225/5c5cc01b909e3f03323ed6b3/stage',
  '5c5b769b8a2f2e0346fd20ea' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-226/5c5b769b8a2f2e0346fd20ea/stage',
  '5c5b76d8c4c83b03295363a4' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-227/5c5b76d8c4c83b03295363a4/stage',
  '5c5b773e984bf00319561849' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-228/5c5b773e984bf00319561849/stage',
  '5c5bafe342d6df034a91cc87' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-229/5c5bafe342d6df034a91cc87/stage',
  '5c5bb27842d6df034a91cc8d' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-230/5c5bb27842d6df034a91cc8d/stage',
  '5c5cc058a745ba0347ddccde' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-231/5c5cc058a745ba0347ddccde/stage',
  '5c5b780e7cbf84033512ab46' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-232/5c5b780e7cbf84033512ab46/stage',
  '5c5b786f15433c0353bfcb58' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-233/5c5b786f15433c0353bfcb58/stage',
  '5c5b78be0a224a0330268659' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-234/5c5b78be0a224a0330268659/stage',
  '5c5bb33feb1652034cc1fb19' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-235/5c5bb33feb1652034cc1fb19/stage',
  '5c5cc0c75ebb470313ae959c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-236/5c5cc0c75ebb470313ae959c/stage',
  '5c5cc12bf4e93b0333ca1c9d' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-237/5c5cc12bf4e93b0333ca1c9d/stage',
  '5c5b7903db928b03217867de' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-238/5c5b7903db928b03217867de/stage',
  '5c5b7944f075df03265b58d3' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-239/5c5b7944f075df03265b58d3/stage',
  '5c5b79b816cf7f03530b0a8f' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-las-vegas-240/5c5b79b816cf7f03530b0a8f/stage',
}

def bail_and_redirect()
  target_url = 'http://doc-x.net/hs/match_status.html'
  @cgi.out( "status" => "REDIRECT", "Location" => target_url, "type" => "text/html") {
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
  puts "<pre>"
  puts "Provided bracket ID (#{bid}) did not match pattern. Hit the back button and try again."
  puts "</pre>"
#  exit
end

if params.empty? then
  bail_and_redirect
end
if params['bracket_id'].nil?
  bail_and_redirect
end

puts "Content-type: text/html"
puts ""
puts "<html>"
puts "<head>"
puts "<meta http-equiv='refresh' content='60'>"
puts "<title>Match status</title>"
puts "</head>"
puts "<body>"

bracket_id = params['bracket_id'][0]

if bracket_id.nil? then
  puts "<pre>"
  puts "Something weird happened. Try refreshing your browser. Or yell at Dylan"
  puts "DEBUG: '#{bracket_id}'"
  puts "</pre>"
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
      puts "<h1> Ongoing Round #{current_round} Matches</h1>"
      puts "Data last refreshed at <tt>#{Time.now.utc.to_s}</tt>"
      puts "<ul>"
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

def get_match_url(hash=nil, t_id=nil, m_id=nil)
  return if hash.nil?
  return if t_id.nil?
  return if m_id.nil?
  return "#{@tournament_hash[t_id]}/#{hash}/match/#{m_id}"
end

data_json = get_json_data(tourney_hash)

data_json.each do |f|
  # If the match is not complete, print that out
  if not f['isComplete'] then
    tourney_id = f['top']['team']['tournamentID']
    match_url = get_match_url(hash=tourney_hash, t_id=tourney_id, m_id=f['_id'])
    puts "<li> <a href='#{match_url}' target='_blank'>Ongoing Match: #{f['matchNumber']} - #{print_user(f['top'])} vs #{print_user(f['bottom'])}</a>"
  else
    # Byes only have one user and are complete, so skip them
    next if f['isBye']
    # If the match is complete but one of the users is not ready, note that.
    if f['bottom']['readyAt'].nil? or f['top']['readyAt'].nil? then
      if f['bottom']['disqualified'] != true and f['top']['disqualified'] != true then
        tourney_id = f['top']['team']['tournamentID']
        match_url = get_match_url(hash=tourney_hash, t_id=tourney_id, m_id=f['_id'])
        puts "<li> <a href='#{match_url}' target='_blank'>Completd Match-User Not Ready: #{f['matchNumber']}  - #{print_user(f['top'])} vs #{print_user(f['bottom'])}</a>"
      end
    end
  end
end

puts "</ul>"
puts "</body>"
puts "</html>"


