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

// assign codes to denote Florida and Arizona
gen flaz = 0 
replace flaz = 1 if fipsstatecode=="12" | fipsstatecode=="04"

forvalues i = 2001(1)2016 { // produce GDP per worker and per capital
	gen gdppw`i' = gdp`i'/lforce`i'
	summ gdppw`i'
	replace gdppw`i' = gdppw`i'/r(min) // index all GDP per worker to minimum
	replace pop`i' = pop`i'/1000000
	summ gdppc`i'
	replace gdppc`i' = gdppc`i'/r(min) // index all GDP per person to minimum
}

gen Glforce = 100*(lforce2015/lforce2001 - 1) // growth of labor force

////////////////////////////////////////////////////////
// Produce figure of Labor Force growth and temp
////////////////////////////////////////////////////////

// City size and GDP per worker
scatter gdppw2015 pop2015, xscale(log extend) yscale(log) mlabel(label) mlabposition(12) ///
	xtitle("City population (millions)") ytitle("Metro GDP per capita (relative to min.) in 2015") ///
	ylabel(1 2(2)6) xlabel(.1 .5 1 2 3 4 5 10 15 20) scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig13003.eps", replace as(eps)				
graph export "./Drafts/chi-vollrath-fig13003.png", replace as(png) width($width)

publish, name(chi-vollrath-fig13003) title("13.3 Relative GDP per worker across MSAs versus their size, 2015")

// GDP per worker and growth
scatter Glforce gdppw2001 if gdppw2001<5, xscale(log extend) ///
	xtitle("Metro GDP per capita (relative to min.) in 2001") ytitle("Percentage growth in labor force, 2001-2015") ///
	xlabel(1 2 4) scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig13004.eps", replace as(eps)				
graph export "./Drafts/chi-vollrath-fig13004.png", replace as(png) width($width)

publish, name(chi-vollrath-fig13004) title("13.4 Growth in MSA labor force versus relative GDP per worker, 2001-2015")

scatter Glforce temp_avg_jan if flaz==1, msymbol(O) ///
	|| scatter Glforce temp_avg_jan if flaz==0, ///
	xlabel(10 20 30 40 50 60 70 80) /// 
	xtitle("Mean January temperature (F)") ytitle("Percentage growth in labor force, 2001-2015") ///
	legend(label(1 "Florida and Arizona") label(2 "All other states")) scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig13005.eps", replace as(eps)				
graph export "./Drafts/chi-vollrath-fig13005.png", replace as(png) width($width)

publish, name(chi-vollrath-fig13005) title("13.5 Growth in MSA labor force versus mean January temperature")
