////////////////////////////////////////////////////////
// Growth Accounting
////////////////////////////////////////////////////////
// This script does a lot
// 1. Take in annual data, and normalize variables to 1950 values
// 2. Declare a program that does growth accounting between arbitrary years
// 3. Call that program several times to fill in rows of accounting tables
//   a. Accounting in per capita terms
//   b. Accounting in per worker terms
//   c. Accounting making adjustment for physical capital as produced output
//   d. Accounting for growth in human capital


////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/FRED-Annual.dta", clear

keep if year>1949
tsset year
sort year

// Normalize variables to 1950 for use in accounting and figures
foreach v in bea_chain_assets gdp_pc hours_nonfarm bea_chain_k bea_H bea_h KY {
	summ `v' if year==1950
	replace `v' = 100*`v'/r(mean)
}

// 10-year growth rates of capital stocks
gen hgrowth = 100*([bea_h/L10.bea_h]^(1/10) - 1) // human capital growth rate
gen kgrowth = 100*([bea_chain_k/L10.bea_chain_k]^(1/10) - 1) // physical capital growth rate

////////////////////////////////////////////////////////
// Produce accounting tables
////////////////////////////////////////////////////////

// Open output text files to hold tables
capture file close h
file open h using "./Drafts/tab_4_1.tex", write replace // Accounting in per capita terms
capture file close i
file open i using "./Drafts/tab_A4_1.tex", write replace // Accounting in per worker terms
capture file close k
file open k using "./Drafts/tab_4_2.tex", write replace // Accounting in per capita - adjusting for capital

// Declare program that calculates the accounting terms and writes to the output files
// - The program is passed the first year and last year to use in accounting, and can be passed labor's share of costs
capture program drop calc_growth
program calc_growth
	syntax [, first(integer 1960) last(integer 2010) labor(real 0.65)] // contains default values

	// Set locals to identify beginning and end years, which correspond to rows in dataset
	summ year
	local end = `last' - r(min) + 1
	local begin = `first' - r(min) + 1
	local diff = `end' - `begin'
	
	// Calculate locals for growth rates of gpd pc, capital pc, HC pc, and residual productivity
	local Gy = (ln(gdp_pc[`end']) - ln(gdp_pc[`begin']))/`diff'
	local Gk = (1-`labor')*(ln(bea_chain_k[`end']) - ln(bea_chain_k[`begin']))/`diff'
	local Gh = `labor'*(ln(bea_h[`end']) - ln(bea_h[`begin']))/`diff'
	local Gprod = `Gy' - `Gk' - `Gh'
		
	// Calculate locals for growth rates of gdp pw, capital pw, HC pw, and residual productivity
	local Gyw = (ln(gdp_pw[`end']) - ln(gdp_pw[`begin']))/`diff'
	local Gkw = (1-`labor')*(ln(bea_chain_k_work[`end']) - ln(bea_chain_k_work[`begin']))/`diff'
	local Ghw = `labor'*(ln(bea_h_work[`end']) - ln(bea_h_work[`begin']))/`diff'
	local Gprod_work = `Gyw' - `Gkw' - `Ghw'	
		
	// Calculate locals for growth rate in capital/output ratio, and alternative residual productivity
	local GKY = ((1-`labor')/`labor')*(ln(KY[`end']) - ln(KY[`begin']))/`diff'
	local Galt = `Gy' - `GKY' - `Gh'/`labor'

	// Write those locals to different files, formatted for Latex
	file write h "`first'-`last' &" %9.2f (100*`Gy') "&" %9.2f (100*`Gk') "&" %9.2f (100*`Gh')  "&" %9.2f (100*`Gprod') "\\" _n	
	file write i "`first'-`last' &" %9.2f (100*`Gyw') "&" %9.2f (100*`Gkw') "&" %9.2f (100*`Ghw')  "&" %9.2f (100*`Gprod_work') "\\" _n
	file write k "`first'-`last' &" %9.2f (100*`Gy') "&" %9.2f (100*`GKY') "&" %9.2f (100*`Gh'/`labor')  "&" %9.2f (100*`Galt') "\\" _n
end	

// Call the program for different time frames, write output to file
calc_growth, first(1950) last(2000) labor(.65) // Entire 20th century

// Insert line breaks to table for formatting purposes
file write h "\\" _n // insert extra line break
file write i "\\" _n // insert extra line break
file write k "\\" _n // insert extra line break

// Call by decade of 20th century
calc_growth, first(1950) last(1960) labor(.65) 
calc_growth, first(1960) last(1970) labor(.65)
calc_growth, first(1970) last(1980) labor(.65)
calc_growth, first(1980) last(1990) labor(.65)
calc_growth, first(1990) last(2000) labor(.65)

// Insert line breaks to table for formatting purposes
file write h "\\" _n // insert extra line break
file write i "\\" _n // insert extra line break
file write k "\\" _n // insert extra line break

// Call by decade of 21st century
calc_growth, first(2000) last(2016) labor(.65)
calc_growth, first(2006) last(2016) labor(.65)

file close h
file close k
file close i
