////////////////////////////////////////////////////////
// Figure on education composition
////////////////////////////////////////////////////////

use "./Work/CPS-hc-exp.dta", clear

// Combine shares for two elementary categories, they are both small
gen share_elem_all = share_elem_04 + share_elem_58 

line share_high_4 year, ///
	|| line share_high_13 year,  ///
	|| line share_coll_4plus year, ///
	|| line share_coll_13 year, ///
	|| line share_elem_all year, ///
	ytitle("Share of people aged 25+") xtitle("Year") ///
	ylabel(, format(%3.1f)) xlabel(1940(10)2020) ///
	legend(label(1 "Completed high school") label(2 "Some high school") ///
		label(3 "Completed college") label(4 "Some college") label(5 "Only elementary")) scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig03003.eps", replace as(eps)				
graph export "./Drafts/chi-vollrath-fig03003.png", replace as(png) width($width)

publish, name(chi-vollrath-fig03003) title("3.3 Share of 25+ population, by education level")
