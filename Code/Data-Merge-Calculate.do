////////////////////////////////////////////////////////
// Merge datasets and do calculations of common variables
////////////////////////////////////////////////////////
use "./Work/FRED-Extract.dta", clear

// Merge in offline BEA capital data
// This is indexed to year 2009
merge 1:1 year using "./Work/BEA-chain-assets.dta" 
drop _merge

merge 1:1 year using "./Work/BEA-priv-assets.dta"
drop _merge

// Merge in the CPS data on human capital and experience
merge 1:1 year using "./Work/CPS-hc-exp.dta"
drop _merge

// Merge in the OECD derived experience data
merge 1:1 year using "./Work/OECD-pop-exp.dta"
drop _merge

// Merge in the OECD researcher data
merge 1:1 year using "./Work/OECD-res.dta"
drop _merge

// Merge in the CPS data on human capital and experience
merge 1:1 year using "./Work/CENSUS-move.dta"
drop _merge

// Merge in the DOJ data on human capital and experience
merge 1:1 year using "./Work/DOJ-cases.dta"
drop _merge

// Merge in the DOJ data on human capital and experience
merge 1:1 year using "./Work/JF-HC.dta"
drop _merge

////////////////////////////////////////////////////////
// Calculations
////////////////////////////////////////////////////////
gen gdp_pc = gdp/pop // GDP per capita
label variable gdp_pc "Real GDP per capita"

gen bea_chain_k = bea_chain_assets/pop // calculate physical capital per person
label variable bea_chain_k "Physical capital per capita"

gen KY = bea_chain_assets/gdp // calculate capital/output ratio
label variable KY "Capital/output ratio"
// Note that assets are an index, so both of these can only be used to calculate growth rates, not levels

// Extend labor force data prior to 1960
summ lforce16plus if year==1960 // normalize civ labor force in 1960
replace lforce16plus = lforce16plus*100/r(mean)
summ lforce1564 if year==1960 // get actual 15-64 labor force in 1960
replace lforce1564 = r(mean)*lforce16plus/100 if year<1960 // use civ labor force (16plus) to interpolate 15-64 for pre-1960
gen LNratio = lforce1564/pop // labor/population ratio

// Human capital data
gen bea_H = hc*exp*hours_nonfarm*lforce1564 // cacluate bea based hc stock
label variable bea_H "Total human capital stock"
gen bea_h = bea_H/pop // calculate bea hc stock per capita
label variable bea_h "Human capital per capita"
gen jf_hc_qual_pc = jf_hc_qual*lforce1564*hours_nonfarm/pop // calculate Jones/Fernald HC index per capita
label variable jf_hc_qual_pc "Jones/Fernald HC per capita"

// Per worker values
gen bea_chain_k_work = bea_chain_assets/lforce1564 // Physical capital per worker
label variable bea_chain_k_work "Physical capital per worker"
gen bea_h_work = bea_H/lforce1564 // Human capital per worker
label variable bea_h_work "Human capital per worker"
gen gdp_pw = gdp/lforce1564 // GDP per worker
label variable gdp_pw "Real GDP per worker"

keep if year<=2016 // This is year with maximum information - could update to 2017 when data becomes available

save "./Work/FRED-Annual.dta", replace
