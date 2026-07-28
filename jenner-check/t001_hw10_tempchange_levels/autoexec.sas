/* jenner-check autoexec for t001_hw10_tempchange_levels */
/* cap input rows for the captured run */
options obs=100;

/* Housekeeping carried over from DSmith_HW10_prog.sas */
title;
footnote;
ods noproctitle;

/* The upstream program reads mylib.july22 from an external SAS Studio
   library ("/home/u63307645/STAT_604_Folder/mylib"). That library is not
   part of the repository, so this autoexec builds a small WORK.july22
   dataset with the same columns and a few realistic Texas station rows,
   and points the mylib libref at WORK so the program runs unchanged. */
libname mylib (work);

data mylib.july22;
  length STATION $12 NAME $58;
  infile datalines dsd truncover;
  input STATION $ NAME :$58. DATE :date9. AWND PRCP TAVG TMAX TMIN;
  format DATE date9.;
datalines;
USW00012960,HOUSTON WILLIAM P HOBBY AIRPORT TX US,01Jul2022,7.4,0.00,89,101,78
USW00012960,HOUSTON WILLIAM P HOBBY AIRPORT TX US,02Jul2022,6.9,0.12,86,96,77
USW00013904,WACO REGIONAL AIRPORT TX US,01Jul2022,8.1,0.00,90,103,74
USW00013904,WACO REGIONAL AIRPORT TX US,02Jul2022,9.0,0.00,91,105,72
USW00013904,WACO REGIONAL AIRPORT TX US,19Jul2022,10.3,0.00,93,108,82
USW00003904,COLLEGE STATION EASTERWOOD FIELD TX US,01Jul2022,5.5,0.05,84,95,73
USW00003904,COLLEGE STATION EASTERWOOD FIELD TX US,19Jul2022,6.1,0.00,88,99,73
USW00023047,AMARILLO RICK HUSBAND INTL AIRPORT TX US,01Jul2022,12.2,0.00,79,94,61
USW00023047,AMARILLO RICK HUSBAND INTL AIRPORT TX US,19Jul2022,11.8,0.21,77,90,64
USW00012917,PORT ARTHUR JEFFERSON COUNTY AIRPORT TX US,01Jul2022,8.9,0.34,85,93,79
USC00411048,BRENHAM TX US,01Jul2022,.,0.00,.,.,.
USW00012919,BROWNSVILLE SOUTH PADRE ISLAND TX US,19Jul2022,9.6,0.00,88,96,80
;
run;
