////////////////////////////////////////////////////////
// Figures on growth rate, growth, and level
// of real GDP per capita
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/FRED-Annual.dta", clear
drop if year<1949 // use post-war era only
tsset year // set up time series operators

////////////////////////////////////////////////////////
// Calculations
////////////////////////////////////////////////////////

// Calculate growth rates, 10-year growth rates
gen Ggdppc = 100*(gdp_pc/L.gdp_pc - 1)
label variable Ggdppc "Year-to-year growth rate"
gen G10gdppc = 100*((gdp_pc/L10.gdp_pc)^(1/10) - 1)
label variable G10gdppc "10-year average growth rate"
gen G3gdppc = 100*((gdp_pc/L3.gdp_pc)^(1/3) - 1)
label variable G3gdppc "3-year average growth rate"

// Calculate growth, and normalize compared to 2000
gen Dgdppc = (gdp_pc - L.gdp_pc) // absolute growth 
label variable Dgdppc "Growth in GDP per capita"
summ Dgdppc if year==2000 // get average Dgdppc
replace Dgdppc = Dgdppc/r(mean) // normalize all years to 2000
egen Dgdppc_mean = mean(Dgdppc) // calculate the mean growth

// Normalize levels to 2009
summ gdp_pc if year==2009
replace gdp_pc = 100*gdp_pc/r(mean)
gen ln_gdp_pc = ln(gdp_pc)

////////////////////////////////////////////////////////
// Figures using GDP per capita
////////////////////////////////////////////////////////

// Produce figure of growth rate of GDP per capita
line G10gdppc year if year>1959 ///
	|| line Ggdppc year if year>1949, ///
	xtitle("Year") ytitle("Growth rate of real GDP per capita") ///
	xlabel(1950(10)2010 2016) ylabel(-4(1)8)
graph export "./Drafts/chi-vollrath-fig02001.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig02001) title("2.1 Growth rate of GDP per capita")

// Produce figure of growth in GDP per capita
twoway (bar Dgdppc year, ///
	xtitle("Year") ytitle("Growth in real GDP p.c. (rel to 2000 GDP p.c. growth)") ///
	ylabel(-1.5(.5)1.5, format(%7.1f)) xlabel(1950(10)2010 2016) ) ///
	(line Dgdppc_mean year, legend(off) ///
	)
graph export "./Drafts/chi-vollrath-fig02002.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig02002) title("2.2 Absolute growth of GDP per capita")

// Produce figure of level of GDP per capita
line gdp_pc year, ///
	xtitle("Year") ytitle("Real GDP per capita (2009=100)") ///
	ylabel(, format(%7.0fc)) xlabel(1950(10)2010 2016)
graph export "./Drafts/chi-vollrath-fig02003.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig02003) title("2.3 Level of GDP per capita")

