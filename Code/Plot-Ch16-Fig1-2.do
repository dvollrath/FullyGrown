////////////////////////////////////////////////////////
// Figures on imports and exports
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/FRED-Annual.dta", clear

gen total = (gdp + imports)/pop
gen perc_imp_out = imports/total
gen purch = (consumption + investment + government + exports)/pop
gen perc_c_purch = consumption/purch
gen perc_i_purch = investment/purch
gen perc_g_purch = government/purch
gen perc_x_purch = exports/purch

drop if year<1950

summ total if year==1950
replace total = 100*total/r(mean)
replace imports = 100*(imports/pop)/r(mean)
replace exports = 100*(exports/pop)/r(mean)
replace investment = 100*(investment/pop)/r(mean) + exports
replace government = 100*(government/pop)/r(mean) + investment
replace consumption = 100*(consumption/pop)/r(mean) + government

label variable total "Total output"
label variable imports "Imported output"
label variable exports "Foreign purchases"
label variable investment "Capital purchases"
label variable government "Government purchases"
label variable consumption "Consumption purchases"

gen low = 0

////////////////////////////////////////////////////////
// Produce figures for exports and imports
////////////////////////////////////////////////////////

// Figure for total available output
twoway rarea total imports year, color(gs4) || rarea imports low year, color(gs8) ///
	legend(label(1 "Domestic production") label(2 "Imported production")) ///
	xlabel(1950(10)2010 2016) xtitle("Year") ytitle("Production per capita (1950=100)") scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig16001.eps", replace as(eps)			
graph export "./Drafts/chi-vollrath-fig16001.png", replace as(png) width($width)

publish, name(chi-vollrath-fig16001) title("16.1 Production per capita available for purchase, over time")	

// Figure for total purchases
twoway rarea consumption government year, color(gs6) || rarea government investment year, color(gs10)  ///
	|| rarea investment exports year, color(gs8) || rarea exports low year, color(gs4) ///
	legend(label(1 "Consumption purchases") label(2 "Government purchases") label(3 "Capital purchases") label(4 "Foreign purchases")) ///
	xlabel(1950(10)2010 2016) xtitle("Year") ytitle("Purchases per capita (1950=100)") scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig16002.eps", replace as(eps)				
graph export "./Drafts/chi-vollrath-fig16002.png", replace as(png) width($width)
	
publish, name(chi-vollrath-fig16002) title("16.2 Categories of purchased production per capita")		
