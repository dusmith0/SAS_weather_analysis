/***********************************************************************************/
/* Program Name: DSmith_HW12_prog.sas                                              */
/* Date Created: 4/8/2023                                                          */
/* Author: Dustin Smith                                                            */
/* Purpose: To complete Homework 12 of stats 604. It seems that we will be creating 
			a new format. 						                                   */
/*                                                                                 */
/* Inputs: July 21 sas file at /home/u63307645/STAT_604_Folder/mylib
   Outputs: DSmith_HW12_output.pdf at /home/u63307645/STAT_604_Folder/STAT_604_Howework/DSmith_HW12_output.pdf					                                                   */
/*                                                                                 */
/* 																	 			   */
/***********************************************************************************/

/*1 Housekeeping*/
title;
footnote;
ods noproctitle;

/*Assigning Filerefs and librefs*/
libname mylib "/home/u63307645/STAT_604_Folder/mylib";
filename output "/home/u63307645/STAT_604_Folder/STAT_604_Howework/DSmith_HW12_output.pdf";

ods pdf file=output;

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
	
/*10 Display the objects in mylib without the descriptor portion*/
title1 "Contents of Mylib Library:";

proc contents date=mylib._ALL_ nods;
run;

title2 "July21 edited file";
title3 "Sorted by Name and Date";
proc contents data=mylib.july21_edit;
run;

title2 "Work.byTMAX";
title3 "Sorted by Max Temp.";
proc contents data=work.byTMAX;
run;

/*Close the ods file*/
ods pdf output close;


/* Questions  
A)  College Station contained only 'LOW' temperature differences. Whereas Waco had 4 Normal days in temperature change and 
	2 days with minimal temperature change. 
	
B) The difference was 4.46-4.01 or .45 in precipitation. 

C) There is also a Formats in the Member Type of Catalog. That is because we created a Format and placed it into the mylib library. 
	(However, I seemed to have more success placing the format in the Work Library.
	
D) The highest temperature was 111 on Sunday, July 25, 2021 at Rio Grande Village.

E) As eight of the top 10 hottest days are at Rio Grande Village, I would guess that is the hottest city in Texas.

F) There is a new box with SORT information. It includes SORTBY, Validated, and Character Set*/