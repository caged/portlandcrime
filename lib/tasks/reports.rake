require 'pathname'
require 'pp'
require 'csv'
require 'name_map'

namespace :crime do
  namespace :reports do
    desc 'Run Weekly Crime Totals For last year & this year'
    task :weekly_crime_totals => :environment do
      [(Time.now - 1.year).year, Time.now.year].each do |year|
        start = Time.parse("01/01/#{year}")
        Crime.weekly_totals_between(start, start.end_of_year)
        puts "[#{Time.zone.now}] Calculated #{year} weekly crime totals"
      end
    end
  
    desc 'Run YTD Offense Summaries'
    task :ytd_offense_summaries => :environment do
      Offense.summaries_for_the_past(Time.now.beginning_of_year.to_i)
      puts "[#{Time.zone.now}] Calculated offenses summaries"
    end
  
    desc 'Run Neighborhood Crime Stats'
    task :neighborhood_offense_totals => :environment do
      # Crimes trickle in over a course of two weeks, making up to the day reporting slighly inaccurate 
      # when making historical comparisons, so we trim off two weeks to account for this volatility
      Neighborhood.offense_totals_between(Time.now.beginning_of_year, Time.now - 2.weeks)
      Neighborhood.offense_totals_between(Time.now.beginning_of_year - 1.year, (Time.now - 2.weeks) - 1.year)
    end
  end
end