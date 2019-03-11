////////////////////////////////////////////////////////
// KLEMS calculations on industry level productivity
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Data set up for value-added by industry
////////////////////////////////////////////////////////

use "./Work/KLEMS-shaped.dta", clear

xtset industry year
sort industry year

////////////////////////////////////////////////////////
// Produce figures
////////////////////////////////////////////////////////
keep if year>=1970 & year<=2015

line share_VA year if code=="C" /// manufacturing
	|| line share_VA year if code=="Q" /// health and social work
	|| line share_VA year if code=="M-N" /// professional services
	|| line share_VA year if code=="J", /// information services
	legend(label(1 "Manufacturing") label(2 "Health and social") label(3 "Prof. services") label(4 "Info. and comm.")) ///
	xtitle("Year") ytitle("Share of value added") ///
	xlabel(1970(5)2015) ylabel(0(.05).25, format(%9.2f))
graph export "./Drafts/chi-vollrath-fig07001.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig07001) title("7.1 Value-added share of GDP for selected industries")
	
line VA_QI_index year if code=="C" /// manufacturing
	|| line VA_QI_index year if code=="Q" /// health and social work
	|| line VA_QI_index year if code=="M-N" /// professional services
	|| line VA_QI_index year if code=="J", /// information services
	legend(label(1 "Manufacturing") label(2 "Health and social") label(3 "Prof. services") label(4 "Info. and comm.")) ///
	xtitle("Year") ytitle("Value added (1970=100)") ///
	xlabel(1970(5)2015) ylabel(100(100)1000, format(%9.0f))
graph export "./Drafts/chi-vollrath-fig07002.png", replace as(png) width(1500)	

publish, name(chi-vollrath-fig07002) title("7.2 Value-added, indexed to 1970, for selected industries")

line VA_P_index year if code=="C" /// manufacturing
	|| line VA_P_index year if code=="Q" /// health and social work
	|| line VA_P_index year if code=="M-N" /// professional services
	|| line VA_P_index year if code=="J", /// information services
	legend(label(1 "Manufacturing") label(2 "Health and social") label(3 "Prof. services") label(4 "Info. and comm.")) ///
	xtitle("Year") ytitle("Value added (1970=100)") ///
	xlabel(1970(5)2015) ylabel(100(100)1100, format(%9.0f))
graph export "./Drafts/chi-vollrath-fig07003.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig07003) title("7.3 Price level, indexed to 1970, for selected industries")
