////////////////////////////////////////////////////////
// Figures on birth rates
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/OECD-pop.dta", clear

////////////////////////////////////////////////////////
// Produce figure of dependency ratios by year
////////////////////////////////////////////////////////
line value time if age=="D1TTR5Y2" ///
	|| line value time if age=="D1TTR5O2", ///
	xtitle("Year") xlabel(1950(10)2030) ///
	ytitle("Percentage of working age population (20-64)") ///
	legend(label(1 "Youth dependency (0-20)") label(2 "Old age dependency (65+)"))
graph export "./Drafts/chi-vollrath-fig05003.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig05003) title("5.3 Dependency ratios over time")

////////////////////////////////////////////////////////
// Process data for age distribution figure
////////////////////////////////////////////////////////
keep if inlist(time,1960,1970,1980,1990,2000,2010,2020)
keep if sex=="TT" // both sexes
keep if strpos(age,"L5") // selects only 5-year bins
drop if age=="D199L5TT" // drop total population count

gen str_age = substr(age,7,2) // parse age variable for the minimum age 
replace str_age = "85" if str_age=="M8" // replace for the highest group
destring str_age, replace // turn into a numeric

replace value = value/1000 // put population count in millions

////////////////////////////////////////////////////////
// Produce figure of age distribution by year
////////////////////////////////////////////////////////
scatter value str_age if time==1960, connect(line) ///
	|| scatter value str_age if time==1990, connect(line) lpattern(dash) ///
	|| scatter value str_age if time==2020, connect(line) ///
	xtitle("Minimum age in bin") ytitle("Millions of people") ///
	xlabel(0(5)85) ///
	legend(label(1 "1960") label(2 "1990") label(3 "2020"))
graph export "./Drafts/chi-vollrath-fig05002.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig05002) title("5.2 Age structure over time")
