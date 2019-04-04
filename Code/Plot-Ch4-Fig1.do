////////////////////////////////////////////////////////
// Figures on capital's share of costs
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction, produce figure
////////////////////////////////////////////////////////
use "./Work/BLS_mfp.dta", clear

gen capital_share_costs = nom_comp_capital/(nom_comp_capital+nom_comp_labor)

line capital_share_costs year, ///
	ytitle("Physical capital's share of costs") /// 
	xtitle("Year") ylabel(0(.1)1, format(%9.2f)) xlabel(1950(10)2010 2016) scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig04001.eps", replace as(eps)			
graph export "./Drafts/chi-vollrath-fig04001.png", replace as(png) width($width)

publish, name(chi-vollrath-fig04001) title("4.1 Physical capital's share of costs")
