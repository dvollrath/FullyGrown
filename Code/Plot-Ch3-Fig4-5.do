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

summ bea_h if year==1950
replace bea_h = 100*bea_h/r(mean)

// 10-year growth rates of human capital stocks
gen hgrowth = 100*([bea_h/L10.bea_h]^(1/10) - 1)

////////////////////////////////////////////////////////
// Produce figures
////////////////////////////////////////////////////////

keep if year<=2016

// Produce figure of human capital stock
line bea_h year,  ///
	xtitle("Year") ytitle("Human capital per capita (1950=100)") ///
	xlabel(1950(10)2010 2016) ylabel(100(10)170)
graph export "./Drafts/chi-vollrath-fig03004.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig03004) title("3.4 Stock of human capital per capita over time")

// Produce growth rate of human capital
line hgrowth year,  ///
	xtitle("Year") ytitle("10-year average growth in human capital per capita (%)") ///
	ylabel(, format(%9.1f)) yline(0) ///
	xlabel(1950(10)2010 2016)
graph export "./Drafts/chi-vollrath-fig03005.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig03005) title("3.5 10-year average growth rate of human capital")

