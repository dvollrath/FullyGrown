////////////////////////////////////////////////////////
// Figures on growth rate, growth, and level
// of real GDP per capita
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/FRED-Annual.dta", clear
drop if year<1949 // use post-war era only
drop if year>2016 // drop excess data if present
tsset year // set up time series operators

////////////////////////////////////////////////////////
// Calculations
////////////////////////////////////////////////////////

// Normalize levels to 2009
summ gdp_pc if year==2009
replace gdp_pc = 100*gdp_pc/r(mean)

// Calculate alternative GDP path without slowdown
gen altgdppc = gdp_pc if year<=2000
summ gdp_pc if year==2000
replace altgdppc = 1.022^(year-2000)*r(mean) if year>2000 // using 2.2 percent growth

////////////////////////////////////////////////////////
// Figures using possible GDP per capita
////////////////////////////////////////////////////////

// Produce figure of alternative and actual GDP per capita
line altgdppc year /// 
	|| line gdp_pc year, ///
	xtitle("Year") ytitle("Real GDP per capita (2009=100)") /// ylabel(70(10)140) ///
	legend(label(1 "Possible GDP per capita") label(2 "Actual GDP per capita")) xlabel(1950(10)2010 2016) ylabel(20(20)140) ///
	scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig02008.eps", replace as(eps)	
graph export "./Drafts/chi-vollrath-fig02008.png", replace as(png) width($width)

publish, name(chi-vollrath-fig02008) title("2.8 The actual and possible level of real GDP per capita")
