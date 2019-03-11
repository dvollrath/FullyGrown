////////////////////////////////////////////////////////
// Figures on firm concentration
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////

use "./Work/CENSUS-firms.dta", clear

gen perc04 = size04/total
gen perc59 = size59/total
gen perc1019 = size1019/total
gen perc2099 = size2099/total
gen perc100499 = size100499/total
gen perc500 = size500/total
gen percLT500 = perc04 + perc59 + perc1019 + perc2099 + perc100499

label variable perc500 ">=500 Employees"
label variable percLT500 "<500 Employees"

keep if measure=="Employment"

////////////////////////////////////////////////////////
// Produce figure on employment by firm size
////////////////////////////////////////////////////////
scatter perc500 year, connect(direct) ///
	|| scatter percLT500 year, connect(direct) clpattern(dash) ///
	ylabel(,format(%9.2f)) ytitle("Share of all employment") xtitle("Year")
graph export "./Drafts/chi-vollrath-fig10003.png", replace as(png) width(1500)

