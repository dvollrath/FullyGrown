////////////////////////////////////////////////////////
// KLEMS calculations on industry level productivity
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Open file to write results of calculations
////////////////////////////////////////////////////////
capture file close h
file open h using "./Drafts/tab-account-klems.tex", write replace

////////////////////////////////////////////////////////
// Calculate TFP growth for total economy
////////////////////////////////////////////////////////

use "./Work/KLEMS-total-only.dta", clear
gen g15_TFP = (TFPva_I2015-TFPva_I2000)/TFPva_I2000 
gen g15_TFP_rate = (1+g15_TFP)^(1/15)-1 // growth rate of value added

summarize g15_TFP_rate // actual TFP growth rate based on KLEMS from 2000-2015
file write h "Avg. growth rate of TFP VA, 2000-2015, Actual: " (r(mean)) _n

////////////////////////////////////////////////////////
// Calculate TFP growth by industry
////////////////////////////////////////////////////////

use "./Work/KLEMS-shaped.dta", clear

xtset industry year
sort industry year

// Calculate TFP growth for an industry from 2000-2015 (only years with this TFP data)
gen g15_TFPva_I = (TFPva_I - L15.TFPva_I)/L15.TFPva_I 
gen g15_TFPva_I_rate = (1+g15_TFPva_I)^(1/15) - 1 // value added growth

// Generate VA shares for actual, 2000 (lag 15), 1990 (lag 25), 1980 (lag 35)
gen weight = share_VA
gen weight_15 = L15.share_VA 
gen weight_25 = L25.share_VA
gen weight_35 = L35.share_VA

// Produce counterfactual growth in TFP using earlier VA shares
// Sum the TFP growth from 2000-2015, weighted by the given year VA shares
bysort year: egen sum_g15_weight15_TFPva_I = sum(g15_TFPva_I*weight_15)
bysort year: egen sum_g15_weight25_TFPva_I = sum(g15_TFPva_I*weight_25)
bysort year: egen sum_g15_weight35_TFPva_I = sum(g15_TFPva_I*weight_35)

// Turn that growth in to an actual growth rate
gen g15_weight15_TFPva_I_rate = (1+sum_g15_weight15_TFPva_I)^(1/15) - 1
gen g15_weight25_TFPva_I_rate = (1+sum_g15_weight25_TFPva_I)^(1/15) - 1
gen g15_weight35_TFPva_I_rate = (1+sum_g15_weight35_TFPva_I)^(1/15) - 1

// Counter-factual growth rates of TFP from 2000-2015 based on different VA weights
summ g15_weight15_TFPva_I_rate if year==2015
file write h "Avg. growth rate of TFP, 2000-2015, 2000 VA weights: " (r(mean)) _n

summ g15_weight25_TFPva_I_rate if year==2015
file write h "Avg. growth rate of TFP, 2000-2015, 1990 VA weights: " (r(mean)) _n

summ g15_weight35_TFPva_I_rate if year==2015
file write h "Avg. growth rate of TFP, 2000-2015, 1980 VA weights: " (r(mean)) _n


capture file close h

////////////////////////////////////////////////////////
// Write table of industry level data
////////////////////////////////////////////////////////

keep if year==2015 // only need to look backwards from 2015

sort code // sort by the BEA codes
local number = _N // get the number of rows

capture file close f
file open f using "./Drafts/tab_7_1.tex", write replace

forvalues i = 1(1)`number' { // for each of the industries 
	file write f (text[`i']) "&" %9.2f (100*g15_TFPva_I_rate[`i']) "&" %9.2f (100*weight_35[`i']) "&" %9.2f  (100*weight_25[`i'])   "&" %9.2f (100*weight_15[`i']) "&" %9.2f (100*weight[`i']) "\\" _n
}	

capture file close f

