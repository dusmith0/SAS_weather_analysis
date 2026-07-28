/* Adapted from DSmith_HW10_prog.sas (Dustin Smith, STAT 604 HW10).      */
/* Purpose (author's): create subsets of data with DATA steps and        */
/* conditioning. The DATA-step classification logic below is unchanged    */
/* from the original; only the external libref/fileref/ODS-PDF plumbing   */
/* has been moved to autoexec.sas so the program runs against the bundled  */
/* WORK.july22 sample and writes its report to the default listing.        */

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

/*4-6 Display the contents of Mylib, and Work.Normal */
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
