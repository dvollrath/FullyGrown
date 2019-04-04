////////////////////////////////////////////////////////
// Human capital figures
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/FRED-Annual.dta", clear

keep if year>1949
tsset year
sort year

summ bea_chain_k if year==1950
replace bea_chain_k = 100*bea_chain_k/r(mean)

// 10-year growth rates of human capital stocks
gen kgrowth = 100*([bea_chain_k/L10.bea_chain_k]^(1/10) - 1)

////////////////////////////////////////////////////////
// Produce figures
////////////////////////////////////////////////////////

keep if year<=2016

// Produce growth rate of physical capital
line kgrowth year, ///
	xtitle("Year") ytitle("10-year average growth in physical capital per capita (%)") ///
	ylabel(0(.5)2.5, format(%9.1f)) ///
	xlabel(1950(10)2010 2016) scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig03008.eps", replace as(eps)			
graph export "./Drafts/chi-vollrath-fig03008.png", replace as(png) width($width)

publish, name(chi-vollrath-fig03008) title("3.8 The growth rate of physical capital")



