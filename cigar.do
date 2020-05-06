/**************************************************************
Angela Gu
Econ 220C
Spring 2020
Assignment 2
**************************************************************/

clear
set more off

cd /Users/angela.gu/Desktop/econ220c/aygu_assignment2

global root ./
global input $root/input

log using $input/aygu_assignment2.log, replace

import excel using $input/cigar.xls, firstrow clear
rename *, lower
sort state year
tsset state year

/**************************************************************
Part (a)                                              
**************************************************************/
reg logconsumption L1.logconsumption lnprice logincome logminimumpriceatneighboring, robust

/**************************************************************
Part (b)                                              
**************************************************************/
xi: reg logconsumption L1.logconsumption lnprice logincome logminimumpriceatneighboring i.year, robust

/**************************************************************
Part (c)                                              
**************************************************************/
by state: gen logconsumption1=logconsumption[_n-1]
xtreg logconsumption logconsumption1 lnprice logincome logminimumpriceatneighboring, fe
* With the assumptions given, Beta_1 is consistent.  While we do not have 

/**************************************************************
Part (d)                                              
**************************************************************/
xi: xtreg logconsumption logconsumption1 lnprice logincome logminimumpriceatneighboring i.year, fe
testparm _Iyear* 

**************************************************************
*      Part (e)                                              *
**************************************************************
gen dlogconsumption=D.logconsumption
ivreg D.logconsumption (L1.dlogconsumption = L2.logconsumption) D.lnprice D.logincome D.logminimumpriceatneighboring _Iyear* 



**************************************************************
*      Part (g)                                              *
**************************************************************

*******g.i **********
xi: xtabond logconsumption lnprice logincome logminimumpriceatneighboring i.year, lags(1)

*******g.ii **********
xi: xtabond logconsumption lnprice logincome logminimumpriceatneighboring i.year, lags(1) maxldep(3)

*******g.iii **********
xi: xtabond logconsumption lnprice logincome logminimumpriceatneighboring i.year, lags(1) maxldep(1)

log close
