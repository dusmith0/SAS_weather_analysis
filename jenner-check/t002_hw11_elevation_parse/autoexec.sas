/* jenner-check autoexec for t002_hw11_elevation_parse */
/* cap input rows for the captured run */
options obs=100;

/* Housekeeping carried over from DSmith_HW11_prog.sas */
title;
footnote;
ods noproctitle;

/* HW11 reads mylib.elevation, an imported CSV whose columns all arrive as
   character (the author notes lengths 1, 12, 7, 11, 12, 30, 13). That
   library lives at an external SAS Studio path not shipped in the repo, so
   this autoexec builds an equivalent all-character WORK.elevation sample and
   points mylib at WORK. The station identifiers follow the GHCN pattern the
   program depends on: a 3-char network prefix (e.g. USW) + an 8-char code. */
libname mylib (work);

data mylib.elevation;
  length AWND $1 STATION $12 ELEVATION $7 LATITUDE $11 LONGITUDE $12 NAME $30 DATE $13;
  infile datalines dsd truncover;
  input AWND $ STATION $ ELEVATION $ LATITUDE $ LONGITUDE $ NAME :$30. DATE $;
datalines;
,USW00013959,105.0,30.7469440,-95.5872220,HUNTSVILLE MUNICIPAL AIRP TX US,01/01/2022
,USW00013966,309.0,33.9782000,-98.4934000,WICHITA FALLS MUNI AP TX US,01/01/2022
,USW00003902,309.0,31.0672000,-97.8288000,ROBERT GRAY AAF TX US,01/01/2022
,USW00012923,2.0,29.3000000,-94.8039000,GALVESTON SCHOLES FIELD TX US,01/01/2022
,USW00023034,1655.0,31.8331000,-104.8092000,PINE SPRINGS GUADALUPE TX US,01/01/2022
,USW00003904,320.0,30.5883000,-96.3653000,COLLEGE STATION EASTER TX US,01/01/2022
,USC00411048,351.0,30.1665000,-96.4030000,BRENHAM TX US,01/01/2022
,USW00013904,470.0,31.6119000,-97.2278000,WACO REGIONAL AIRPORT TX US,01/01/2022
;
run;
