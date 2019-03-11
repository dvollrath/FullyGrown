////////////////////////////////////////////////////////
// Prepare human capital data
////////////////////////////////////////////////////////

// Source is CPS Table A.1
// https://www.census.gov/data/tables/time-series/demo/educational-attainment/cps-historical-time-series.html
// I've used the raw spreadsheet download (taba-1.xlsx) to create an input CSV file in a useful layout
insheet using "./Data/cps_educ_age.csv", clear names

// Calculate human capital stock for each education group
gen hc_elem_04 = elem_04*exp(3*.10) // assume three years for each
gen hc_elem_58 = elem_58*exp(7*.10) // assume 7 years for each
gen hc_high_13 = high_13*exp(10*.10) // assume 10 years for each
gen hc_high_4  = high_4*exp(12*.10) // assume 12 years for each
gen hc_coll_13 = coll_13*exp(14*.10) // assume 14 years for each
gen hc_coll_4plus = coll_4plus*exp(16*.10) // assume 16 years for each

egen hc = rowtotal(hc_*) // sum hc for each group to get total stock for that age group in a given year

// Calculate education-specific experience terms as a check on baseline calculations
// Reported totals are a little off from the summation of the individual cells, so create own total
gen check_total = elem_04 + elem_58 + high_13 + high_4 + coll_13 + coll_4plus

// Collapse dataset down to yearly totals
collapse (sum) check_total hc elem_04 elem_58 high_13 high_4 coll_13 coll_4plus, by(year)
replace hc = hc/check_total // education stock per person

// Create shares of workers by level of education
gen share_elem_04 = elem_04/check_total
gen share_elem_58 = elem_58/check_total
gen share_high_13 = high_13/check_total
gen share_high_4 = high_4/check_total
gen share_coll_13 = coll_13/check_total
gen share_coll_4plus = coll_4plus/check_total

save "./Work/CPS-hc-exp.dta", replace

// Combine with OECD baseline data on age structure to calculate naive experience 
use "./Work/OECD-pop.dta", clear

keep if sex=="TT" // both sexes
keep if strpos(age,"L5") // selects only 5-year bins
drop if age=="D199L5TT" // drop total population count

gen str_age = substr(age,7,2) // parse age variable for the minimum age 
replace str_age = "85" if str_age=="M8" // replace for the highest group
destring str_age, replace // turn into a numeric

keep if inrange(str_age,20,60) // keep only counts of those in working-age range
gen exp_assumed = str_age + 2 - 20 // Add 2 to get mid-range of age group, subtract 20 for first year of work
gen exp = value*exp(0.05*exp_assumed - .0007*exp_assumed^2)

rename time year

collapse (sum) exp value, by(year)
replace exp = exp/value // calculate per person

save "./Work/OECD-pop-exp.dta", replace

