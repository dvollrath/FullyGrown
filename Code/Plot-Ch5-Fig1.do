////////////////////////////////////////////////////////
// Figures on birth rates
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/MITCHELL-CBR.dta", clear

////////////////////////////////////////////////////////
// Produce figures
////////////////////////////////////////////////////////

line cbr year ///
	|| line tfr year, yaxis(2) ///
	xtitle("Year") ytitle("Crude birth rate (per 1,000)") ytitle("Total fertility rate", axis(2)) ///
	xlabel(1910(10)2010 2020) scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig05001.eps", replace as(eps)			
graph export "./Drafts/chi-vollrath-fig05001.png", replace as(png) width($width)

publish, name(chi-vollrath-fig05001) title("5.1 Different fertility measures over time")
