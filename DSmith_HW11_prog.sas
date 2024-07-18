/***********************************************************************************/
/* Program Name: DSmith_HW11_prog.sas                                              */
/* Date Created: 3/24/2023                                                          */
/* Author: Dustin Smith                                                            */
/* Purpose: To complete Homework 11 of stats 604, where we will be using functions
			to edit data.						                                   */
/*                                                                                 */
/* Inputs: Elevations SAS table from: "/home/u63307645/STAT_604_Folder/mylib/elevation.sas7bdat
   Outputs: DSmith_HW11_Output.pdf at "/home/u63307645/STAT_604_Folder/STAT_604_Howework/DSmith_HW11_output.pdf"                                                              */
/*                                                                                 */
/* 																	 			   */
/***********************************************************************************/

/*1 Housekeeping*/
title;
footnote;
ods noproctitle;

/*Macros GO HERE!!!*/
%let date =01Jan2022; /*I am not certain if SAS will like this date*/

/*Setting File and Library References*/
libname mylib "/home/u63307645/STAT_604_Folder/mylib";
filename height "/home/u63307645/STAT_604_Folder/mylib/elevation.sas";
filename output "/home/u63307645/STAT_604_Folder/STAT_604_Howework/DSmith_HW11_output.pdf";

/*4 open a file to read to*/
ods pdf file=output 
	bookmarklist = none;

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

/*9 Close the ods file*/

ods pdf close;
	
/* Questions
A)   The original Elevations data set contained 7 variables of character type with lengths of 1, 12, 7, 11, 12, 30, and 13. 
     Whereas the new data set Contains 9 Variables, where 5 of them (DATE, Day, Elevation, Latitude, and Longitude) are numeric with length 8. 
     The others remained character. (Name, Station, Station_Code, and Station_Type). 
     
B)   IF the USW stations are restricted to an elevation of 100 to 375, then the lowest elevation is at 
     HUNTSVILLE MUNICIPAL AIRPORT with a value of 105.
     
     IF the USW stations are not restricted in elevations, then the lowest is at 
     GALVESTON SCHOLES FIELD with a height of 2.
     
C)   IF the USW stations are restricted to an elevation of 100 to 375, then the highest elevation is tied at
	 WICHITA FALLS MUNICIPAL AIRPORT and ROBERT GRAY ARMY AIR FIELD with a value of 309. 
	 
	 IF the USW stations are not restricted in elevations, then the highest is at 
     PINE SPRINGS GUADALUPE AIRPORT with a height of 1,655.

D)   The USW stations are all Airports. */








