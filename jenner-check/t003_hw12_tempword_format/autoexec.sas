/* jenner-check autoexec for t003_hw12_tempword_format */
/* cap input rows for the captured run */
options obs=100;

/* Housekeeping carried over from DSmith_HW12_prog.sas */
title;
footnote;
ods noproctitle;

/* HW12 reads mylib.july21 from an external SAS Studio path not shipped in
   the repo. This autoexec builds an equivalent WORK.july21 sample with the
   same columns (STATION NAME DATE AWND PRCP TAVG TMAX TMIN) and points mylib
   at WORK. Station NAMEs carry the trailing ", TX US" the program's
   SUBSTR(...,1,LENGTH-7) trim expects, so the College Station and Waco rows
   the report filters on survive the PROPCASE clean-up unchanged. */
libname mylib (work);

data mylib.july21;
  length STATION $12 NAME $58;
  infile datalines dsd dlm='|' truncover;
  input STATION $ NAME :$58. DATE :date9. AWND PRCP TAVG TMAX TMIN;
  format DATE date9.;
datalines;
USW00003904|COLLEGE STATION EASTERWOOD FIELD, TX US|01Jul2021|5.1|0.10|84|95|79
USW00003904|COLLEGE STATION EASTERWOOD FIELD, TX US|02Jul2021|4.8|0.55|83|93|78
USW00003904|COLLEGE STATION EASTERWOOD FIELD, TX US|03Jul2021|5.6|1.20|82|92|77
USW00013904|WACO REGIONAL AIRPORT, TX US|01Jul2021|6.2|0.00|89|101|74
USW00013904|WACO REGIONAL AIRPORT, TX US|02Jul2021|7.0|2.10|88|100|72
USW00013904|WACO REGIONAL AIRPORT, TX US|03Jul2021|6.5|1.91|90|104|81
USW00013904|WACO REGIONAL AIRPORT, TX US|25Jul2021|9.9|0.00|95|111|80
USW00023044|RIO GRANDE VILLAGE, TX US|25Jul2021|10.2|0.00|96|111|79
USW00023044|RIO GRANDE VILLAGE, TX US|26Jul2021|10.0|0.00|95|110|78
USW00023047|AMARILLO RICK HUSBAND INTL AIRPORT, TX US|01Jul2021|12.1|0.00|78|90|60
;
run;
