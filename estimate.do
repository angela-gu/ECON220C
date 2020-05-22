clear
set more off

log using /users/angela.gu/Desktop/aygu_assignment3/program/estimate.log

quietly set obs 100
gen d = 0
replace d = 1 if _n>50
gen y = 0
replace y = 1 if _n>40 & _n<=50
replace y = 1 if _n>60 
probit y d
logit y d  

clear
quietly set obs 100
gen d = 0
replace d = 1 if _n>50
gen y = 0
replace y = 1 if _n>50
probit y d

clear
quietly set obs 100
drawnorm x
gen y = (x>0)
logit y x

log close
