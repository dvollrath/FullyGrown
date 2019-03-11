////////////////////////////////////////////////////////
// Intake raw data - document sources
////////////////////////////////////////////////////////

// Fertility data from Mitchell (2013) Historical Statistics
// Downloaded from https://ourworldindata.org/fertility-rate 
insheet using "./Data/mitchell_cbr.csv", names clear
label variable cbr "Crude birth rate"
label variable tfr "Total fertility rate"
save "./Work/MITCHELL-CBR.dta", replace

// Business Dynamic Statistics, Census Bureau
// Downloaded from https://www2.census.gov/ces/bds/estab/bds_e_all_release.csv
// Contains data on establishment and job turnover
insheet using "./Data/bds_e_all_release.csv", names clear
rename year2 year // for consistency
save "./Work/BDS-Annual.dta", replace

// OECD population data with age groups by year
// Downloaded from https://stats.oecd.org/Index.aspx?DataSetCode=POP_PROJ
// Contains data on 5-year age groups
insheet using "./Data/OECD_pop.csv", names clear
keep if location=="USA"
save "./Work/OECD-pop.dta", replace

// OECD research worker data
// Downloaded from https://stats.oecd.org/Index.aspx?DataSetCode=MSTI_PUB#
insheet using "./Data/OECD_res.csv", names clear
save "./Work/OECD-res.dta", replace

// BEA index of real aggregate capital assets (chained prices)
// Does not appear to be on FRED
// Downloaded from bea.gov fixed asset table 1.2, line 2 ("Fixed Assets")
insheet using "./Data/bea_chain_assets.csv", names clear
save "./Work/BEA-chain-assets.dta", replace

// BEA index of capital by type
// Downloaded from bea.gov fixed asset tables 2.1 (current cost) and 2.2 (quantity index) and 2.3 (historical cost)
insheet using "./Data/bea_priv_assets.csv", names clear
save "./Work/BEA-priv-assets.dta", replace

// BEA PCE price indices by type of product
// Downloaded from bea.gov table 2.4.4
insheet using "./Data/bea_pce_prices.csv", names clear
save "./Work/BEA-pce-prices.dta", replace

// BLS Multifactor productivity data
// https://www.bls.gov/mfp/#tables
// Use the historical MFP industry tables (SIC linked to NAICS)
// Private business sector (PG) table
insheet using "./Data/bls_mfp.csv", names clear
save "./Work/BLS_mfp.dta", replace

// Census data on firms size
// https://www.census.gov/programs-surveys/susb/data/tables.html
// The data is reported in separate sheets, by year, and I've cut/paste
// this to create the input csv file
insheet using "./Data/census_firms.csv", names clear
save "./Work/CENSUS-firms.dta", replace

// Census data on mobility
// https://www.census.gov/data/tables/time-series/demo/geographic-mobility/historic.html
// Used table A.1 - pulled data from this spreadsheet to create this input data
insheet using "./Data/census_move.csv", names clear
label variable movers "Number of movers"
label variable move_rate "Percent of pop. that moves"
save "./Work/CENSUS-move.dta", replace

// DOJ data on anti-trust cases
// https://www.justice.gov/atr/division-operations
// Manually combine the various decadal workload statistics into a CSV file
insheet using "./Data/doj_cases.csv", names clear
label variable sherman1 "Sherman section 1 cases"
label variable sherman2 "Sherman section 2 cases"
label variable clayton7 "Clayton section 7"
save "./Work/DOJ-cases.dta", replace

// Maddison long-run GDP data
// https://www.rug.nl/ggdc/historicaldevelopment/maddison/releases/maddison-project-database-2018
insheet using "./Data/maddison.csv", names clear
keep if countrycode=="USA"
label variable cgdppc "Real GDP pc, multiple benchmarks"
label variable rgdpnapc "Real GDP pc, 2011 US benchmark"
save "./Work/MADDISON-gdp.dta", replace

// Piketty inequality data
// Downloaded from original Piketty website (now available from Quandl)
// https://www.quandl.com/data/PIKETTY-Thomas-Piketty
// Taken from Chapter 8, table S8.3, put into a CSV by me
// See spreadsheets in Piketty2014TechnicalAppendix folder
insheet using "./Data/piketty.csv", names clear
save "./Work/PIKETTY-shares.dta", replace

// Piketty, Saez, Zucman data on distributional accounts
// http://gabriel-zucman.eu/usdina/
// See PSZ2017MainData.xlsx
// I pulled individual data to a csv for use here
insheet using "./Data/psz_distacct.csv", names clear
save "./Work/PSZ-dist-acct.dta", replace

// ALEC state rankings
// https://www.alec.org
// See their 2017-RSPS-index document for raw numbers
// Put into CSV by me
insheet using "./Data/alec_rank2012.csv", names clear
save "./Work/ALEC-rank.dta", replace

// Jones/Fernald (2014) human capital index
// http://web.stanford.edu/~chadj/papers.html
// From spreadsheet, copied into csv by me
insheet using "./Data/jonesfernaldHC.csv", names clear
save "./Work/JF-HC.dta", replace
