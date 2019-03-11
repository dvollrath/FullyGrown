////////////////////////////////////////////////////////
// Prepare data on metro areas
////////////////////////////////////////////////////////

// Data for metro area GDP data is from BEA, regional accounts
// https://www.bea.gov/regional/
// Tables are "Real GDP in chained dollars" and "Per capita real GDP"
// Downloaded into raw csv files by me

// Temperature data is from the CDC
// https://wonder.cdc.gov/nasa-nldas.html
// Using their tool, selected county level data, January average temperature

// FIPS to CBSA crosswalk used for merging temperature data is from
// http://www.nber.org/data/cbsa-fips-county-crosswalk.html
// This comes in Stata format

// BLS county level employment statistics
// https://www.bls.gov/lau/ contains separate files by year, which I merged manually

// Wharton regulation index
// http://real.wharton.upenn.edu/~gyourko/landusesurvey.html
// Created csv file from original stata file

// US geographic code crosswalk was created by me from various NBER files
// http://www.nber.org/data/cbsa-msa-fips-ssa-county-crosswalk.html

////////////////////////////////////////////////////////
// Real GDP data
////////////////////////////////////////////////////////
insheet using "./Data/bea_metro_gdp.csv", clear nonames
rename v1 code
rename v2 name

forvalues i = 9(1)24 { // rename data yields for the years they represent
	local y = `i' + 1992
	rename v`i' gdp`y'
}

keep code name gdp* // save data for merging
save "./Work/BEA-metro-gdp.dta", replace

////////////////////////////////////////////////////////
// Real GDP per capita
////////////////////////////////////////////////////////
insheet using "./Data/bea_metro_gdppc.csv", clear nonames

rename v1 code
rename v2 name

forvalues i = 9(1)24 { // rename data fields for years they represent
	local y = `i' + 1992
	rename v`i' gdppc`y'
}

merge 1:1 code using "./Work/BEA-metro-gdp.dta" // merge with GDP data
keep code name gdp* gdppc*

gen label = "" // assign labels to some cities
replace label = "Midland, TX" if code=="33260"
replace label = "San Jose" if code=="41940"
replace label = "Los Angeles" if code=="31080"
replace label = "New York" if code=="35620"
replace label = "Chicago" if code=="16980"
replace label = "Bridgeport, CT" if code=="14860"
replace label = "Riverside, CA" if code=="40140"

destring(code), replace force
save "./Work/BEA-metro-merge.dta", replace // save data for merging

////////////////////////////////////////////////////////
// Employment data 
////////////////////////////////////////////////////////
insheet using "./Data/laucnty.csv", clear // county level data
keep name year lforce emp unemp pop statename countyname fips_text cbsa_code cbsa_title
rename cbsa_code code // for matching
rename fips_text fips // for matching
drop if year==.
reshape wide lforce emp unemp pop, i(fips) j(year) // reorganize to match the bea metro dataset
collapse (sum) lforce* emp* unemp* pop* (first) cbsa_title, by(code) // collapse county data to MSA
drop if code==.

merge 1:1 code using "./Work/BEA-metro-merge.dta" // merge with bea metro data on GDP
keep if _merge==3
drop _merge

save "./Work/BEA-metro-growth.dta", replace

////////////////////////////////////////////////////////
// Temperature data
////////////////////////////////////////////////////////
insheet using "./Data/cdc_temp.csv", name clear // county January temp data
save "./Work/CDC-temp.dta", replace // save for merging

use "./Data/cbsa2fipsxw.dta", clear // from NBER crosswalk site (see above)
gen fips = fipsstatecode + fipscountycode // combine state and county codes
destring fips, replace
rename cbsacode code // to match existing datasets
duplicates drop fips, force // get rid of duplicate records if they exist

merge 1:1 fips using "./Work/CDC-temp.dta" // merge CDC temp data
drop if code==""
drop if temp_avg_jan==.
drop _merge

collapse (mean) temp_avg_jan (first) cbsatitle fipsstatecode, by(code) // collapse across CBSA code 
destring(code), replace force
drop if temp_avg_jan==.

merge 1:1 code using "./Work/BEA-metro-growth.dta" // merge earlier metro data
keep if _merge==3 
drop _merge

save "./Work/BEA-metro-growth.dta", replace

////////////////////////////////////////////////////////
// Wharton Regulation data
////////////////////////////////////////////////////////

// US Geographic code crosswalk - necessary for linking Wharton to Metros
insheet using "./Data/us_geog_code.csv", names clear
gen msa99 = cmsa_1999_code_num
replace msa99 = pmsa_1999_code_num if !missing(pmsa_1999_code_num)
collapse (first) cmsa_1999_code cmsa_1999_title cbsa_2003_code cbsa_2003_title, by(msa99)
save "./Work/US-geog-code.dta", replace

// Wharton Housing Regulation data
insheet using "./Data/Wharton-Regulation.csv", names clear
drop if msa99==9999 // rural areas
keep if msa99==msastate // eliminates a few outliers
save "./Work/Wharton-Regulation.dta", replace

merge m:1 msa99 using "./Work/US-geog-code.dta"
rename cbsa_2003_code code
drop _merge
drop if wrluri==.

// Collapse by CBSA code to get mean regulations across different units within large metro areas
collapse (first) cbsa_2003_title (mean) wrluri lppi spii scii lzai lpai lai dri osi ei sri adi [aweight = weight_metro] , by(code)

merge 1:1 code using "./Work/BEA-metro-growth.dta" // merge earlier metro data
keep if _merge==3 

save "./Work/BEA-metro-final.dta", replace // final metro-level data


