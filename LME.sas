/*IMPORT DATA*/
proc import datafile="/home/u62868661/Datasets/Linear mixed-effects modelling/Theoph.csv"
dbms=csv
out=df
replace;
run;

/*DESCRIPTIVE TABLES*/
proc means data=df chartype mean std min max median n vardef=df clm 
		alpha=0.05 q1 q3 qmethod=os;
	var Wt Dose conc;
run;

/*HISTOGRAMS*/
proc univariate data=df vardef=df noprint;
	var Wt Dose conc;
	histogram Wt Dose conc / normal(noprint) kernel;
	inset mean std min max median n q1 q3 / position=nw;
run;

/*VISUALIZING DATA*/
proc sgplot data=df;
	reg x=Time y=conc / nomarkers cli alpha=0.05;
	scatter x=Time y=conc /;
	xaxis grid;
	yaxis grid;
run;

proc sgplot data=WORK.DF;
	reg x=Time y=conc / nomarkers group=Dose;
	scatter x=Time y=conc / group=Dose;
	xaxis grid;
	yaxis grid;
run;

/*LINEAR MIXED EFFECTS MODEL*/
proc mixed data=df method=reml plots=(residualPanel) alpha=0.05;
	class Subject;
	model conc=Wt Dose Time / solution cl alpha=0.05 alphap=0.05;
	random Subject /;
run;

