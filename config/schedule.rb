# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "/home/deploy/pdxcrime/shared/log/cron.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

every 1.day, :at => '4:00 am' do
   rake "crime:import"
end

every 1.day, :at => '4:30 am' do
   rake "crime:reports:crime_totals"
end

every 1.day, :at => '4:40 am' do
   rake "crime:reports:ytd_offense_summaries"
end

every 1.day, :at => '4:50 am' do
   rake "crime:reports:neighborhood_offense_totals"
end

every 15.days, :at => '5:00 am' do
   rake "crime:reports:historical_offense_counts"
end

# Learn more: http://github.com/javan/whenever
