/***********************************************************************************/
/* Program Name: DSmith_HW14_prog.sas                                              */
/* Date Created: 4/25/2023                                                          */
/* Author: Dustin Smith                                                            */
/* Purpose: To complete Homework 14 of stats 604.						                                   */
/*                                                                                 */
/* Inputs: July21_edit.sas 
		   elevation.sas 
		   july22.sas  all of which are found here "/home/u63307645/STAT_604_Folder/mylib"
   Outputs:DSmith_HW14_output.pdf located at "/home/u63307645/STAT_604_Folder/STAT_604_Howework/DSmith_HW14_output.pdf" */
/*            This will also create many temporary work sets: */
/*            			work.july21_edit, work.july22, work.elevation, work.noheight */
/*            There will be one permanent data set in mylib called hotheight.sas */
/*                                                                                 */
/* 																	 			   */
/***********************************************************************************/

title;
footnote;
ods noproctitle;

/*1-3) Creating file an library references*/
libname mylib "/home/u63307645/STAT_604_Folder/mylib";
filename output "/home/u63307645/STAT_604_Folder/STAT_604_Howework/DSmith_HW14_output.pdf";
ods pdf file=output;

/*4) Prepare the data sets for Merging.*/
	/*This creates temporary data sets to edit each set.*/
data work.july21_edit;
	set mylib.july21_edit;
	Day = day(DATE);
	drop DATE TChange;
run;

data work.july22;
	set mylib.july22(rename=(NAME=drop1));
	drop drop1 DATE AWND TAVG;
	length NAME $51;
	Day = day(DATE);
	NAME = propcase(substr(drop1,1,length(drop1)-7));
run;

data work.elevation(keep= STATION ELEVATION);
	set mylib.elevation;
run;

	/*This is to sort the data sets by STATION and Day*/
proc sort data=work.july21_edit;
	by STATION DAY;
run;

proc sort data=work.july22;
	by STATION DAY;
run;

proc sort data=work.elevation;
	by STATION;
run;

/*5 Begin the Merge*/
data work.julyheat;
	drop i;
	length Source $9;
	merge work.july21_edit(in=one rename=(PRCP=PRCP21 TMAX=TFMAX21 TMIN=TFMIN21))
		  work.july22(in=two rename=(PRCP=PRCP22 TMAX=TFMAX22 TMIN=TFMIN22));
	by STATION day;
	if one=1 and two=1 then do;
		Source = 'Both';
		Tchange=TFMAX22 - TFMAX21;
		array Fer{*} TFMAX21 TFMIN21 TFMAX22 TFMIN22;
		array Cel{*} TCMAX21 TCMIN21 TCMAX22 TCMIN22;
		do i=1 to dim(Cel);
			Cel{i}=int((Fer{i}-32)*(5/9));
		end;
	end;
	if one=1 and two=0 then
		Source = '2021 Only';
	if two=1 and one=0 then
		Source = '2022 Only';
	label Tchange="Difference in Yearly Max Temp(F).";
run;

/*6 Merge the pervious with the elevations */
data work.noheight(drop= elevation) mylib.hotheight;
	merge work.julyheat(IN=jh) work.elevation(In=el);
	by STATION;
	if el=0 then output work.noheight;
	else if el=1 and Source='Both' then output mylib.hotheight;
	label STATION="Station" NAME="Name" ELEVATION="Elevation";
run;

/*7 Display the descriptor portion of the work data steps*/
title "Work Library Descriptor Portion";
proc contents data=work._ALL_;
run;

/*8 Display the descriptor portion of the permanent data step*/
title "Temperature and Elevations of July21 and July22";
proc contents data=mylib.hotheight varnum;
run;
	
/*9 Print the July 2022 data that did not have an elevation */
title "July2022 data without Elevation";
proc print data=work.noheight noobs label;
 	where Source='2022 Only';
	var STATION NAME DAY TFMAX22 TCMAX22 TFMIN22 TCMIN22;
run;

/*10 Print the data from Waco or College Station*/
title1 "Temperature and Elevations of July21 and July22";
title2 "In Waco and College Station";
proc print data=mylib.hotheight noobs label;
	where name contains "Waco" or name contains "College";
	var STATION NAME ELEVATION DAY TFMAX22 TCMAX22 TFMIN22 TCMIN22 Tchange;
run;

/*11 Close the pdf file*/
ods pdf close;


/*******Questions: ********/
/*A) I found 13612 observations that did not have a match with the elevation file. I thought this was a bit too much. 

B) I found 1186 observations without a matching elevation came from the 2022 Only file.

C) The Waco Regional Airport has a height of 151.9 while the College Station Easterwood Field has a height of 96.

D) College Station Easterwood Field had a change of 25 in Fahrenheit from July 12 2021 to July 12 2022.

E) College Station Easterwood Field had a maximum temperature of 42 degrees Celsius. */



