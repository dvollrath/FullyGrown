////////////////////////////////////////////////////////
// KLEMS calculations on industry level productivity
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// Setup and data extraction
////////////////////////////////////////////////////////

// Import data from separate sheets in the KLEMS spreadsheet
// Original source is from http://www.euklems.net
// See the "US Basic 17" and "US Capital 17" files
import excel using "./Data/US_output_17i", clear firstrow sheet("VA") // nominal value added
save "./Work/klems_va.dta", replace
import excel using "./Data/US_output_17i", clear firstrow sheet("GO") // nominal gross output
save "./Work/klems_go.dta", replace
import excel using "./Data/US_output_17i", clear firstrow sheet("II") // int input cost
save "./Work/klems_ii.dta", replace
import excel using "./Data/US_output_17i", clear firstrow sheet("VA_QI") // real value added
save "./Work/klems_vaqi.dta", replace
import excel using "./Data/US_output_17i", clear firstrow sheet("VA_P") // price of value added
save "./Work/klems_vap.dta", replace
import excel using "./Data/US_output_17i", clear firstrow sheet("TFPva_I") // TFP in VA terms
save "./Work/klems_tfpvai.dta", replace
import excel using "./Data/US_output_17i", clear firstrow sheet("TFPgo_I") // TFP in GO terms
save "./Work/klems_tfpgoi.dta", replace
import excel using "./Data/US_output_17i", clear firstrow sheet("H_EMP") // total hours worked
save "./Work/klems_hemp.dta", replace
import excel using "./Data/US_output_17i", clear firstrow sheet("LAB") // nominal labor compensation
save "./Work/klems_lab.dta", replace
import excel using "./Data/US_output_17i", clear firstrow sheet("CAP") // nominal capital compensation
save "./Work/klems_cap.dta", replace
import excel using "./Data/US_output_17i", clear firstrow sheet("LAB_QI") // index of labor input
save "./Work/klems_labqi.dta", replace
import excel using "./Data/US_output_17i", clear firstrow sheet("CAP_QI") // index of capital input
save "./Work/klems_capqi.dta", replace

import excel using "./Data/US_capital_17i", clear firstrow sheet("Kq_GFCF") // real stock of capital assets
save "./Work/klems_kqgfcf.dta", replace

// Merge the various files saved above
merge 1:1 code using "./Work/klems_va.dta"
drop _merge
merge 1:1 code using "./Work/klems_go.dta"
drop _merge
merge 1:1 code using "./Work/klems_ii.dta"
drop _merge
merge 1:1 code using "./Work/klems_vaqi.dta"
drop _merge
merge 1:1 code using "./Work/klems_vap.dta"
drop _merge
merge 1:1 code using "./Work/klems_tfpvai.dta"
drop _merge
merge 1:1 code using "./Work/klems_tfpgoi.dta"
drop _merge
merge 1:1 code using "./Work/klems_hemp.dta"
drop _merge
merge 1:1 code using "./Work/klems_lab.dta"
drop _merge
merge 1:1 code using "./Work/klems_cap.dta"
drop _merge
merge 1:1 code using "./Work/klems_capqi.dta"
drop _merge
merge 1:1 code using "./Work/klems_labqi.dta"
drop _merge

// Save the final merged file for use
save "./Work/KLEMS-raw.dta", replace

// Delete the working files created
rm "./Work/klems_kqgfcf.dta"
rm "./Work/klems_va.dta"
rm "./Work/klems_go.dta"
rm "./Work/klems_ii.dta"
rm "./Work/klems_vaqi.dta"
rm "./Work/klems_vap.dta"
rm "./Work/klems_tfpvai.dta"
rm "./Work/klems_tfpgoi.dta"
rm "./Work/klems_hemp.dta"
rm "./Work/klems_lab.dta"
rm "./Work/klems_cap.dta"
rm "./Work/klems_capqi.dta"
rm "./Work/klems_labqi.dta"

// Save off a file with only the "Total Economy" data
preserve
	keep if code=="TOT" // only total economy row
	save "./Work/KLEMS-total-only.dta", replace
restore

// Set up and save only the rows in the file for "top-level" industries
gen top = 0
replace top = 1 if inlist(code,"A","B","C","D-E","F")
replace top = 1 if inlist(code,"G","H","I","J","K","L")
replace top = 1 if inlist(code,"M-N","O","P","Q","R","S")
keep if top==1

// Create nicer text for use later in the tables
gen text = ""
replace text = "Agriculture" if code=="A"
replace text = "Mining" if code=="B"
replace text = "Manufacturing" if code=="C"
replace text = "Utilities" if code=="D-E"
replace text = "Construction" if code=="F"
replace text = "Wholesale and retail trade" if code=="G"
replace text = "Transportation" if code=="H"
replace text = "Accomodation and food service" if code=="I"
replace text = "Information and communication" if code=="J"
replace text = "Finance and insurance" if code=="K"
replace text = "Real estate" if code=="L"
replace text = "Professional services" if code=="M-N"
replace text = "Public administration" if code=="O"
replace text = "Education" if code=="P"
replace text = "Health and social work" if code=="Q"
replace text = "Arts and entertainment" if code=="R"
replace text = "Other services" if code=="S"

egen industry = group(code) // creates numeric code from string

// Put data in the form of a single row for each industry/year
reshape long Kq_GFCF GO VA VA_P VA_QI II TFPva_I TFPgo_I H_EMP LAB CAP CAP_QI LAB_QI, i(industry) j(year)

xtset industry year // tell Stata that rows are industry/year specific

// Create aggregate values by year
bysort year: egen sum_Kq_GFCF = sum(Kq_GFCF) // capital stock
bysort year: egen sum_H_EMP   = sum(H_EMP) // hours worked
bysort year: egen sum_VA      = sum(VA) // nominal value added
bysort year: egen sum_GO      = sum(GO) // gross output
bysort year: egen sum_VA_QI   = sum(VA_QI) // real value added
bysort year: egen sum_LAB     = sum(LAB) // labor compensation
bysort year: egen sum_CAP     = sum(CAP) // capital compensation

// Create shares of aggregate
gen share_H_EMP = H_EMP/sum_H_EMP // hours worked
gen share_Kq_GFCF = Kq_GFCF/sum_Kq_GFCF // capital stock
gen share_VA = VA/sum_VA // nominal value added
gen share_VA_QI = VA_QI/sum_VA_QI // real value added
gen share_LAB = LAB/sum_LAB // labor compensation
gen share_CAP = CAP/sum_CAP // capital compensation
gen share_GO  = GO/sum_GO // gross output
gen share_Domar = GO/sum_VA // Domar weights (gross output of an industry/ aggreg. VA)

// Create VA_QI index series
gen VA_QI_1970 = VA_QI if year==1970
bysort industry: egen VA_QI_base = mean(VA_QI_1970)
gen VA_QI_index = 100*VA_QI/VA_QI_base

gen VA_P_1970 = VA_P if year==1970
bysort industry: egen VA_P_base = mean(VA_P_1970)
gen VA_P_index = 100*VA_P/VA_P_base

save "./Work/KLEMS-shaped.dta", replace // save for future use

