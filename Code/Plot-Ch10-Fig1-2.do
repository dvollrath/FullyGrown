////////////////////////////////////////////////////////
// Figures for net investment rates
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Set up and data extraction
////////////////////////////////////////////////////////

use "./Work/FRED-Annual.dta", clear
		
gen NFCB_net_inv_rate = NFCB_a_net_inv/NFCB_a_oper_surplus
gen NFNB_net_inv_rate = NFNB_a_net_inv/NFNB_a_oper_surplus
label variable NFNB_net_inv_rate "Noncorporate"
label variable NFCB_net_inv_rate "Corporate"

gen NFCB_q_q = (NFCB_q_equities/1000 + NFCB_q_liab - NFCB_q_fin_asset - NFCB_q_inv)/NFCB_q_hist_nonfin_asset
gen NFCB_q_simple = (NFCB_q_equities/1000)/NFCB_q_hist_nonfin_asset
label variable NFCB_q_simple "Simple"
label variable NFCB_q_q "Complex"

gen TOTAL_a_net_inv = NFCB_a_net_inv + NFNB_a_net_inv
gen TOTAL_a_oper_surplus = NFCB_a_oper_surplus + NFNB_a_oper_surplus
gen TOTAL_net_inv_rate = TOTAL_a_net_inv/TOTAL_a_oper_surplus
label variable TOTAL_net_inv_rate "All businesses"

drop if year<1950

////////////////////////////////////////////////////////
// Produce figures
////////////////////////////////////////////////////////

// Produce figure on net investment rates
line TOTAL_net_inv_rate NFNB_net_inv_rate NFCB_net_inv_rate year, ///
	ylabel(-.1(.1).6, format(%9.1f)) ytitle("Net investment rate") ///
	xlabel(1950(10)2010 2016) xtitle("Year") scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig10001.eps", replace as(eps)			
graph export "./Drafts/chi-vollrath-fig10001.png", replace as(png) width($width)

publish, name(chi-vollrath-fig10001) title("10.1 Net investment rate over time")

// Produce figure on Q ratios
line NFCB_q_q NFCB_q_simple year if year<2017, ///
	xlabel(1950(10)2010 2016) xtitle("Year") ytitle("Q ratio") ///
	ylabel(,format(%9.1f)) scheme(vollrath)
graph export "./Drafts/chi-vollrath-fig10002.eps", replace as(eps)			
graph export "./Drafts/chi-vollrath-fig10002.png", replace as(png) width($width)	

publish, name(chi-vollrath-fig10002) title("10.2 Q ratio over time")
