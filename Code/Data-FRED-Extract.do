////////////////////////////////////////////////////////
// Extract data series from FRED database
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Extract weekly FRED mortgage series
////////////////////////////////////////////////////////
freduse AAA MORTGAGE30US, clear // call FRED for this series
rename MORTGAGE30US mort_rate // rename to something useful
rename AAA moodys_aaa_corp // rename to useful

gen year = year(daten) // extract year
collapse (first) moodys_aaa_corp (firstnm) mort_rate, by(year) // grab only first mortgage rate in year
save "./Work/FRED-Mortgage.dta", replace // save for merging

////////////////////////////////////////////////////////
// Extract annual FRED series for use
////////////////////////////////////////////////////////

// Use the "freduse" package to extract directly from FRED database
freduse ///
B230RC0A052NBEA /// population
PRS85006023 /// nonfarm business weekly hours (2009=100)
PRS84006023 /// business weekly hours (2009=100)
PAYEMS /// all employees: total nonfarm payrolls, SA
EMRATIO /// employment population ratio, SA
CLF16OV /// civilian labor force 16+
LNS11000060 /// civilian labor force level 25-54
LFAC64TTUSA647N /// active population 15-64
GDPCA /// real GDP
IMPGSCA /// real imports
EXPGSCA /// real exports
GPDICA /// real investment
PCECCA /// real consumption
GCECA /// real govt spending
LNS12000001 /// male employment (000s)
LNS12000002 /// female employment (000s)
AWHNONAG /// weekly hours
A2009C1A027NBEA /// housing value added
K1R53101ES000 /// housing stock
CSUSHPISA /// Case-Shiller price index for housing
NNBCFNA027N /// non-financial, non-corporate net investment
NCBFNEA027N /// non-financial, corporate net investment
NCBOSNA027N /// non-financial, corporate operating surplus
NNBBOSA027N /// non-financial, non-corporate operating surplus
NCBEILQ027S /// non-financial, corporate equity
TLBSNNCB /// non-financial, corporate liabilities
TFAABSNNCB /// non-financial, corporate financial assets
IABSNNCB /// non-financial, corporate inventories
TTAATASHCBSHNNCB /// non-financial, corporate historical value non-financial assets
SPDYNCBRTINUSA /// crude birth rate
SPDYNTFRTINUSA /// total fertility rate
PCESVA /// Personal consumption expend services
PCECA /// Personal consumption expend total
PCNDA /// Personal consumption expend non-durables
PCDGA /// Personal consumption expend durables
A451RC1A027NBEA /// gross value added of domestic corp business
W321RC1A027NBEA /// taxes on prod and imports less subsidies, domestic corp business
A438RC1A027NBEA /// consumption of fixed capital, domestic corp business
A442RC1A027NBEA /// domestic corp business - compensation of employees
Y001RX1A020NBEA /// domestic investment, fixed investment, IP, real
, clear

// The codes for series are meaningless, so rename to something useful
// Basic aggregates 
rename B230RC0A052NBEA pop 
rename PRS85006023 hours_nonfarm
rename PRS84006023 hours_business
rename PAYEMS Lpayroll
rename GDPCA gdp
rename LFAC64TTUSA647N lforce1564
rename LNS11000060 lforce2554
rename CLF16OV lforce16plus
// Trade variables
rename IMPGSCA imports
rename EXPGSCA exports
rename GPDICA investment
rename PCECCA consumption
rename GCECA government
// Employment numbers
rename LNS12000001 emp_men
rename LNS12000002 emp_women
rename AWHNONAG hours_weekly
// Housing numbers
rename A2009C1A027NBEA housing_gdp
rename K1R53101ES000 housing_stock
rename CSUSHPISA caseshiller_price
// Investment numbers
rename NNBCFNA027N NFNB_a_net_inv
rename NCBFNEA027N NFCB_a_net_inv
rename NCBOSNA027N NFCB_a_oper_surplus
rename NNBBOSA027N NFNB_a_oper_surplus
rename NCBEILQ027S NFCB_q_equities
rename TLBSNNCB NFCB_q_liab
rename TFAABSNNCB NFCB_q_fin_asset
rename IABSNNCB NFCB_q_inv
rename TTAATASHCBSHNNCB NFCB_q_hist_nonfin_asset
// Fertility data
rename SPDYNCBRTINUSA wbcbr
rename SPDYNTFRTINUSA wbtfr
// PCE data
rename PCESVA pce_nom_services
rename PCECA pce_nom_total
rename PCNDA pce_nom_nondurable
rename PCDGA pce_nom_durable
// Domestic corp business data
rename A451RC1A027NBEA DCB_gross_va
rename W321RC1A027NBEA DCB_taxes_prod
rename A438RC1A027NBEA DCB_cons_capital
rename A442RC1A027NBEA DCB_comp_employee

rename Y001RX1A020NBEA real_ip_invest

// Label variables
label variable pop "Population"
label variable hours_nonfarm "Hours worked, non-farm sector"
label variable hours_business "Hours worked, business sector"
label variable Lpayroll "Payroll count of workers"
label variable gdp "Real GDP"
label variable lforce1564 "Labor force, ages 15-64"
label variable lforce2554 "Labor force, ages 25-54"
label variable lforce16plus "Labor force, ages 16+"
label variable imports "Real imports"
label variable exports "Real exports"
label variable investment "Real investment"
label variable consumption "Real consumption"
label variable government "Real govt spending"
label variable emp_men "Employees, male"
label variable emp_women "Employees, female"
label variable hours_weekly "Avg. weekly hours"
label variable housing_gdp "Real housing value added"
label variable housing_stock "Stock of housing assets"
label variable caseshiller_price "Case/Shiller house price index"
label variable NFNB_a_net_inv "Non-fin, non-corp net investment"
label variable NFCB_a_net_inv "Non-fin, corp net investment"
label variable NFCB_a_oper_surplus "Non-fin, corp operating surplus"
label variable NFNB_a_oper_surplus "Non-fin, non-corp operating surplus"
label variable NFCB_q_equities "Non-fin, corp equities"
label variable NFCB_q_liab "Non-fin, corp liabilities"
label variable NFCB_q_inv "Non-fin, corp inventories"
label variable NFCB_q_hist_nonfin_asset "Non-fin, corp historical asset value"
label variable wbcbr "Crude birth rate"
label variable wbtfr "Total fert. rate"
label variable pce_nom_services "Pers Cons Expend, Services"
label variable pce_nom_total "Pers Cons Expend, Total"
label variable pce_nom_nondurable "Pers Cons Expend, Non-durables"
label variable pce_nom_durable "Pers Cons Expend, Durables"
label variable DCB_gross_va "Domestic corp. gross value-added"
label variable DCB_taxes_prod "Domestic corp. taxes on production"
label variable DCB_cons_capital "Domestic corp. consump fixed capital"
label variable DCB_comp_employee "Domestic corp. compensation employees"
label variable real_ip_invest "Real IP investment"

// Pull the annual observations
gen year = year(daten) // get annual data
gen month = month(daten)
drop if year<1947 // get rid of unused years
keep if month==1 // use the January numbers for annual data

// Merge in the annual mortgage data extracted above
merge 1:1 year using "./Work/FRED-Mortgage.dta"
drop _merge

save "./Work/FRED-Extract.dta", replace

