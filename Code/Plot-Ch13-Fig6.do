////////////////////////////////////////////////////////
// Figures on state personal income
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/FRED-Annual.dta", clear

tsset year

// Get inflation rate for private capital price
gen res_price = cost_hist_struct_res/q_struct_res
gen res_inf = 100*(ln(res_price)-ln(L3.res_price))/3

// Get depreciation rate
gen res_dep_rate = 100*dep_hist_struct_res/cost_hist_struct_res

// Generate required rate of return on capital 
// Nominal interest rate minus inflation plus deprecation rate
gen R = (mort_rate - res_inf + res_dep_rate)/100 // put in decimal terms

gen profit_share = 1 - R*cost_hist_priv/housing_gdp

label variable profit_share "Economic profits"

////////////////////////////////////////////////////////
// Produce figure of housing markup
////////////////////////////////////////////////////////
keep if year>=1986 & year<=2016

line profit_share year, ///
	xlabel(1985(5)2015) ylabel(-.3(.1).4, format(%9.1f)) ///
	yline(0) ///
	xtitle("Year") ytitle("Economic profits as share of housing value added") 
graph export "./Drafts/chi-vollrath-fig13006.png", as(png) replace width(1500)

publish, name(chi-vollrath-fig13006) title("13.6 Economic profits as a share of housing value-added, 1985-2016")
