/* jenner-check autoexec for t004_hw14_merge_celsius */
/* cap input rows for the captured run */
options obs=100;

/* Housekeeping carried over from DSmith_HW14_prog.sas */
title;
footnote;
ods noproctitle;

/* HW14 merges three permanent datasets from an external SAS Studio library
   (july21_edit, july22, elevation) that are not shipped in the repo. This
   autoexec rebuilds equivalent WORK datasets in the shapes HW14 consumes and
   points mylib at WORK:
     - mylib.july21_edit : STATION NAME DATE PRCP TMAX TMIN TChange
                           (the edited form HW12 produced)
     - mylib.july22      : STATION NAME DATE AWND PRCP TAVG TMAX TMIN
     - mylib.elevation   : STATION ELEVATION (typed numeric)
   Rows are arranged so College Station and Waco appear in all three with
   shared calendar days, exercising the 'Both' merge branch (array-driven
   Fahrenheit-to-Celsius conversion) and the elevation join in HW14. */
libname mylib (work);

data mylib.july21_edit;
  length STATION $12 NAME $51;
  infile datalines dsd dlm='|' truncover;
  input STATION $ NAME :$51. DATE :date9. PRCP TMAX TMIN TChange;
  format DATE date9.;
datalines;
USW00003904|College Station Easterwood Field|12Jul2021|0.00|95|77|18
USW00013904|Waco Regional Airport|12Jul2021|0.00|101|78|23
USW00023047|Amarillo Rick Husband Intl Airport|12Jul2021|0.10|90|64|26
;
run;

data mylib.july22;
  length STATION $12 NAME $58;
  infile datalines dsd dlm='|' truncover;
  input STATION $ NAME :$58. DATE :date9. AWND PRCP TAVG TMAX TMIN;
  format DATE date9.;
datalines;
USW00003904|COLLEGE STATION EASTERWOOD FIELD, TX US|12Jul2022|6.1|0.00|88|107|73
USW00013904|WACO REGIONAL AIRPORT, TX US|12Jul2022|7.4|0.00|91|108|82
USW00012960|HOUSTON WILLIAM P HOBBY AIRPORT, TX US|12Jul2022|8.0|0.20|89|99|79
;
run;

data mylib.elevation;
  length STATION $12;
  infile datalines dsd dlm='|' truncover;
  input STATION $ ELEVATION;
datalines;
USW00003904|96
USW00013904|470
;
run;
