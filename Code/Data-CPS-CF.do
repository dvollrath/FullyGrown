////////////////////////////////////////////////////////
// Do counter-factual human capital calculation
////////////////////////////////////////////////////////

// Source is CPS Table A.1
// https://www.census.gov/data/tables/time-series/demo/educational-attainment/cps-historical-time-series.html
// I've used the raw spreadsheet download (taba-1.xlsx) to create an input CSV file in a useful layout
insheet using "./Data/cps_educ_age.csv", clear names

keep if year==2015


// Create counter-factual distribution of number of people by education
gen cf_elem_04 = elem_04
gen cf_elem_58 = elem_58
gen cf_high_13 = high_13
gen cf_high_4  = high_4
gen cf_coll_13 = coll_13
gen cf_coll_4plus = coll_4plus

replace cf_elem_04 = 0 if age=="25-34"
replace cf_elem_58 = 0 if age=="25-34"
replace cf_high_13 = 0 if age=="25-34"
replace cf_high_4 = 0.20*total if age=="25-34"
replace cf_coll_13 = 0.15*total if age=="25-34"
replace cf_coll_4plus = 0.65*total if age=="25-34"

// Calculate total years of schooling
gen years = (3*elem_04 + 7*elem_58 + 10*high_13 + 12*high_4 + 14*coll_13 + 16*coll_4plus)/total
gen cf_years = (3*cf_elem_04 + 7*cf_elem_58 + 10*cf_high_13 + 12*cf_high_4 + 14*cf_coll_13 + 16*cf_coll_4plus)/total

summ years if age=="25-34"
di "Actual average years of schooling: " (r(mean))
summ cf_years if age=="25-34"
di "Counter-factual years of schooling: " (r(mean))

// Calculate actual human capital stock for each education group
gen hc_elem_04 = elem_04*exp(3*.10) // assume three years for each
gen hc_elem_58 = elem_58*exp(7*.10) // assume 7 years for each
gen hc_high_13 = high_13*exp(10*.10) // assume 10 years for each
gen hc_high_4  = high_4*exp(12*.10) // assume 12 years for each
gen hc_coll_13 = coll_13*exp(14*.10) // assume 14 years for each
gen hc_coll_4plus = coll_4plus*exp(16*.10) // assume 16 years for each

egen hc = rowtotal(hc_*) // sum hc for each group to get total stock for that age group in a given year

// Calculate counter-factual human capital stock for each education group
gen cf_hc_elem_04 = cf_elem_04*exp(3*.10) // assume three years for each
gen cf_hc_elem_58 = cf_elem_58*exp(7*.10) // assume 7 years for each
gen cf_hc_high_13 = cf_high_13*exp(10*.10) // assume 10 years for each
gen cf_hc_high_4  = cf_high_4*exp(12*.10) // assume 12 years for each
gen cf_hc_coll_13 = cf_coll_13*exp(14*.10) // assume 14 years for each
gen cf_hc_coll_4plus = cf_coll_4plus*exp(16*.10) // assume 16 years for each

egen cf_hc = rowtotal(cf_hc_*) // sum hc for each group to get total stock for that age group in a given year

collapse (sum) hc cf_hc years cf_years total, by(year)

gen hc_stock_pc = hc/total
gen cf_hc_stock_pc = cf_hc/total

summ hc_stock_pc // 
local hc_pc = r(mean)
di "Actual value of human capital per capita: " (`hc_pc') 
summ cf_hc_stock_pc
local cf_hc_pc = r(mean)
di "Counter-factual value of human capital per capita: " (`cf_hc_pc')
di ""
di "Percent increase in HC per capita from CF: " (`cf_hc_pc'/`hc_pc')
