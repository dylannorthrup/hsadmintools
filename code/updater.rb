#!/usr/bin/env ruby
#
# This runs from cron to update tournament brackets and completion status

# Read in utility methods and list of tournaments for current season
$: << "/home/docxstudios/web/hs/code"
# If we're using the debug version, set debug and alternate form url
if $0.match(/ud.rb$/) then
  require "hsm"
  require 'pry'
  @DEBUG = true 
else
  require "hs_methods"
end

require "tournament_urls"

# Something to take a tournament_id and retrieve the bracket_id and,
# based on that, find out if the tournament has completed.
def get_bracket_for_tournament_id(tid=nil)
  return if tid.nil?
  bid = "Still working"
  dj = get_tournament_json(tid)
  bid = dj['stageIDs'].last
  pdebug "Returning #{bid}"
  return bid
end

# Now, something to find out if a bracket has completed
def get_bracket_completion_status(bid=nil)
  pdebug "get_bracket_completion_status(#{bid})"
  return if bid.nil?
  pdebug "Getting data for #{bid}"
  # Wrapping this in retry logic
  max_retries = 5
  begin
    retries ||= 0
    dj = get_active_round_json_data(bid, skip_match_status_stuff=true)
  rescue
    # retry five times
    pdebug "Failed to get active round JSON data #{retries} time(s). Retrying"
    retry if (retries += 1) < max_retries
    exit if retries >= max_retries
  end
  pdebug("Number of matches to check: #{dj.length}\n")
  # Now that we have the json data, check the matches to make sure they're
  # all completed
  dj.each do |m|
    if m['isComplete'].nil? then
      pdebug "isComplete was nil for match #{m['matchNumber']}. Returning false"
      return false
    end
    if m['isComplete'] == 'false' then
      pdebug "isComplete was false. Returning false"
      return false
    end
  end
  return true
end

# This is A QUICK HACK, but since this is a one off, Imma do it 
# for now. If we need to do this more later, we'll take this out
# of here and put it into `hs_methods.rb`

# Subclias CLIIO (Command Line Interface IO) from the standard IO
# class)
class CLIIO < IO
  # Make a class variable so we can refer to it in `concat`
  def initialize fh
    @fh = fh
  end

  # When you try to concat to this, invoke `write` instead and
  # write to the file handle
  def concat string
    @fh.write string
  end
end

# Set `@output` up as a new IO instance copying everything it needs
# from `$stdout`
@output = CLIIO.new $stdout

con = get_db_con
dbq = "SELECT tournament_id, bracket_id FROM tournament_list WHERE completed is FALSE ORDER BY tournament_order ASC"
results = con.query(dbq)
#if @DEBUG then
#  binding.pry
#end
if results.count == 0 then
#  puts "Did not get results from 'tournament_list' database. exiting"
  exit
end

no_bracket_limit = 3
no_bracket_results = 0
bracket_changed = false
completed_changed = false

# Got some results. Let's do some work
results.each do |row| 
  # Extract bits from SQL statement
  tid = row['tournament_id']
  bid = row['bracket_id']
  completed = row['completed']
  pdebug "tid: #{tid} - bid.nil?: '#{bid.nil?}' - completed.nil?: '#{completed.nil?}'"
  # If we don't have a bid in the DB, let's see if one's been created
  if bid.nil? then
    bracket_id = get_bracket_for_tournament_id(tid)
    # If we didn't get a bracket_id, then no bracket's been created for that tournament.
    # If we get three of these in a row, exit out as we've gone beyond what's been scheduled
    # so far.
    if bracket_id.nil? then
      no_bracket_results += 1
      pdebug "No bracket_id found for tournament id '#{tid}'. This is instance #{no_bracket_results}\n"
      if no_bracket_results >= no_bracket_limit then
        pdebug "Got more than three blank bracket_ids for tournaments. Exiting\n"
        exit
      end
      next
      pdebug "You should not see this"
    end
    pdebug "Got bracket_id of '#{bracket_id}'"
    bracket_changed = true
  else
    bracket_id = bid
  end

  # If we don't have a completed status in the DB, see if things are still in progress
  if completed.nil? then
    pdebug "Getting bracket completed status for #{bracket_id}"
    bracket_completed = get_bracket_completion_status(bracket_id)
    if bracket_completed == false then
      pdebug "Bracket ID '#{bracket_id}' is STILL IN PROGRESS"
    else
      @output.concat "Bracket ID '#{bracket_id}' is OVER AND DONE. Put it on the big board."
      completed_changed = true
    end
    pdebug "Is bracket completed? Survey says '#{bracket_completed}'"
  end

  # If we've found things have changed, update the DB based on that info
  if bracket_changed or completed_changed then
    @output.concat "Updating DB for tid '#{tid}'"
    q = 'UPDATE tournament_list set '
    if bracket_changed and completed_changed then
      q.concat("bracket_id = '#{bracket_id}', completed = TRUE")
    elsif bracket_changed then
      q.concat("bracket_id = '#{bracket_id}'")
    elsif completed_changed then
      q.concat("completed = TRUE")
    end
    q.concat(" WHERE tournament_id = '#{tid}'")
    @output.concat("Running this SQL: '#{q}'\n")
    con.query(q)
  else
    pdebug "Found what we needed in the database.\n"
  end

  completed_changed = false
end
