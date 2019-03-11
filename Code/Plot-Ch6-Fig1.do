////////////////////////////////////////////////////////
// Figures on imports and exports
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/FRED-Annual.dta", clear

tsset year

// Normalize number of researchers to 100 in 1981
summ res_fte if year==1981
replace res_fte = 100*res_fte/r(mean)

label variable res_fte "FTE researchers"
label variable res_per1000_employ "Researchers per 1,000 employees"

////////////////////////////////////////////////////////
// Produce figures for exports and imports
////////////////////////////////////////////////////////

keep if year<=2015 & year>=1980

// Produce figure of growth rate of R&D investment
line res_per1000_employ year ///
	|| line res_fte year, yaxis(2) ///
	xtitle("Year") ytitle("Research workers per 1,000 employees") ytitle("FTE researchers (1981=100)", axis(2)) ///
	legend(label(1 "Research workers" "per 1,000 employees") label(2 "FTE researchers")) ///
	xlabel(1980(5)2015)
graph export "./Drafts/chi-vollrath-fig06001.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig06001) title("6.1 Researchers over time")
