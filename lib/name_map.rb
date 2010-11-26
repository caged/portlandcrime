# Looks like Portland Police respond to incidents in surrounding areas.  We're importing
# these crimes now, but I'm eventually going to remove them because they don't reflect accurate 
# totals, only the crimes PDX police responded to.
if !defined?(NON_PDX_NHOODS)
  NON_PDX_NHOODS = [
    "GREENWAY",
    "GRESHAM - CENTENNIAL EAST",
    "GRESHAM - DOWNTOWN",
    "GRESHAM - GRESHAM BUTTE",
    "GRESHAM - HOLLYBROOK",
    "GRESHAM - KELLY CREEK",
    "GRESHAM - MT. HOOD",
    "GRESHAM - NORTH CENTRAL",
    "GRESHAM - NORTH GRESHAM",
    "GRESHAM - NORTHWEST GRESH",
    "GRESHAM - NORTHEAST GRESH",
    "GRESHAM - POWELL VALLEY",
    "GRESHAM - ROCKWOOD GROUP",
    "GRESHAM - SOUTHWEST GRESH",
    "GRESHAM - WILKES EAST",
    "BEAVERTON - FIVE OAKS",
    "BEAVERTON - WEST SLOPE",
    "BEAVERTON SEXTON MTN",
    "CENTRAL BEAVERTON",
    "RALEIGH WEST"
  ]
end

# Maps neighborhood names in crime dataset with neighborhood names in the 
# neighborhoods dataset containing the geo data.
if !defined?(PDX_NHOODS_NAME_MAP)
  PDX_NHOODS_NAME_MAP = {
    "ARDENWALD" => "ARDENWALD-JOHNSON CREEK",
    "ARLINGTON HGHTS" => "ARLINGTON HEIGHTS",
    "BEAUMONT-WILSHR" => "BEAUMONT-WILSHIRE",
    "BRENTWD-DARLNGT" => "BRENTWOOD-DARLINGTON",
    "BROOKLYN" => "BROOKLYN ACTION CORPS",
    "BUCKMAN-EAST" => "BUCKMAN",
    "BUCKMAN-WEST" => "BUCKMAN",
    "CHINA/OLD TOWN" => "OLD TOWN/CHINATOWN",
    "CRSTN-KENILWTH" => "CRESTON-KENILWORTH",
    "E COLUMBIA" => "EAST COLUMBIA",
    "HEALY HEIGHTS" => "HEALY HEIGHTS/SOUTHWEST HILLS",
    "HIGHLAND" => "", # SYLVAN-HIGHLANDS?
    "HOSFRD-ABRNETHY" => "HOSFORD-ABERNETHY",
    "LKOS - MOUNTAIN PARK" => "",
    "LLOYD" => "LLOYD DISTRICT",
    "MT SCOTT-ARLETA" => "MT. SCOTT-ARLETA",
    "MT TABOR" => "MT. TABOR",
    "NORTHWEST" => "NORTHWEST DISTRICT",
    "NORTHWEST HTS" => "NORTHWEST HEIGHTS",
    "NORTHWEST IND" => "NORTHWEST DISTRICT/NORTHWEST INDUSTRIAL",
    "PARKROSE HGTS" => "PARKROSE HEIGHTS",
    "POWELHST-GILBRT" => "POWELLHURST-GILBERT",
    "S BURLINGAME" => "SOUTH BURLINGAME",
    "SELLWD-MORELAND" => "SELLWOOD-MORELAND IMPROVEMENT LEAGUE",
    "ST JOHNS" => "ST. JOHNS",
    "SULLIVANS GULCH" => "SULLIVAN'S GULCH",
    "SYLVAN-HIGHLNDS" => "SYLVAN-HIGHLANDS",
    "W PORTLAND PARK" => "WEST PORTLAND PARK"
  }
end

# Map some permalinks in the DB to the names in the 2000 census demographic file.
if !defined?(PDX_DEMOGRAPHICS_NAME_MAP)
  PDX_DEMOGRAPHICS_NAME_MAP = {
    'lloyd' => 'LLOYD DIST',
    'northwest-ind' => 'NORTHWEST INDUSTRIAL',
    'hosfrd-abrnethy' => 'HOSFORD-ABERNATHY',
    'sellwd-moreland' => 'SELLWOOD-MORELAND IMPROVEMENT LEAGUE',
    'crstn-kenilwth' => 'CRESTON-KENILWORTH',
    'beaumont-wilshr' => 'BEAUMONT-WILSHIRE',
    'brentwd-darlngt' => 'BRENTWOOD/DARLINGTON',
    'foster-powell' => 'FOSTER-POWELL',
    'sylvan-highlnds' => 'SYLVAN-HIGHLANDS',
    'mt-scott-arleta' => 'MT. SCOTT-ARLETA',
    'powelhst-gilbrt' => 'POWELLHURST-GILBERT',
    'healy-heights' => 'HEALY HEIGHTS'
  }
end