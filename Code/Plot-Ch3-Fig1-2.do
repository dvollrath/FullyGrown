////////////////////////////////////////////////////////
// Figures on employment and hours worked
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/FRED-Annual.dta", clear

replace emp_women = emp_women/1000
replace emp_men = emp_men/1000

////////////////////////////////////////////////////////
// Produce figures
////////////////////////////////////////////////////////

// Produce figure for employment of men and women
preserve
	drop if year<1945

	line emp_women year, ///
		|| line emp_men year, ///
		ytitle("Millions of employees") xtitle("Year") ///
		ylabel(,format(%3.0fc)) xlabel(1945(10)2015) ///
		legend(label(1 "Women") label(2 "Men")) scheme(vollrath)
	graph export "./Drafts/chi-vollrath-fig03001.eps", replace as(eps)		
	graph export "./Drafts/chi-vollrath-fig03001.png", replace as(png) width($width) 

	publish, name(chi-vollrath-fig03001) title("3.1 Number of employees")
restore

// Produce figure for weekly hours
preserve
	drop if year<1965

	line hours_weekly year, ///
		ytitle("Weekly hours") xtitle("Year") ///
		ylabel(, format(%3.0fc)) xlabel(1965(10)2005 2010 2017) ///
		legend(off) scheme(vollrath)
	graph export "./Drafts/chi-vollrath-fig03002.eps", replace as(eps)			
	graph export "./Drafts/chi-vollrath-fig03002.png", replace as(png) width($width)
	
	publish, name(chi-vollrath-fig03002) title("3.2 Weekly hours worked")
restore

