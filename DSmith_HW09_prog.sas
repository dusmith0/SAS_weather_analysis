/***********************************************************************************/
/* Program Name: DSmith_HW09_prog.sas                                              */
/* Date Created: 3/6/2023                                                          */
/* Author: Dustin Smith                                                            */
/* Purpose: To complete Homework 9 of stats 604.                                              */
/*                                                                                 */
/* Inputs: elevations.csv called height at "/home/u63307645/STAT_604_Folder/mylib/elevations.csv"
		   july21.xlsx called july21 at "/home/u63307645/STAT_604_Folder/mylib/July21.xlsx"
		   july22.txt called july22 at "/home/u63307645/STAT_604_Folder/mylib/July22.txt"
/* Outputs: DSmith_HW09_output.xlsx found at  	"/home/u63307645/STAT_604_Folder/STAT_604_Howework/DSmith_HW09_output.xlsx" 	                                                               */
/*                                                                                 */
/* 																	 			   */
/***********************************************************************************/

/*Houskeeping*/
title;
footnote;
ods noproctitle;

/*2 Assing a mylib libref, and create filerefs for use in the program*/
libname mylib "/home/u63307645/STAT_604_Folder/mylib";

filename height "/home/u63307645/STAT_604_Folder/mylib/elevations.csv";
filename july21 "/home/u63307645/STAT_604_Folder/mylib/July21.xlsx";
filename july22 "/home/u63307645/STAT_604_Folder/mylib/July22.txt";

filename output "/home/u63307645/STAT_604_Folder/STAT_604_Howework/DSmith_HW09_output.xlsx";

/*3-5 create a permanent data set out of the above files*/
/*Elevation.csv*/
proc import datafile=height
	DBMS=CSV
	out=mylib.elevation
	replace;
run;
/*July21.xlsx*/
proc import datafile=july21
	DBMS=XLSX
	out=mylib.july21
	replace;
options validvarname=Any;
run;
/*July22.txt*/
proc import datafile=july22
	DBMS = tab
	out=mylib.july22
	replace;
	guessingrows=MAX;
run;

/* Create a subset of the July22 data */
data mylib.'Harlingen Rio Gande Airport'n;
	set mylib.july22;
		where NAME="HARLINGEN RIO GRANDE VALLEY INTERNATIONAL AIRPORT, TX US";
run;

/*6 Open an output Excel file with ods*/
ods _all_ close;

ods excel file=output
	options(sheet_name="Mylib Data Sets" sheet_interval='proc' embedded_titles='yes');

/*7-10 Add the contents of xlsx file to the output*/
title "Contents of July22";
proc contents data=mylib.july22;
	run;
	
title "HARLINGEN RIO GRANDE VALLEY INTERNATIONAL AIRPORT, TX US";
ods excel options(sheet_name="Harlingen");
proc print data=mylib.'Harlingen Rio Gande Airport'n;
	run;

ods excel close;

/*11-13 Create a new libref to the output file */
libname output2 xlsx "/home/u63307645/STAT_604_Folder/STAT_604_Howework/DSmith_HW09_output.xlsx";

title "July 2022 High Temperatures";
data output2."July 2022 High Temperatures"n;
	set mylib.july22;
	where TMAX > 99;
run;

libname output2 clear;

/*14 Use the export to place the elevations file onto the excel output*/
title "Elevation";
proc export data=mylib.elevation
	outfile= output
	DBMS = xlsx
	replace;
	sheet=Elevation;
run;

/*Clear all files*/
ods _ALL_ close;
filename _ALL_ clear;
libname _ALL_ clear;

/***** Questions
 A upon opening a fresh session, it seems that my librefs are MAPS, MAPSGFK, MAPSSAS, SASDATA, SASHELP, SASUSER, STPSAMP, WEBWORK, and WORK. 
 After running my libname and filename script, the Library added a libref of Mylib, which contained Elevation, Harlingen Rio Grande Airport, July21, and July22.
 
 B The Date Variable for the elevation sas table is of a character type of length 12 and a format of $12. Whereas 
 the Date Variable for the july21 sas table is of a numeric type with length 8 and has a format of MMDDYY10
 
 C My excel file contains 5996 observations of data.
 
 D this assignment used the Proc Export, Ods excel, and the basic data blocks.*****/




