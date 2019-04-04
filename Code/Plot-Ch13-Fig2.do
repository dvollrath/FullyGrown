////////////////////////////////////////////////////////
// Figures on state personal income
////////////////////////////////////////////////////////
use "./Work/FRED-State.dta", clear

////////////////////////////////////////////////////////
// Produce figures
////////////////////////////////////////////////////////

// Figure of state GDP per worker against rank in GDP per worker
scatter rgsppw2016 rank2016 ///
	|| scatter rgsppw2007 rank2007 ///
	|| scatter rgsppw1997 rank1997, ///
	xtitle("Rank of GDP per worker across states") ytitle("GDP per worker (relative to minimum)") ///
	xlabel(1 10(10)50) ///
	legend(label(1 "2016") label(2 "2007") label(3 "1997")) scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig13002.eps", replace as(eps)				
graph export "./Drafts/chi-vollrath-fig13002.png", replace as(png) width($width)

publish, name(chi-vollrath-fig13002) title("13.2 Relative GSP per worker across states, by rank")
