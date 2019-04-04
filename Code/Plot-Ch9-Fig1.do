////////////////////////////////////////////////////////
// Figures on physical capital stock
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////
use "./Work/FRED-Annual.dta", clear

tsset year

////////////////////////////////////////////////////////
// Calculate crude profit share of GDP, as in Barkai
////////////////////////////////////////////////////////

// Get inflation rate for private capital price
gen k_price = cost_hist_priv/q_priv
gen k_inf = 100*(ln(k_price)-ln(L5.k_price))/5

// Get depreciation rate
gen k_dep_rate = 100*DCB_cons_capital/cost_hist_priv

// Generate required rate of return on capital 
// Nominal interest rate minus inflation plus deprecation rate
gen R = (moodys_aaa_corp - k_inf + k_dep_rate)/100 // put in decimal terms

// Generate capital share of output
gen k_share = R*cost_hist_priv/(DCB_gross_va - DCB_taxes_prod) 
gen l_share = DCB_comp_employee/(DCB_gross_va - DCB_taxes_prod)
gen profit_share = 1 - k_share - l_share

label variable profit_share "Economic profits"
label variable k_share "Capital costs"

////////////////////////////////////////////////////////
// Produce figure of profit share and capital share over time
////////////////////////////////////////////////////////
keep if year>=1947 & year<=2016

line profit_share year ///
	|| line k_share year ///
	, xtitle("Year") ytitle("Share of corp. business gross value added") ///
	xlabel(1950(10)2010 2016) ylabel(0(0.05)0.4,format(%4.2f)) scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig09001.eps", replace as(eps)			
graph export "./Drafts/chi-vollrath-fig09001.png", replace as(png) width($width)

publish, name(chi-vollrath-fig09001) title("9.1 The share of capital payments and economic profits in GDP over time")
