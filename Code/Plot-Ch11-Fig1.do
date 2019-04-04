////////////////////////////////////////////////////////
// Figure on anti-trust cases
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/FRED-Annual.dta", clear

summ sherman1 if year==1970
gen scale_sherman1 = 100*sherman1/r(mean)
summ sherman2 if year==1970
gen scale_sherman2 = 100*sherman2/r(mean)
summ clayton7 if year==1970
gen scale_clayton7 = 100*clayton7/r(mean)

label variable scale_sherman1 "Restraint of trade"
label variable scale_sherman2 "Monopoly"
label variable scale_clayton7 "Mergers"

drop if year<1970
drop if year>2015

////////////////////////////////////////////////////////
// Produce figure on anti-trust cases
////////////////////////////////////////////////////////

line scale* year, ///
	ylabel(0(50)300) xlabel(1970(5)2015) xtitle("Year") ///
	ytitle("Relative number of cases (1970=100)") scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig11001.eps", replace as(eps)			
graph export "./Drafts/chi-vollrath-fig11001.png", replace as(png) width($width)

publish, name(chi-vollrath-fig11001) title("11.1 Relative number of anti-trust cases over time")
