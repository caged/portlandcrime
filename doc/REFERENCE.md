# Conversions
ogr2ogr -f "GeoJSON"  -s_srs "+proj=lcc +lat_1=44.33333333333334 +lat_2=46 +lat_0=43.66666666666666 +lon_0=-120.5 +x_0=2500000 +y_0=0 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs" -t_srs "WGS84" nhgeo.json PortlandNeighborhoods\\Neighborhoods_pdx.shp

# Start Mongo on Linode
sudo /etc/init.d/mongno start