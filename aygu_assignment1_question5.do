/**************************************************************
Angela Gu
Econ 220C
Spring 2020
Assignment1
**************************************************************/

clear
set more off

cd /Users/angela.gu/Desktop/econ220c/aygu_assignment1

log using ./program/aygu_assignment1_question5.log, replace

global root ./
global input $root/input
global output $root/output



use $input/handguns.dta, clear
gen log_vio = log(vio)
gen log_mur = log(mur)
gen log_rob = log(rob)

foreach var of varlist log_vio log_mur log_rob {
	reg `var' shall, robust
}

foreach var of varlist log_vio log_mur log_rob {
	reg `var' shall incarc_rate density pop pm1029 avginc, robust
}

egen statenumber = group(state)

foreach var of varlist log_vio log_mur log_rob {
	xi: reg `var' shall incarc_rate density pop pm1029 avginc i.statenumber, robust
	testparm *statenum*
	xi: reg `var' shall incarc_rate density pop pm1029 avginc i.statenumber i.year, robust
	testparm *statenum* 
	testparm *year*
	xi: reg `var' shall incarc_rate density pop pm1029 avginc i.statenumber i.year, robust cluster(statenumber)
}

log close
