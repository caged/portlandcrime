## Setup

Assets use Jammit (http://documentcloud.github.com/jammit).  If you can't get this in time you can 
set `package_assets: off` in config/assets.yml

rake db:seed - Loads the Offense names and descriptions
rake pp:import - Imports new crimes (probably around 59k on first import)