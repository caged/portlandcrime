require 'pathname'
require 'pp'
require 'csv'
require 'name_map'

namespace :crime do
  namespace :reports do
    desc 'Run Crime Totals For last year & this year'
    task :crime_totals => :environment do
      [(Time.now - 1.year).year, Time.now.year].each do |year|
        start = Time.parse("01/01/#{year}")
        Crime.weekly_totals_between(start, start.end_of_year)
        puts "[#{Time.zone.now}] Calculated #{year} weekly crime totals"
        
        Crime.monthly_totals_between(start, start.end_of_year)
        puts "[#{Time.zone.now}] Calculated #{year} monthly crime totals"
      end
    end
  
    desc 'Run YTD Offense Summaries'
    task :ytd_offense_summaries => :environment do
      Offense.summaries_for_the_past(Time.zone.now.yday.days)
      puts "[#{Time.zone.now}] Calculated offenses summaries"
    end
  
    desc 'Run Neighborhood Crime Stats'
    task :neighborhood_offense_totals => :environment do
      # Crimes trickle in over a course of two weeks, making up to the day reporting slighly inaccurate 
      # when making historical comparisons, so we trim off two weeks to account for this volatility
      threshold = Time.now.yday > 14 ? 2.weeks : 0.days
      Neighborhood.offense_totals_between(Time.now.beginning_of_year, Time.now - threshold)
      Neighborhood.offense_totals_between(Time.now.beginning_of_year - 1.year, (Time.now - threshold) - 1.year)
      puts "[#{Time.zone.now}] Calculated neighborhood statistics"
    end
  end
end