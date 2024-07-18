/***********************************************************************************/
/* Program Name: DSmith_HW10_prog.sas                                              */
/* Date Created: 3/18/2023                                                          */
/* Author: Dustin Smith                                                            */
/* Purpose: To complete Homework 10 of stats 604, where we will create subsets of data
with DATA steps, and conditioning.                                               */
/*                                                                                 */
/* Inputs: mylib library from "/home/u63307645/STAT_604_Folder/mylib";
/* Outputs: DSmith_HW10_output.pdf located at "/home/u63307645/STAT_604_Folder/STAT_604_Howework/DSmith_HW10_output.pdf"	                                                              */
/*                                                                                 */
/* 																	 			   */
/***********************************************************************************/

/*1 Housekeeping*/
title;
footnote;
ods noproctitle;

/*2 Assiging appropriate libraries*/
libname mylib "/home/u63307645/STAT_604_Folder/mylib";
filename output "/home/u63307645/STAT_604_Folder/STAT_604_Howework/DSmith_HW10_output.pdf";

/*Import the July22 SAS data table, and create 3 data.files with the data step*/
data normal mylib.hot mylib.july22_records;
	if _n_ <= 2 then putlog 'NOTE: PDV Before Set Statement' _all_;
	set mylib.july22;
	drop AWND TAVG;
	tempchange=TMAX-TMIN;
	length level$7;
	if 22 <= tempchange <= 28 then level = "Normal";
	if 10 < tempchange < 22 then level = "Low";
	if 28 < tempchange <= 33 then level = "High";
	if tempchange > 33 then level = "Extreme";
	if tempchange <= 10 then level = "Minimal";
	if tempchange = . then level = "Missing";
	/*below is to create the output*/
	output mylib.July22_records;
	if TMAX < 100 and TMAX ^= . then output normal;
	else if TMAX >= 100 then output mylib.hot;
	/*below is to check the PDV before the first run statement*/
	if _n_ <= 1 then putlog 'NOTE: PDV Before Run Statement' _all_ ;
run;

/*4-6 Open a pdf file, and display the contents of Mylib, and Work.Normal */
ods _all_ close;
ods pdf file=output;

title "Mylib Contents";
proc contents data=mylib._ALL_ nods;
run;

title "Normal Temperature";
proc contents data=work.normal;
run;

/*7-8 Create a Macro*/
%let MAC =01Jul2022;

title "Waco Area Data as of &MAC";
proc print data=mylib.july22_records;
	where DATE="&MAC"d and NAME contains "WACO";
run;

/*9 Changing the date to 19*/
%let MAC =19Jul2022;

ods _ALL_ close;
libname mylib clear;
filename output clear;
ods html path="%qsysfunc(pathname(work))";

/*****Questions */
/*A) I believe that the first PDV note occured when SAS defined the formating for the Variables. It listed the variables and their types.
     The second PDV note listed all of the first iteration of inputing the data, including the calculated data created in the DATA step 
     (as it the Level and Difference variables). While the third PDV note showed that SAS re-read in the data's format from the first observation,
     but ignored the caculated variables within the DATA step. The Level and Difference Variables were left missing until the 2nd iteration 
     was complete just before the run when SAS imput the data for the second observation.
	

B)  52831 observations were read from the July22 data set.

C)  46836 observations were read into the Temperary Normal data set
	However, 4787 observations are read if the missing values are removed.
	
D)  The July 01 macro produced 5 observations with two temp changes of 23 degrees and 3 with missing values. 
    Where as the July 19 macro produced only 4 values. One of those observations contained a difference in TMAX and TMIN
    being 26 degrees, while the others were missing values.  */

