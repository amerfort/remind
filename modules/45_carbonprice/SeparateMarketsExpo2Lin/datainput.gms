*** |  (C) 2006-2022 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/45_carbonprice/SeparateMarketsExpo2Lin/datainput.gms
***----------------------------
*** CO2 Tax level
***----------------------------

*** CO2 tax level is calculated at an initial 5% exponential increase from the 2020 tax level exogenously defined

*GL: tax path in 10^12$/GtC = 1000 $/tC
*** according to Asian Modeling Excercise tax case setup, 30$/t CO2eq in 2020 = 0.110 k$/tC

if(cm_co2_tax_2020 lt 0,
abort "please choose a valid cm_co2_tax_2020"
elseif cm_co2_tax_2020 ge 0,
*** convert tax value from $/t CO2eq to T$/GtC
pm_taxCO2eq("2025",regi)= cm_co2_tax_2020 * sm_DptCO2_2_TDpGtC;
);

pm_taxCO2eq(ttot,regi)$(ttot.val ge 2025 AND ttot.val le cm_peakBudgYr) = pm_taxCO2eq("2025",regi)*cm_co2_tax_growth**(ttot.val-2025);
pm_taxCO2eq(ttot,regi)$(ttot.val gt cm_peakBudgYr) =sum(t$(t.val eq cm_peakBudgYr),pm_taxCO2eq(t,regi)); !! keep taxes constant after cm_peakBudgYr
sm_co2_tax_growth = cm_co2_tax_growth;

pm_taxCDR(ttot,regi)$(ttot.val ge 2025 AND ttot.val le cm_peakBudgYr) = pm_taxCO2eq("2025",regi)*cm_cdr_tax_growth**(ttot.val-2025);
pm_taxCDR(ttot,regi)$(ttot.val gt cm_peakBudgYr) =sum(t$(t.val eq cm_peakBudgYr),pm_taxCDR(t,regi)); !! keep taxes constant after cm_peakBudgYr
*** pm_taxCDR(t,regi) = pm_taxCO2eq(t,regi) * cm_cdr2co2_price_ratio; 
*** set CDR subsidy constant for early ramp up if switch is turned on 
if(cm_cdr_tax_const eq 1, 
    pm_taxCDR(ttot,regi)$(ttot.val ge 2025 AND ttot.val le cm_peakBudgYr) = sum(t$(t.val eq cm_peakBudgYr),pm_taxCDR(t,regi)); 
);
 
*** exogenous CDR subsidy path from cm_cdr_tax_decliningFrom in $/tCO2 in 2025 to 0 in 2100 
if(cm_cdr_tax_decliningFrom gt 0, 
    pm_taxCDR(ttot,regi)$(ttot.val ge 2025 AND ttot.val le 2100) =((-cm_cdr_tax_decliningFrom / 75) * ttot.val + cm_cdr_tax_decliningFrom)/272 ;
);

pm_taxCO2exponential(ttot,regi)$(ttot.val ge 2025) = pm_taxCO2eq("2025",regi)*cm_cdr_tax_growth**(ttot.val-2025);

display pm_taxCDR, pm_taxCO2eq,pm_taxCO2exponential;

*** EOF ./modules/45_carbonprice/SeparateMarketsExpo2Lin/datainput.gms
