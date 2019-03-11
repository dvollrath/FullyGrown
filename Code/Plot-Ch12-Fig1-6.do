////////////////////////////////////////////////////////
// Figures on turnover and level of firms, jobs
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/BDS-Annual.dta", clear

tsset year // set up time series

////////////////////////////////////////////////////////
// Establishment data setup
////////////////////////////////////////////////////////
label variable estabs_entry_rate "Entry rate"
label variable estabs_exit_rate "Exit rate"

replace estabs_entry = estabs_entry/1000
replace estabs_exit = -1*estabs_exit/1000
replace estabs = estabs/1000000
replace firms = firms/1000000
label variable estabs_entry "Entering"
label variable estabs_exit "Exiting"
label variable estabs "Establishments"
label variable firms "Firms"

gen Destabs = D.estabs
gen Destabs_check = estabs_entry + estabs_exit
gen Dfirms = D.firms
label variable Destabs "Net entry"
label variable Destabs_check "Net entry"

////////////////////////////////////////////////////////
// Produce establishment figures
////////////////////////////////////////////////////////

// Produce entry/exit rate figure
line estabs_entry_rate year, ///
	|| line estabs_exit_rate year, ///
	ytitle("Entry/exit as % of existing establishments") xtitle("Year") ///
	ylabel(,format(%9.1f)) xlabel(1975(5)2015)
graph export "./Drafts/chi-vollrath-fig12001.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig12001) title("12.1 Establishment entry and exit rates over time")

// Produce entry/exit growth figure
twoway (bar estabs_entry year, ///
	ytitle("Change in number of establishments (thousands)") xtitle("Year") ///
	ylabel(,format(%9.1f)) xlabel(1975(5)2015) ) ///
	(bar estabs_exit year) ///
	(bar Destabs_check year)
graph export "./Drafts/chi-vollrath-fig12002.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig12002) title("12.2 Growth in entry, exit, and net entry")

// Produce level of establishments figure
line estabs year, ///
	ytitle("Number of establishments (millions)") xtitle("Year") ///
	ylabel(,format(%9.1f)) xlabel(1975(5)2015)
graph export "./Drafts/chi-vollrath-fig12003.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig12003) title("12.3 Number of establishments and firms")

////////////////////////////////////////////////////////
// Job data setup
////////////////////////////////////////////////////////

replace job_creation = job_creation/1000000
replace job_destruction = -1*job_destruction/1000000
replace net_job_creation = net_job_creation/1000000
label variable job_creation "Jobs created"
label variable job_destruction "Jobs destroyed"
label variable net_job_creation "Net jobs created"

replace emp = emp/1000000
label variable emp "Number of jobs"

label variable job_creation_rate "Job creation rate"
label variable job_destruction_rate "Job destruction rate"

////////////////////////////////////////////////////////
// Produce job figures
////////////////////////////////////////////////////////

// Produce growth rate of jobs figure
line job_creation_rate year, ///
	|| line job_destruction_rate year, ///
	ytitle("Creation/destruction as % of existing jobs") xtitle("Year") ///
	ylabel(,format(%9.1f)) xlabel(1975(5)2015)
graph export "./Drafts/chi-vollrath-fig12004.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig12004) title("12.4 Job creation and destruction rates")

// Produce growth in jobs figure
twoway (bar job_creation year, ///
	ytitle("Change in number of jobs (millions)") xtitle("Year") ///
	ylabel(,format(%9.1f)) xlabel(1975(5)2015) ) ///
	(bar job_destruction year) ///
	(bar net_job_creation year)
graph export "./Drafts/chi-vollrath-fig12005.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig12005) title("12.5 Growth in jobs created and destroyed over time")

// Produce level of jobs figure
line emp year, ///
	ytitle("Number of jobs (millions)") xtitle("Year") ///
	ylabel(60(10)120, format(%9.1f)) xlabel(1975(5)2015)
graph export "./Drafts/chi-vollrath-fig12006.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig12006) title("12.6 Total number of jobs over time")
