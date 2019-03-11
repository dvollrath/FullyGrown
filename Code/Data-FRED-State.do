////////////////////////////////////////////////////////
// Extract state-level data from FRED
////////////////////////////////////////////////////////

local i = 1 // counter for initializing loop

foreach state in AL	AK	AZ	AR	CA	CO	CT	DE	DC	FL	GA	HI	ID	IL	///
	IN	IA	KS	KY	LA	ME	MT	NE	NV	NH	NJ	NM	NY	NC	ND	OH	OK	///
	OR	MD	MA	MI	MN	MS	MO	PA	RI	SC	SD	TN	TX	UT	VT	VA	WA	///
	WV	WI	WY {
	
	display "State: `state'"
	qui freduse `state'RGSP `state'LF, clear // get state-specific data on real GDP and labor force
	qui drop date
	rename `state'RGSP gdp`state' // rename to gdpWI (for example)
	rename `state'LF lf`state' // rename to lfWI (for example)
	qui gen month = month(daten) 
	keep if month==1 // keep January for annual purposes
	gen rgsppw`state' = 1000000*gdp`state'/lf`state' // calcluate real GDP per worker
	keep daten rgsppw`state' gdp`state' // keep only those three variables
	
	if `i'>1 { // merge with existing data once you have initial file
		qui merge 1:1 daten using "./Work/FRED-State.dta"
	}
	capture drop _merge
	save "./Work/FRED-State.dta", replace // save the merged (or new) data
	local i = `i' + 1
}

gen year = year(daten)

// Reshape data to have state-level rows, with variables indicating variable/year
reshape long rgsppw gdp , i(year) j(state) string // first make year/state rows
drop if gdp==. & rgsppw==. // lose missing observations
drop daten

reshape wide rgsppw gdp, i(state) j(year)  // flip to state rows
drop if state=="DC" // toss because it is an outlier

////////////////////////////////////////////////////////
// Merge with outside data from ALEC
////////////////////////////////////////////////////////
merge 1:1 state using "./Work/ALEC-rank.dta" // pull in ALEC data
rename rank alec_rank // rename ALEC variable
qui gen growth = 100*(ln(rgsppw2016) - ln(rgsppw2012))/4 // calculate four-year growth rate

foreach y in 1997 2007 2012 2016 { // for each year
	qui egen rank`y' = rank(-rgsppw`y') // find rank of GDP per worker for a state
	qui summ rgsppw`y'
	qui replace rgsppw`y' = rgsppw`y'/r(min) // find size of GDP per worker relative to minimum
}

save "./Work/FRED-State.dta", replace
