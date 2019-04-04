////////////////////////////////////////////////////////
// Figures comparing US to other countries
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////

// Penn World Table 9.0 downloaded from
// https://www.rug.nl/ggdc/productivity/pwt/
use "./Data/pwt90.dta", clear

egen countryid = group(countrycode) // create a numeric country id
xtset countryid year // organize in Stata to do lag operators

capture drop ln_gdppc
capture drop gdppc

// Get values from the US in 2009 as comparisons
summ rgdpe if countrycode=="USA" & year==2009
replace rgdpe = rgdpe/r(mean)
summ pop if countrycode=="USA" & year==2009
replace pop = pop/r(mean)

// Calculate GDP per capita, and scale to US
gen gdppc = 100*rgdpe/pop
gen ln_gdppc = ln(rgdpe/pop)
replace rgdpe = 100*rgdpe

// Calculate per capita growth rates for each country
gen Ggdppc = 100*(gdppc/L.gdppc - 1)
label variable Ggdppc "Year-to-year growth rate"
gen G10gdppc = 100*((gdppc/L10.gdppc)^(1/10) - 1)
label variable G10gdppc "Average 10-year growth rate"
gen Dgdppc = (gdppc - L.gdppc)
summ Dgdppc if countrycode=="USA" & year==2000
replace Dgdppc = Dgdppc/r(mean)

////////////////////////////////////////////////////////
// Produce figures
////////////////////////////////////////////////////////
preserve // save off original set of data
drop if year<1960 // drop pre-1960 to make figures look better

// Produce figures for growth rates of GDP
line G10gdppc year if countrycode=="USA" ///
	|| line G10gdppc year if countrycode=="FRA" ///
	|| line G10gdppc year if countrycode=="DEU", ///
	|| line G10gdppc year if countrycode=="JPN", ///
	|| line G10gdppc year if countrycode=="GBR", ///
	xtitle("Year") ytitle("10-year avg. growth in real GDP per capita") ///
	ylabel(-2(2)10, format(%3.1f)) xlabel(1960(10)2010 2014) ///
	legend(label(1 "United States") label(2 "France") label(3 "Germany") label(4 "Japan") label(5 "United Kingdom")) ///
	scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig02004.eps", replace as(eps)		
graph export "./Drafts/chi-vollrath-fig02004.png", replace as(png) width($width)

publish, name(chi-vollrath-fig02004) title("2.4 Growth rates of real GDP across countries")

// Produce figure for growth rates of GDP per capita
line G10gdppc year if countrycode=="USA" ///
	|| line G10gdppc year if countrycode=="JPN" ///
	|| line G10gdppc year if countrycode=="CHN", ///
	xtitle("Year") ytitle("10-year avg. growth in real GDP per capita") ///
	ylabel(-2(2)10, format(%3.1f)) xlabel(1960(10)2010 2014) ///
	legend(label(1 "United States") label(2 "Japan") label(3 "China")) scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig02005.eps", replace as(eps)	
graph export "./Drafts/chi-vollrath-fig02005.png", replace as(png) width($width)

publish, name(chi-vollrath-fig02005) title("2.5 Growth rates of real GDP in US, Japan, China")

restore // go back to original set of data

// Produce figure on growth in GDP per capita
twoway (bar Dgdppc year if countrycode=="USA", color(gs5) ///
	xtitle("Year") ytitle("Absolute growth in real GDP p.c. (relative to US in 2000)") ///
	ylabel(,angle(0) format(%7.0f) nogrid) xlabel(1950(10)2010 2014, angle(45)) ) ///
	(bar Dgdppc year if countrycode=="CHN", color(gs9) ///
	lwidth(narrow) ///
	legend(label(1 "United States") label(2 "China")) scheme(vollrath) ///
	)
graph export "./Drafts/chi-vollrath-fig02006.eps", replace as(eps)	
graph export "./Drafts/chi-vollrath-fig02006.png", replace as(png) width($width)

publish, name(chi-vollrath-fig02006) title("2.6 Growth of real GDP per capita in China and the US")

// Produce figure for level of GDP per capita
line gdppc year if countrycode=="USA" ///
	|| line gdppc year if countrycode=="JPN" ///
	|| line gdppc year if countrycode=="CHN", ///
	xtitle("Year") ytitle("Real GDP per capita (US in 2009=100)") ///
	ylabel(,format(%7.1f)) xlabel(1950(10)2010 2014) ///
	legend(label(1 "United States") label(2 "Japan") label(3 "China") ) scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig02007.eps", replace as(eps)		
graph export "./Drafts/chi-vollrath-fig02007.png", replace as(png) width($width)

publish, name(chi-vollrath-fig02007) title("2.7 The level of real GDP per capita across countries")
