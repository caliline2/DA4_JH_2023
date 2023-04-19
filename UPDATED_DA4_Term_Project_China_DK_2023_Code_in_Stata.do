
**title: "DA4_Tarrifs_China_Project"
**author: "DAsean Kornegay"
**date: "2023-04-18"

* Call the data from GitHub
insheet using "https://raw.githubusercontent.com/caliline2/DA4_JH_2023/main/China_data_2022.csv", names clear

forvalues i = 4/28 {
    local year = 2024 - `i'
    local varname = "y`year'"
    rename v`i' `varname'
    label variable `varname' "Year `year'"
}


* Add a unique identifier variable to the dataset
gen id = _n

* Reshape the data into long format
reshape long y, i(id) j(Year)

* Make sure the data is sorted by country and year
sort Indicators country Year

rename y Value

drop unit
drop id




encode Indicators, generate(Indicators_num)
drop Indicators 
reshape wide Value, i(country Year) j(Indicators) 

*rename values 1-35 to their respective categories
rename (Value*) (electricity ageing centralgov business eExports gdp gno savings yImports internet inflation immigrant gender laboradvfor lendinterest liter military oil slum interest rural services tfilne ftilin tr1 tr2 Tariffs tr4 tr5 tr6 T3 Exports Imports unemployment fdi)


 
* Filter data for the two periods of interest
keep if Year >= 1997 & Year <= 2021
keep country Year Exports Imports Tariffs fdi electricity ageing business gdp savings internet inflation gender interest unemployment oil

drop if missing(Exports, Imports, Tariffs, fdi, electricity, ageing, business, gdp, savings, internet, inflation, gender, interest, unemployment, oil)

* Create a dummy variable to indicate treatment group (countries that experienced a change in tariffs)
egen min_year = min(Year), by(country)
egen max_year = max(Year), by(country)
gen treatment = (Year <= min_year+3 & Year >= min_year) | (Year >= max_year-3 & Year <= max_year)
drop min_year max_year

* Take the natural logarithm of Exports
gen ln_exports = ln(Exports)


* Convert to panel data frame
egen country_id = group(country)
xtset country_id Year

* Perform difference-in-differences analysis using fixed effects model

xtreg Exports Tariffs treatment i.Year, fe
xtreg Exports Tariffs Imports fdi treatment i.Year, fe
xtreg Exports Tariffs treatment i.Year fdi electricity ageing business gdp savings internet inflation gender interest unemployment oil, fe



*************Absolute value of exports************

*** Fixed Effects Model
* Tarrifs only
xtreg Exports Tariffs treatment i.Year, fe

* Key variables provided by Chinese Bureau for statistics
xtreg Exports Tariffs fdi treatment i.Year, fe

* Enriched with World Bank confounders
xtreg Exports Tariffs treatment i.Year fdi electricity ageing business gdp savings internet inflation gender interest unemployment oil, fe

*** Diff-in-Diff Model 
*Tariffs only*
xtreg Exports Tariffs treatment i.Year, fe

* Key variables provided by Chinese Bureau for statistics
xtreg Exports Tariffs fdi treatment i.Year, fe

* Enriched with World Bank confounders
xtreg Exports Tariffs fdi electricity ageing business gdp savings internet inflation gender interest unemployment oil treatment i.Year, fe

****************Logarithm******************
*** Fixed Effects Model
* Tarrifs only
xtreg ln(Exports) Tariffs treatment i.Year, fe

* Key variables provided by Chinese Bureau for statistics
xtreg ln(Exports) Tariffs fdi treatment i.Year, fe

* Enriched with World Bank confounders
xtreg ln(Exports) Tariffs fdi electricity ageing business gdp savings internet inflation gender interest unemployment oil treatment i.Year, fe

*** Diff-in-Diff Model
* Tarrifs only
xtreg ln(Exports) Tariffs treatment i.Year, fe

* Key variables provided by Chinese Bureau for statistics
xtreg ln(Exports) Tariffs fdi treatment i.Year, fe

* Enriched with World Bank confounders
xtreg ln(Exports) Tariffs fdi electricity ageing business gdp savings internet inflation gender interest unemployment oil treatment i.Year, fe








**************putdocx word doc**************





putdocx begin
putdocx paragraph	
putdocx text ("Difference-in-Differences Analysis Using Fixed Effects Model"),bold


* Perform difference-in-differences analysis using fixed effects model
putdocx paragraph	
putdocx text ("Tariffs only")
xtreg Exports Tariffs treatment i.Year, fe
putdocx table table1=etable

putdocx paragraph	
putdocx text ("Key Variables Provided by Chinese Bureau for Statistics")

xtreg Exports Tariffs Imports fdi treatment i.Year, fe
putdocx table table2=etable

putdocx paragraph	
putdocx text ("Enriched with World Bank Confounders")

xtreg Exports Tariffs treatment i.Year fdi electricity ageing business gdp savings internet inflation gender interest unemployment oil, fe
putdocx table table3=etable


* Absolute value of exports
putdocx paragraph 
putdocx text ("Absolute value of exports"),bold
* Fixed Effects Model

putdocx paragraph
putdocx text ("Fixed Effects Model: Tariffs only")
xtreg Exports Tariffs treatment i.Year, fe
putdocx table table4=etable

putdocx paragraph
putdocx text ("Fixed Effects Model: Key variables provided by Chinese Bureau for statistics")
xtreg Exports Tariffs fdi treatment i.Year, fe
putdocx table table5=etable

putdocx paragraph
putdocx text ("Fixed Effects Model: Enriched with World Bank confounders")
xtreg Exports Tariffs treatment i.Year fdi electricity ageing business gdp savings internet inflation gender interest unemployment oil, fe
putdocx table table6=etable



* Diff-in-Diff Model
putdocx paragraph
putdocx text ("Diff-in-Diff Model: Tariffs only")
xtreg Exports Tariffs treatment i.Year, fe
putdocx table table7=etable

putdocx paragraph
putdocx text ("Diff-in-Diff Model: Key variables provided by Chinese Bureau for statistics")
xtreg Exports Tariffs fdi treatment i.Year, fe
putdocx table table8=etable

putdocx paragraph
putdocx text ("Diff-in-Diff Model: Enriched with World Bank confounders")
xtreg Exports Tariffs fdi electricity ageing business gdp savings internet inflation gender interest unemployment oil treatment i.Year, fe
putdocx table table9=etable


* Logarithm
putdocx paragraph
putdocx text ("Logarithm"),bold
* Fixed Effects Model
putdocx paragraph
putdocx text ("Fixed Effects Model: Tariffs only")
xtreg ln(Exports) Tariffs treatment i.Year, fe
putdocx table table10=etable

putdocx paragraph
putdocx text ("Fixed Effects Model: Key variables provided by Chinese Bureau for statistics")
xtreg ln(Exports) Tariffs fdi treatment i.Year, fe
putdocx table table11=etable

putdocx paragraph
putdocx text ("Fixed Effects Model: Enriched with World Bank confounders")
xtreg ln(Exports) Tariffs fdi electricity ageing business gdp savings internet inflation gender interest unemployment oil treatment i.Year, fe
putdocx table table12=etable

* Diff-in-Diff Model
putdocx paragraph
putdocx text ("Diff-in-Diff Model: Tariffs only")
xtreg ln(Exports) Tariffs treatment i.Year, fe
putdocx table table13=etable

putdocx paragraph
putdocx text ("Diff-in-Diff Model: Key variables provided by Chinese Bureau for statistics")
xtreg ln(Exports) Tariffs fdi treatment i.Year, fe
putdocx table table14=etable

putdocx paragraph
putdocx text ("Diff-in-Diff Model: Enriched with World Bank confounders")
xtreg ln(Exports) Tariffs fdi electricity ageing business gdp savings internet inflation gender interest unemployment oil treatment i.Year, fe
putdocx table table15=etable

putdocx save example7
