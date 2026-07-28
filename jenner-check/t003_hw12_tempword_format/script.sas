/* Adapted from DSmith_HW12_prog.sas (Dustin Smith, STAT 604 HW12).       */
/* Purpose (author's): create a custom format. PROC FORMAT defines the      */
/* tempword ranges, a DATA step cleans station NAMEs with PROPCASE/SUBSTR    */
/* and derives a daily temperature change, and two labeled PROC PRINT        */
/* reports apply the format and summarise precipitation. That logic is        */
/* unchanged; only the external fileref / ODS-PDF plumbing moved to           */
/* autoexec.sas so the reports render to the default listing.                */

/*4 Create a permanent Format*/
proc format; /*Works better without the mylib reference*/
	value tempword
		33<-HIGH = 'Extreme'
		28<-33 = 'High'
		22<-28 = 'Normal'
		10-22 = 'Low'
		LOW-<10 = 'Minimal'
		OTHER = 'N/A';
run;

/*5 Create a new data set from the July 2021 data*/
data mylib.july21_edit;
	set mylib.july21(rename=(NAME=dropname));
	drop TAVG dropname;
	length NAME $51;
	NAME = propcase(trim(substr(dropname,1,length(dropname)-7)));
	TChange = (TMAX - TMIN);
	label TChange='Daily Change';
run;

/*6 Sort the data by Name and then by date*/
proc sort data=mylib.july21_edit;
	by NAME DATE;
run;


/*7 Use the Proc Print to print a matched report to the Assignment*/
Options NOFMTERR; /*I do not think that I needed this?? My format seemed to work without it as well.*/

title1 "College Station and Waco Rainfall";
title2 "July 2021";

proc print data=mylib.july21_edit label noobs;
	where Name='College Station Easterwood Field' or NAME='Waco Regional Airport';
	by STATION NAME;
	ID STATION NAME;
	var DATE PRCP TChange;
	label STATION='Station' NAME='Name' DATE='Date' PRCP='Precipitation';
	format TChange tempword.;
	sum PRCP;
run;

/*8 Create a reoredered TMAX data set.*/
proc sort data=mylib.july21_edit out=byTMAX;
	by descending TMAX;
run;

/*9 Create a report of the hottest 10 days in July 2021*/
title1 "HOT HOT HOT";
title2 "July 2021";

proc print data=work.byTMAX (obs=10) noobs label;
	Var STATION NAME DATE TMAX;
	label TMAX='High Temp' STATION='Station' NAME='Name' DATE='Date';
	format DATE weekdate32.;
run;
