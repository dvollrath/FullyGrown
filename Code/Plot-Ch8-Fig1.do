////////////////////////////////////////////////////////
// Create figure on relative prices
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/BEA-pce-prices.dta", clear

gen keep=0 // gen variable to keep only selected industries
replace keep=1 if line==5 // Vehicles
replace keep=1 if line==8 // Furnishings and household durables
replace keep=1 if line==30 // Clothing and footwear
replace keep=1 if line==60 // Health care
replace keep=1 if line==101 // Higher education
replace keep=1 if line==82 // Food service
replace keep=1 if line==50 // Housing

keep if keep==1 // keep just those industries
drop keep

reshape long y, i(line) j(year) // reshape to be by line/year
rename y price

levelsof line, local(levels) // get all values of "line" (products)
foreach l of local levels { // normalize the price index to 1980=100
	summ price if line==`l' & year==1980
	replace price = 100*price/r(mean) if line==`l'
}
drop category

reshape wide price, i(year) j(line) // reshape to be by year only
label variable price5 "Vehicles"
label variable price8 "Household durables"
label variable price30 "Clothing"
label variable price60 "Healthcare"
label variable price101 "Higher education"
label variable price82 "Food service"
label variable price50 "Housing"

drop if year<1980 // keep the figure manageable

////////////////////////////////////////////////////////
// Produce figure of relative prices
////////////////////////////////////////////////////////
line price101 year ///
	|| line price60 year ///
	|| line price82 year ///
	|| line price5 year ///
	|| line price30 year, clcolor(black) ///
	|| line price8 year, ///
	ylabel(100(100)1200) xlabel(1980(5)2015) ///
	ytitle("Price index (1980=100)") xtitle("Year") ///
	legend(cols(1) colfirst textfirst)
graph export "./Drafts/chi-vollrath-fig08001.png", replace as(png) width(1500)

publish, name(chi-vollrath-fig08001) title("8.1 Price indices by type of product")
