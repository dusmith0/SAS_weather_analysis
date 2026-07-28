/* Adapted from DSmith_HW11_prog.sas (Dustin Smith, STAT 604 HW11).       */
/* Purpose (author's): use functions to edit data. The DATA step below      */
/* converts the all-character elevation import into a typed dataset, pulls   */
/* Station_Type / Station_Code out of the GHCN STATION id, and derives a Day */
/* offset with DATDIF. That transformation logic is unchanged; only the      */
/* external libref/fileref/ODS-PDF plumbing moved to autoexec.sas so the     */
/* program runs against the bundled WORK.elevation sample and reports to the  */
/* default listing.                                                          */

/*Macros GO HERE!!!*/
%let date =01Jan2022; /*I am not certain if SAS will like this date*/

/*5 Check contents to see if they are all type=character*/
proc contents data=mylib.elevation;
run;

/*6 Use the data step */
data mylib.Modified_Elevations;
	length NAME $58;
	set mylib.elevation(rename=(NAME=drop1 LATITUDE=drop2 LONGITUDE=drop3 ELEVATION=drop4 DATE=drop5));
	Drop AWND drop1-drop5;

	length Station_Type $3;     Station_Type = substr(STATION,1,3);
	length Station_Code $8;     Station_Code =substr(STATION,4,8);
	NAME = substr(drop1,1,length(drop1)-7);
	LATITUDE = input(drop2,11.);
	LONGITUDE = input(drop3,12.);
	ELEVATION = input(drop4,7.);
	DATE = input(drop5,anydtdte19.);
	Day = datdif("&date"d,DATE,'ACT/ACT')+1;  /****Alternate method*** Day = DATE - "&date"d + 1; */
	format DATE mmddyy10. ELEVATION comma12.;
run;


/*7) Show the Contents of the new Data Set*/
title1 "Modified Elevations Data";
title2 "Descriptor Portion";

Proc contents data=mylib.Modified_Elevations;
run;

/*8 Create a report for the USW type where elevation is between 100 and 375*/
title1 "Modified Elevations Data";
title2 "USW Stations with Mid-ranged Elevations";

proc print data=mylib.Modified_Elevations;
	where Station_Type="USW" and 100 <= ELEVATION <= 375;
run;
