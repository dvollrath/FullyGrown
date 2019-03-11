////////////////////////////////////////////////////////
// Growth Accounting
////////////////////////////////////////////////////////
// This script does a lot
// 1. Take in annual data, and normalize variables to 1950 values
// 2. Declare a program that does growth accounting between arbitrary years
// 3. Call that program several times to fill in rows of accounting tables
//   a. Accounting for growth in human capital


////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/FRED-Annual.dta", clear

keep if year>1949
tsset year
sort year

// Normalize variables to 1950 for use in accounting and figures
foreach v in  hours_nonfarm  bea_H bea_h  {
	summ `v' if year==1950
	replace `v' = 100*`v'/r(mean)
}

// 10-year growth rates of capital stocks
gen hgrowth = 100*([bea_h/L10.bea_h]^(1/10) - 1) // human capital growth rate

////////////////////////////////////////////////////////
// Produce accounting tables
////////////////////////////////////////////////////////

// Open output text files to hold tables

capture file close j
file open j using "./Drafts/tab_5_1.tex", write replace // Accounting for human capital growth

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
		
	// Calculate locals for growth rates of components of HC - hours, education, experience, and LN ratio
	local Gh = `labor'*(ln(bea_h[`end']) - ln(bea_h[`begin']))/`diff'
	local Ghours = (ln(hours_nonfarm[`end']) - ln(hours_nonfarm[`begin']))/`diff'
	local Ghc = (ln(hc[`end']) - ln(hc[`begin']))/`diff'
	local Gexp = (ln(exp[`end']) - ln(exp[`begin']))/`diff'
	local GLN = (ln(LNratio[`end']) - ln(LNratio[`begin']))/`diff'
	
	// Write those locals to different files, formatted for Latex
	file write j "`first'-`last' &" %9.2f (100*`Gh'/`labor') "&" %9.2f (100*`Ghc') "&" %9.2f (100*`Gexp') "&" %9.2f (100*`GLN') "&" %9.2f (100*`Ghours')  "\\" _n
end	

// Call the program for different time frames, write output to file
calc_growth, first(1950) last(2000) labor(.65) // Entire 20th century

// Insert line breaks to table for formatting purposes
file write j "\\" _n // insert extra line break

// Call by decade of 20th century
calc_growth, first(1950) last(1960) labor(.65) 
calc_growth, first(1960) last(1970) labor(.65)
calc_growth, first(1970) last(1980) labor(.65)
calc_growth, first(1980) last(1990) labor(.65)
calc_growth, first(1990) last(2000) labor(.65)

// Insert line breaks to table for formatting purposes
file write j "\\" _n // insert extra line break

// Call by decade of 21st century
calc_growth, first(2000) last(2016) labor(.65)

file close j
