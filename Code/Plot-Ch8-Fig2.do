////////////////////////////////////////////////////////
// Create figure on relative prices
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/FRED-Annual.dta", clear

gen share_pce_services = pce_nom_services/pce_nom_total
gen share_pce_durables = pce_nom_durable/pce_nom_total
gen share_pce_nondurables = pce_nom_nondurable/pce_nom_total

label variable share_pce_services "Services"
label variable share_pce_durables "Durable goods"
label variable share_pce_nondurables "Nondurable goods"

drop if year<1950

////////////////////////////////////////////////////////
// Produce figure of relative prices
////////////////////////////////////////////////////////
line share_pce_services year ///
	|| line share_pce_durables year ///
	|| line share_pce_nondurables year ///
	, xlabel(1950(10)2010 2017) ylabel(0(0.1)0.8,format(%9.1f)) ///
	ytitle("Share of total personal expenditures") xtitle("Year") ///
	legend(cols(1) colfirst textfirst) scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig08002.eps", replace as(eps)			
graph export "./Drafts/chi-vollrath-fig08002.png", width($width) replace as(png)

publish, name(chi-vollrath-fig08002) title("8.2 The share of goods and services in real GDP over time")
