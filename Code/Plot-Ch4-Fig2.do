////////////////////////////////////////////////////////
// Residual versus capital in growth
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/FRED-Annual.dta", clear

keep if year>1949
tsset year
sort year

gen ylow = 100 // reference point for figures
gen cap  = bea_chain_k^(.35)*bea_h^(.65) // gdp pc just from capital

summ cap if year==1950
replace cap = 100*cap/r(mean)

summ gdp_pc if year==1950
replace gdp_pc = 100*gdp_pc/r(mean)

////////////////////////////////////////////////////////
// Produce figure
////////////////////////////////////////////////////////

keep if year<=2016

// Produce figure of capital versus residual growth for per capita GDP
twoway rarea cap ylow year, color(gs5) || rarea gdp_pc cap year, color(gs10) ///
	xtitle("Year") ytitle("Real GDP per capita") xlabel(1950(10)2010 2016) ///
	legend(label(1 "Growth from cap. accum.") label(2 "Residual growth")) scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig04002.eps", replace as(eps)			
graph export "./Drafts/chi-vollrath-fig04002.png", replace as(png) width($width)	

publish, name(chi-vollrath-fig04002) title("4.2 Accounting for real GDP per capita")
