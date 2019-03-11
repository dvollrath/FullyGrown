////////////////////////////////////////////////////////
// Figures on physical capital stock
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/FRED-Annual.dta", clear

tsset year

foreach v in equip struct_nonres struct_res ip { // for these four capital types
	gen scale_`v' = cost_`v'/cost_priv // share of total cost
	summ scale_`v' if year==2009 // summ that share in 2009
	gen q_scale_`v' = q_`v'*r(mean) // create scaled quantity index
	gen G10_`v' = 100*(ln(q_`v') - ln(L10.q_`v'))/10
}

label variable q_scale_equip "Equipment"
label variable q_scale_struct_nonres "Firm structures"
label variable q_scale_struct_res "Residential structures"
label variable q_scale_ip "Intellectual Prop."

label variable G10_equip "Equipment"
label variable G10_struct_nonres "Firm structures"
label variable G10_struct_res "Residential structures"
label variable G10_ip "Intellectual Prop."

drop if year<1950

////////////////////////////////////////////////////////
// Produce figures
////////////////////////////////////////////////////////

// Produce figure of capital stocks
line q_scale_equip year ///
	|| line q_scale_struct_nonres year ///
	|| line q_scale_struct_res year ///
	|| line q_scale_ip year, ///
	xtitle("Year") ytitle("Physical capital (total stock in 2009=100)") ///
	xlabel(1950(10)2010 2016) ylabel(,format(%4.0f))
graph export "./Drafts/chi-vollrath-fig03006.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig03006) title("3.6 The level of physical capital, by type")

// Produce figure of capital stocks
line G10_equip year ///
	|| line G10_struct_nonres year ///
	|| line G10_struct_res year ///
	|| line G10_ip year, ///
	xtitle("Year") ytitle("10-year annualized growth rate (%)") ///
	xlabel(1950(10)2010 2016) ylabel(,format(%4.0f))
graph export "./Drafts/chi-vollrath-fig03007.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig03007) title("3.7 The growth of capital, by type")
