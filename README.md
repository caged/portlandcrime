## Overview
PortlandCrime is an experiment in crime mapping for Portland, OR.  You can see it live at http://portlandcrime.com or http://pdxcrime.com.

## Setup
Requires Ruby 1.9.2 and MongoDb

1. **Create DB & load offenses:** `rake db:seed`
2. **Import crime:** `rake crime:import`.  This will import the current year, providing `YEAR=2009 rake crime:import`.  
   You should at least import this year and last year.
3. **Run reports:**
    
        rake crime:reports:neighborhood_offense_totals  # Run Neighborhood Crime Stats
        rake crime:reports:weekly_crime_totals          # Run Weekly Crime Totals For last year & this year
        rake crime:reports:ytd_offense_summaries        # Run YTD Offense Summaries
4. **Import trimet stops and routes**:

        rake trimet:import:routes  # Import Trimet Bus, Max, and Streetcar Routes
        rake trimet:import:stops   # Import Trimet Bus, Max, and Streetcar Stops
5. (And I apologize for this) **Run Migration to import Neighborhood geo data and normalize names:**

        rake migrations:one_normalize_neighborhood_names
        rake migrations:four_flag_non_portland_neighborhoods
        
6. Get a CloudMade API key: http://cloudmade.com/register.  Add it to line 20 of public/javascripts/map.js.


## Deploying
I run portlandcrime.com on Linode (http://linode.com) and deploy with capistrano. Here is a sample of the 
configuration I'm using: https://gist.github.com/d683cb464874f4ab33ee.

Assets use Jammit (http://documentcloud.github.com/jammit) which is great for compression.

Check out config/schedule.rb for a sweet ruby DSL to cron that run reports.

The library that generates visualizations is pretty hefty, so it's a VERY good idea to precache assets with Jammit and 
use Nginx's gzip_static module. It's the single best thing you can do to increase page load times.

## Demographics
There are neighborhood demographics in db/data/neighborhood-demographics.csv and supporting models for those demographics, however, 
I found them to be outdated and questionable so I chose not to use them.  I've asked the city about updating these statistics and was 
informed that they haven't received budget approval for such a project, but they gave me the census block data they used to correlate neighborhoods to census blocks.
I hope I can use this data to upgrade neighborhood demographics for the new American Community Survey.

If you want to import demographics anyway, run `rake migrations:three_import_neighborhood_demographics`
