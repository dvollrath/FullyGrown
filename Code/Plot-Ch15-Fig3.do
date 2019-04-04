////////////////////////////////////////////////////////
// Figures on Top Income Sources
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/PIKETTY-shares.dta", clear

label variable perc_lab_1929 "1929"
label variable perc_lab_2007 "2007"

replace perc_lab_1929 = 100*perc_lab_1929
replace perc_lab_2007 = 100*perc_lab_2007

////////////////////////////////////////////////////////
// Create figure for top labor share
////////////////////////////////////////////////////////
scatter perc_lab_1929 x, connect(line) lwidth(medthick) ///
	|| scatter perc_lab_2007 x, connect(line) clcolor(black) clpattern(dash) lwidth(medthick) ///
	xlabel(1 "90-95th" 2 "95-99th" 3 "99-99.5th" 4 "99.5-99.9th" 5 "99.9-99.99th" 6 "99.99-100th") ///
	xtitle("Percentile of income") ytitle("Wages as a percentage of total income") ylabel(0(10)100) scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig15003.eps", replace as(eps)				
graph export "./Drafts/chi-vollrath-fig15003.png", replace as(png) width($width)

publish, name(chi-vollrath-fig15003) title("15.3 Labor income for the top 10 percent in 1929 and 2007")	
