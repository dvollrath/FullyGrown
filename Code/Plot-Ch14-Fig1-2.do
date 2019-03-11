////////////////////////////////////////////////////////
// Figures on state personal income
////////////////////////////////////////////////////////
use "./Work/FRED-State.dta", clear

////////////////////////////////////////////////////////
// Produce figures
////////////////////////////////////////////////////////

// Figure of state GDP per worker and ALEC rank
scatter rgsppw2016 alec_rank, ///
	xtitle("ALEC rank (1=best, 50=worst), 2012") ytitle("GDP per worker (relative to minimum)") ///
	msymbol(none) mlabel(state) mlabposition(0) xlabel(1 10(10) 50)
graph export "./Drafts/chi-vollrath-fig14001.png", replace as(png) width(1500)
	
publish, name(chi-vollrath-fig14001) title("14.1 Level of GDP per worker versus ALEC ranking, by state")	
	
// Figure of state GDP growth and ALEC rank	
scatter growth alec_rank, ///
	xtitle("ALEC rank (1=best, 50=worst), 2012") ytitle("Average growth rate of GDP (%), 2012-2016") ///
	msymbol(none) mlabel(state) mlabposition(0) xlabel(1 10(10) 50) ylabel(-4(1)3, format(%9.1f))
graph export "./Drafts/chi-vollrath-fig14002.png", replace as(png) width(1500)
	
publish, name(chi-vollrath-fig14002) title("14.2 Growth rate of GDP per worker, 2012-2016, versus ALEC ranking, by state")	
