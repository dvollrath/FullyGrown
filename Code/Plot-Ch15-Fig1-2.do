////////////////////////////////////////////////////////
// Create figures on distribution of income
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/PSZ-dist-acct.dta", clear

local type = "pre" // use pre-tax data

label variable `type'_50 "Bottom half"
label variable `type'_40 "10th to 50th percent"
gen `type'_101 = `type'_10 - `type'_1 // create a variable for 1st to 10th percentile
label variable `type'_101 "1st to 10th percent"
label variable `type'_1 "Top one percent"

drop if year<1960 | year>2014 // drop without data

gen pre_1_add1 = pre_1_cap_equity + pre_1_cap_int
gen pre_1_add2 = pre_1_add1 + pre_1_cap_mix
gen pre_1_add3 = pre_1_add2 + pre_1_cap_rent + pre_1_cap_soc
gen pre_1_add4 = pre_1_add3 + pre_1_labor
gen pre_1_zero = 0

gen pre_1_labor_share = pre_1_labor/pre_1

////////////////////////////////////////////////////////
// Produce figures
////////////////////////////////////////////////////////

// Income shares by percentile
line `type'_50 `type'_40 `type'_101 year || line `type'_1 year, clcolor(black) ///
	xlabel(1960(10)2010 2015) ylabel(0(.1).5,format(%9.1f)) xtitle("Year") ///
	ytitle("Share of national income") scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig15001.eps", replace as(eps)				
graph export "./Drafts/chi-vollrath-fig15001.png", replace as(png) width($width)

publish, name(chi-vollrath-fig15001) title("15.1 Distribution of national income, by percentiles")	

twoway rarea pre_1_add4 pre_1_add3 year, color(gs12) ///
	|| rarea pre_1_add3 pre_1_add2 year, color(gs10) || rarea pre_1_add2 pre_1_add1 year, color(gs8) ///
	|| rarea pre_1_add1 pre_1_cap_equity year, color(gs6) || rarea pre_1_cap_equity pre_1_zero year, color(gs4) ///
	xlabel(1960(10)2010 2014) ylabel(,format(%9.2f)) xtitle("Year") ///
	ytitle("Share of national income") ///
	legend(label(1 "Labor income") label(2 "Rents and misc.") label(3 "Mixed income") label(4 "Interest") label(5 "Equity")) ///
	scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig15002.eps", replace as(eps)				
graph export "./Drafts/chi-vollrath-fig15002.png", replace as(png) width($width)			

publish, name(chi-vollrath-fig15002) title("15.2 Sources of income for the top 1 percent")	
