/***********************************************************************************/
/* Program Name: DSmith_HW08_prog.sas                                              */
/* Date Created: 2/26/2023                                                         */
/* Author: Dustin Smith                                                            */
/* Purpose: To complete Homework 8 of stats 604. We will be working with basic     */
/* input and output commands for SAS                                               */
/*                                                                                 */
/* Inputs: Storm.xlsx file
           found at:/home/u63307645/STAT_604_Folder/STAT_604_Howework/Storm.xlsx   */
/* 	 	   LIbrary Cert in SAS wepage 
           found at "/home/u63307645/my_shared_file_links/fkincheloe/stat604/cert" */
/* Outputs: DSmith_HW08_outputA.pdf							
			DSmith_HW08_outputB.pdf	
			Found here: /home/u63307645/STAT_604_Folder/STAT_604_Howework/         */
/* Things to refine: There seems to be some error at the end of the code           */
/*                       														   */
/***********************************************************************************/

/* 1) Housekeeping*/
title;
footnote;
ods noproctitle;

/*2) Open files and libraries to be used*/
libname libcert base "/home/u63307645/my_shared_file_links/fkincheloe/stat604/cert" access=readonly;
libname storm xlsx "/home/u63307645/STAT_604_Folder/STAT_604_Howework/Storm.xlsx" access=readonly;

filename fileone '/home/u63307645/STAT_604_Folder/STAT_604_Howework/DSmith_HW08_outputA.pdf';
filename filetwo '/home/u63307645/STAT_604_Folder/STAT_604_Howework/DSmith_HW08_outputB.pdf';

/*3) open files with the ods command*/
ods _all_ close;

ods pdf (fileone) file="/home/u63307645/STAT_604_Folder/STAT_604_Howework/DSmith_HW08_outputA.pdf" 
	style=harvest 
	bookmarklist=none;
	
ods pdf (filetwo) file="/home/u63307645/STAT_604_Folder/STAT_604_Howework/DSmith_HW08_outputB.pdf"
	pdftoc=1
	bookmarklist=show;

/*4-5) write a proc step to show all of the data sets in each library, close output A*/
title "Library Cert's data sets";
footnote "Downloaded from SAS Website";
ods proclabel "Library Cert's data sets";
proc contents data=libcert._all_ nods;
run;

title "Library Storm data sets";
footnote;
ods proclabel "Library Storm data sets";
proc contents data=storm._all_ nods;
run;

ods pdf (fileone) close;

/*6 list information from Storm_Summary, in order of creation*/

proc contents data=storm.storm_summary varnum;
	title1 "Strom Summary Worksheet";
	title2 "Descritpor Portion";
	ods proclabel "Storm Summary – Metadata";
run;

/*7 List the data from Storm_Summary*/
title2;
ods proclabel "Storm Summary – Data";
proc print data=storm.storm_summary;
	title3 "Data Portion";
run;

/*8 List the descriptor of the Bookcase portion of cert*/
title1 "Bookcase Data Set Information";
ods proclabel "Bookcase – Descriptor";
proc contents data=libcert.bookcase;
run;

/*9 List the data protion of the Bookcase file*/
ods pdf startpage=no;
ods proclabel "Bookcase – Data";
proc print data=libcert.bookcase;
run;

/*10 and 11 Delete things*/

libname storm clear;

ods pdf (filetwo) close;
ods html path="%qsysfunc(pathname(work))";

/*Questions*/
/*1 The last two items in the Table of Contents page are the Directory for the 
Storm.xlsx page, and the table displaying the different sheets in the excel file. 
The last two values on the table are Subbasin_codes and Type_codes


2 I believe that there are 8 tables in the excel file. Assuming that each sheet is also a table.


3 There are 19 observations, but the observation length is 32


4 I believe that there are two numeric variables in the bookcase data set
being "Item" and "Price"


5 I assumed that the Note was informing me that the SAS could not access the number of observations 
in the excel file. So instead it counted the data as it read it into the proc print. The other notes
seemed to be about the process that occurred when the proc print ran.

6  The Arlene storm started at 08Jun2005 and ended at 14Jun2005, with a max wind speed of 69 miles per hour*/
