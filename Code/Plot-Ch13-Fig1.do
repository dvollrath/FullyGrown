////////////////////////////////////////////////////////
// Figures on mobility
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////

use "./Work/FRED-Annual.dta", clear

replace movers = movers/1000
label variable movers "Number"
label variable move_rate "Percent"

drop if year<1950

////////////////////////////////////////////////////////
// Produce figures
////////////////////////////////////////////////////////

// Produce figure of movers
twoway bar movers year, color(gs4) ///
	|| scatter move_rate year, connect(line) yaxis(2) lwidth(medthick) ///
	xtitle("Year") ytitle("Percentage of people who moved", axis(2)) ytitle("Number of movers (millions)") ///
	xlabel(1950(10)2010 2016) ylabel(0(5)20, axis(2)) scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig13001.eps", replace as(eps)				
graph export "./Drafts/chi-vollrath-fig13001.png", replace as(png) width($width)

publish, name(chi-vollrath-fig13001) title("13.1 Number of movers, and percent of people moving, by year")
