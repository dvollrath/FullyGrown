////////////////////////////////////////////////////////
// Figures on MSA's and temperatures
////////////////////////////////////////////////////////

use "./Work/BEA-metro-final.dta", clear

drop if wrluri==. // get rid of rows without regulation data

drop label // drop and recreate own label for cities
gen label=""
replace label="New York" if code==35620
replace label="San Jose" if code==41940
replace label="Seattle" if code==42660
replace label="San Fran/Oakland" if code==41860

forvalues i = 2001(1)2016 { // produce GDP per worker and per capital
	gen gdppw`i' = gdp`i'/lforce`i'
	summ gdppw`i'
	replace gdppw`i' = gdppw`i'/r(min) // index all GDP per worker to minimum
	replace pop`i' = pop`i'/1000000
	summ gdppc`i'
	replace gdppc`i' = gdppc`i'/r(min) // index all GDP per person to minimum
}

////////////////////////////////////////////////////////
// Create figure for regulation and gdp per worker
////////////////////////////////////////////////////////
scatter wrluri gdppw2016 if wrluri<2 & gdppw2016<6, ///  eliminate outliers
	mlabel(label) mlabposition(12) ///
	xtitle("GDP per capita, 2016 (relative to min.)") ytitle("Real estate regulation index") scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig14003.eps", replace as(eps)				
graph export "./Drafts/chi-vollrath-fig14003.png", replace as(png) width($width)

publish, name(chi-vollrath-fig14003) title("14.3 Real Estate Regulation and GDP per worker, 2016, by metro area")	
