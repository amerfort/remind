*** |  (C) 2006-2024 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/40_techpol/NPi2018/datainput.gms

Table f40_TechBound(ttot,all_regi,NDC_version,all_te) "Table for all NDC versions with NDC capacity targets (GW)"
$offlisting
$ondelim
$include "./modules/40_techpol/NPi2018/input/f40_NewClimate.cs3r"
$offdelim
$onlisting
;

p40_TechBound(ttot,all_regi,te) = f40_TechBound(ttot,all_regi,"%cm_NDC_version%",te);

** Léa: why specific to 2030?? > umbrella term for various bio technology
p40_ElecBioBound("2030",regi) = p40_TechBound("2030",regi,"bioigcc");

*** In scenarios with 2nd generation bioenergy technology phaseout,
*** switch-off biomass capacity targets of NDC
if (cm_phaseoutBiolc eq 1,
  p40_ElecBioBound(t,regi) = 0;
  );

** Léa: add RE shares?
*** inputs for hard-coded share targets: they only apply if the respective country (or EU28) is a native region in the chosen REMIND setting
*** otherwise, they are not considered in the model
*** to add further targets, include both the respective parameter value below, and extend the equation domain in equations.gms
p40_noncombust_acc_eff(t,iso_regi,te) = 1;!!general efficiency 100% for non-combustible energy
p40_PEgasBound(t,iso_regi)            = 0;
p40_PElowcarbonBound(t,iso_regi)      = 0;       
p40_El_RenShare(t,iso_regi)           = 0;       
p40_CoalBound(t,iso_regi)             = 0;      
p40_FE_RenShare(t,iso_regi)           = 0;

*** EU lower bound on renewable share in gross  final energy (=secondary energy in REMIND)
p40_FE_RenShare(t,"EUR")$(t.val ge 2030)=min(t.val,0.425); !!Renewable Energy Directive EU/2023/2413

display p40_ElecBioBound;
display p40_TechBound; !! good to see if the input is displayed correctly

*** EOF ./modules/40_techpol/NPi2018/datainput.gms


