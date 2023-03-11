cd "E:\UK_BIOBANK_PROJECT\UKB_PAPER1_RACESESDEM\DATA"



***************************DATA MANAGEMENT********************************************


//STEP 1: GENERATE AGE, TIMES, SEX, RACE AND OTHER DEMGRAPHICS VARIABLE//E


**s_40000_2_0 is missing**
**n_40007_2_0 is missing
**n_100295_0_0 is missing**
**n_20023_0_0 n_399_0_0 n_400_0_0 are missing: cognitive tests**
****s_33_0_0**: date of birth is missing

use n_eid n_31_0_0  n_21022_0_0  n_34_0_0 n_52_0_0 n_6138_0_0 n_189_0_0 s_53_0_0 s_40000_0_0 s_40000_1_0  n_21000_0_0 n_709_0_0 n_738_0_0   n_1239_0_0 n_3456_0_0 n_22507_0_0  n_1279_0_0 n_1269_0_0 n_20162_0_0 n_1558_0_0 n_100022_0_0 n_981_0_0 ///
n_971_0_0 n_894_0_0 n_884_0_0 n_914_0_0 n_904_0_0 n_1289_0_0 n_1299_0_0 n_1309_0_0 n_1319_0_0 n_1329_0_0 n_1339_0_0 n_1349_0_0 n_1359_0_0 n_1369_0_0 n_1379_0_0 n_1389_0_0 n_6144_0_0 ///
n_6144_0_1 n_6144_0_2 n_6144_0_3 n_10855_0_0 n_1408_0_0 n_1418_0_0 n_1428_0_0 n_1438_0_0 n_1448_0_0 n_2654_0_0   n_1458_0_0 n_1468_0_0 ///
n_1478_0_0 n_1478_0_0 n_1548_0_0 n_30890_0_0 n_30070_0_0 n_1031_0_0 n_6160_0_* n_2110_0_0 n_135_0_0 n_134_0_0 n_2178_0_0 n_21001_0_0 n_21001_0_0 n_48_0_0 n_49_0_0 n_30600_0_0 n_30710_0_0 n_30690_0_0 n_30760_0_0 n_30750_0_0 n_102_0_0 n_4080_0_0 n_4079_0_0 ///
n_21022_0_0 n_20009_0_* n_20002_0_* s_41202_0_* n_34_0_0 n_52_0_0 s_53_0_0 s_40000_*_0  n_40007_*_0 s_42018_0_0 s_42020_0_0   n_20003_0_* n_20004_0_* n_6153_0_0 n_130* n_21022_0_0 n_20009_0_* n_20002_0_* s_41202_0_* n_34_0_0 n_52_0_0 s_53_0_0 s_40000_*_0  n_40007_*_0  s_42018_0_0 s_42020_0_0 n_2443_0_0 n_1160_0_0  n_2443_0_0 n_1160_0_0  using LARGESTDATASETUKB.dta 


**merge with s_40000_*_0  n_40007_*_0 s_42018_0_0 s_42020_0_0 s_33_0_0 n_20023_0_0 n_399_0_0 n_400_0_0

save SMALLERDATASETUKB, replace


capture log close
capture log using "E:\UK_BIOBANK_PROJECT\UKB_PAPER1_RACESESDEM\OUTPUT\DATA_MANAGEMENT.smcl"




**Format time-series variables using the do file**
use SMALLERDATASETUKB,clear
sort n_eid
capture drop _merge
save, replace

use Missingpaper1_participantrev,clear
sort n_eid
capture drop _merge
save, replace 

use SMALLERDATASETUKB,clear


merge n_eid using Missingpaper1_participantrev

save SMALLERDATASETUKBfin, replace

capture gen double ts_53_0_0 = date(s_53_0_0,"DMY")
capture format ts_53_0_0 %td
capture label variable ts_53_0_0 "Date of attending assessment centre"

capture gen double ts_40000_0_0 = date(s_40000_0_0,"DMY")
capture format ts_40000_0_0 %td
capture label variable ts_40000_0_0 "Date of death"

capture gen double ts_40000_1_0 = date(s_40000_1_0,"DMY")
capture format ts_40000_1_0 %td
capture label variable ts_40000_1_0 "Date of death"


format %18.14f n_40007_0_0
format %18.14f n_40007_1_0

capture gen double ts_42018_0_0 = date(s_42018_0_0,"DMY")
capture format ts_42018_0_0 %td
capture label variable ts_42018_0_0 "Date of all cause dementia report"

capture gen double ts_42020_0_0 = date(s_42020_0_0,"DMY")
capture format ts_42020_0_0 %td
capture label variable ts_42020_0_0 "Date of alzheimers disease report"


save, replace



su ts_53_0_0 ts_40000_0_0 ts_40000_1_0 ts_42018_0_0 ts_42020_0_0

save, replace


**************************DEMOGRAPHICS, SES: Fix this section in all papers*********************************************

use SMALLERDATASETUKBfin, clear


keep n_eid n_31_0_0 n_21022_0_0  n_34_0_0 n_52_0_0 n_6138_0_0 n_189_0_0 ts_53_0_0 ts_40000_0_0 ts_40000_1_0 n_21000_0_0 n_709_0_0 n_738_0_0 n_1239_0_0 

save DEMOG_SES_UKB,replace



**Exogenous variables: age (@@fix baseline age), gender, household size**


*Sex*
capture drop sex
gen sex=n_31_0_0 
recode sex 0=2 1=1


*Age*
capture drop Age
gen Age=n_21022_0_0 

*Years of Birth*
capture drop birthyear
gen birthyear=n_34_0_0 

*Month of Birth*
capture drop birthmonth
gen birthmonth=n_52_0_0 

*Date of birth*
capture drop birthdate
gen birthdate=mdy(birthmonth,14,birthyear)

*Baseline Cohort Start Date*
capture drop startdate
gen startdate=ts_53_0_0 
format startdate %d

*Baseline age**
capture drop baselineage
gen baselineage=(startdate-birthdate)/365.25




**Household size**
label var n_709_0_0	"Number in household"

capture drop householdsize
gen householdsize=n_709_0_0
label var householdsize "Number of household members"

**-1	Do not know
**-3	Prefer not to answer

recode householdsize (-1=. ) (-3=.)

*Ethnicity*
capture drop ethnicity

gen ethnicity = 1 if inlist(n_21000_0_0,1,1001,1002,1003) 
replace ethnicity = 2 if inlist(n_21000_0_0,3,3001,3002,3003,3004)
replace ethnicity = 3 if inlist(n_21000_0_0,5)
replace ethnicity = 4 if inlist(n_21000_0_0,4,4001,4002,4003)
replace ethnicity = 5 if inlist(n_21000_0_0,2,6,2001,2002,2003,2004)
replace ethnicity = 6 if ethnicity ==.

label var ethnicity "ethnic group"
label define ethnicityL 1 "white" 2 "south asian" 3 "east asian" 4 "black" 5 "other/mixed" 6 "unknown"
label values ethnicity ethnicityL

capture drop ethnicity2
gen ethnicity2=.
replace ethnicity2=ethnicity
recode ethnicity2 (1=0) (4=1) (2=2) (3=3) (5=3) (6=3) 

label var ethnicity2 "ethnic grouping 2"
label define ethnicityL2 0 "white" 1 "black" 2 "south asian" 3 "other" 
label values ethnicity2 ethnicityL2

capture drop RACE_ETHN=ethnicity2

capture drop NonWhite
gen NonWhite=.
replace NonWhite=ethnicity2
recode NonWhite (0=0) (1=1) (2=1) (3=1)

label var NonWhite "ethnic grouping 3"
label define ethnicityL3 0 "white" 1 "Non-White"  
label values NonWhite ethnicityL3


******************DATES*******************************************

*Years of Birth*
capture drop birthyear
gen  birthyear=n_34_0_0 

*Month of Birth*
capture drop birthmonth
gen  birthmonth=n_52_0_0 

*Death Date*
capture drop deathdate
gen deathdate = ts_40000_0_0 
replace deathdate =  ts_40000_1_0 if deathdate ==.
format deathdate %d
label var deathdate "date of death"

*Baseline Cohort Start Date*
capture drop startdate
gen startdate=ts_53_0_0 

********************************SES******************************

*Education, qualification*
capture rename n_6138_0_0 education
recode education -7=. -3=. 7=. 
label define educationL 0 "none" 1 "College/University" 2 "A/AS Levels/Equivalent" 3 "O Levels/GCSEs/Equivalent" 4 "CSEs/Equivalent" 5 "NVQ/HND/HNC/Equivalent" 6 "Other professional qual" 7 "Unknown"
label values education educationL

capture drop educationbr
gen educationbr=.
replace educationbr=0 if (education==0 | education==4 | education==5 | education==6)
replace educationbr=1 if (education==2 | education==3)
replace educationbr=2 if education==1

*Deprivation*
capture rename n_189_0_0 townsend


**Household income before tax**
label var n_738_0_0	"Average total household income before tax"

**1	Less than 18,000
**2	18,000 to 30,999
**3	31,000 to 51,999
**4	52,000 to 100,000
**5	Greater than 100,000
**-1	Do not know
**-3	Prefer not to answer



capture drop householdincome
gen householdincome=n_738_0_0	
label var householdincome "Average total household income before tax"

recode householdincome (-1=.) (-3=.)


save, replace


//STEP 2: GENERATE SES VARIABLE//


**SES: educationbr, householdincome, townsend

capture drop zeducationbr 
egen zeducationbr=std(educationbr)

capture drop zhouseholdincome 
egen zhouseholdincome=std(householdincome)

capture drop ztownsend
egen ztownsend=std(townsend)

capture drop ztownsendinv
gen ztownsendinv=ztownsend*-1

capture drop rowmissSES
egen rowmissSES=rowmiss(zeducationbr zhouseholdincome ztownsendinv)

tab rowmissSES

capture drop SES
egen SES=rowmean(zeducationbr zhouseholdincome ztownsendinv) if rowmissSES<=1


save, replace  


//STEP 3: GENERATE LIFESTYLE VARIABLES: SMOKING, ALCOHOL, AND PA//

use SMALLERDATASETUKBfin,clear

keep n_eid n_1239_0_0 n_3456_0_0 n_22507_0_0  n_1279_0_0 n_1269_0_0 n_20162_0_0 n_1558_0_0 n_100022_0_0 n_981_0_0 ///
n_971_0_0 n_894_0_0 n_884_0_0 n_914_0_0 n_904_0_0 n_21022_0_0

save LIFESTYLENODIET_UKB,replace

capture drop Age
gen Age=n_21022_0_0 


*Current Smoking Status*
capture drop smoking
gen smoking = 0 if  n_1239_0_0 == 0 | n_1239_0_0 == -3
replace smoking = 1 if n_22507_0_0 != . 
replace smoking = 2 if n_1239_0_0 == 1 | n_1239_0_0 == 2
label var smoking "current smoking status"
label define smokingL 0 "never smoker" 1 "ex-smoker" 2 "current smoker"
label values smoking smokingL
recode smoking .=0

*Cigarettes Per Day*
capture drop cigperday
gen cigperday = n_3456_0_0 if smoking == 2    //missing values exist - consider imputation
replace cigperday = 0 if smoking == 0 | smoking == 1
replace cigperday = . if cigperday < 0
label var cigperday "if smoking, number of cig per day"

*Aged Stopped Smoking Cigarettes*
capture drop stopsmoke agestop
gen stopsmoke = Age - n_22507_0_0 
label var stopsmoke "intermediate var: baseline age - age stopped smoking"
gen agestop = 1 if stopsmoke < 5
replace agestop = 2 if stopsmoke >= 5 & stopsmoke <= 10
replace agestop = 3 if stopsmoke > 10 & stopsmoke !=.
label var agestop "how long ago did you quit smoking in years"
label define stopL 1 "< 5 years" 2 " between 5-10 years" 3 "> 10 years"
label values agestop stopL  

*Combine Current Smoking with Ex-smoking duration for protective effects*
capture drop smokingstatus
gen smokingstatus = 0 if smoking == 2
replace smokingstatus = agestop if smokingstatus ==.
replace smokingstatus = 4 if smoking == 0
label var smokingstatus "complete smoking status"
label define statusL 0 "current smoker" 1 "ex-smoker < 5 years" 2 "ex-smoker between 5-10 years" 3 "ex-smoker > 10 years" 4 "never smoker"
label values smokingstatus statusL
recode smokingstatus .=4

*Environmental tobacco smoke*
capture drop etsmoke
replace n_1279_0_0 = . if n_1279_0_0 < 0
replace n_1269_0_0  = . if n_1269_0_0 < 0
order n_1279_0_0, after(n_1269_0_0)
egen ets = rowtotal(n_1269_0_0-n_1279_0_0)
gen etsmoke = ets
label var etsmoke "environmental tobacco exposures (hours per week)"

**Pack-years of smoking**
capture drop packyearssmoke
gen packyearssmoke=n_20162_0_0
replace packyearssmoke=0 if smoking==0



**Use smokingstatus, etsmoke and packyearssmoke as measured variables for SMOKING LATENT VARIABLE OR AVERAGE Z-SCORE*****


capture drop zsmokingstatus zetsmoke zpackyearssmoke
egen zsmokingstatus=std(smokingstatus)
egen zetsmoke=std(etsmoke)
egen zpackyearssmoke=std(packyearssmoke)


capture drop rowmissSMOKE
egen rowmissSMOKE=rowmiss(zsmokingstatus zetsmoke zpackyearssmoke)

tab rowmissSMOKE

egen SMOKE=rmean(zsmokingstatus zetsmoke zpackyearssmoke) if rowmissSMOKE<=1


save, replace


************************************ALCOHOL: fixed code 6 to missing***************************************************
*https://biobank.ctsu.ox.ac.uk/crystal/label.cgi?id=100098

*Usual Alcohol intake*

capture drop alcohol
gen alcohol = 0 if  n_1558_0_0 == 6
replace alcohol = 1 if  n_1558_0_0 == 5
replace alcohol = 2 if  n_1558_0_0 == 4
replace alcohol = 3 if  n_1558_0_0 == 3
replace alcohol = 4 if  n_1558_0_0 == 2
replace alcohol = 5 if  n_1558_0_0 == 1
replace alcohol = . if  n_1558_0_0 == -3
replace alcohol = . if  n_1558_0_0 ==.
label var alcohol "alcohol intake frequency"
label define alcoholL 0 "never" 1 "special occasions only" 2 "1-3 times per month" 3 "1-3 times per week" 4 "3-4 times per week" 5 "daily or almost daily" 
label values alcohol alcoholL



**use alcohol ALCOHOL LATENT VARIABLE OR AVERAGE Z-SCORE***

egen zalcohol=std(alcohol)

capture drop ALCOHOL
gen ALCOHOL=zalcohol

*************************************PHYSICAL ACTIVITY**********************************************************************

***https://biobank.ctsu.ox.ac.uk/crystal/search.cgi?wot=0&srch=physical+activity&sta0=on&sta1=on&sta2=on&sta3=on&str0=on&str3=on&fit0=on&fit10=on&fit20=on&fit30=on&fvt11=on&fvt21=on&fvt22=on&fvt31=on&fvt41=on&fvt51=on&fvt61=on&fvt101=on


*Physical activity - use the IPAQ scoring guidelines*

*Walking MET-min/week - use median time of each category*
capture drop walkperday
gen walkperday = 7.5 if n_981_0_0 == 1
replace walkperday = 22.5 if n_981_0_0 == 2
replace walkperday = 45 if n_981_0_0 == 3
replace walkperday = 75 if n_981_0_0 == 4
replace walkperday = 105 if n_981_0_0 == 5
replace walkperday = 150 if n_981_0_0 == 6
replace walkperday = 210 if n_981_0_0 == 7
label var walkperday "walking minutes per day"

*Frequency of Walking (no days per week) - use median time of each category*
capture drop walkperweek
gen walkperweek = 0.25 if n_971_0_0 == 1
replace walkperweek = 0.625 if n_971_0_0 == 2
replace walkperweek = 1 if n_971_0_0 == 3
replace walkperweek = 2.5 if n_971_0_0 == 4
replace walkperweek = 4.5 if n_971_0_0 == 5
replace walkperweek = 7 if n_971_0_0 == 6
label var walkperweek "walking days per week"

*Calculate walking MET-min/week*
capture drop walkMETmin
gen walkMETmin = 3.3 * walkperday * walkperweek
label var walkMETmin "MET-min per week walking"

*Moderate exercise MET-min/week*
capture drop modperday
gen modperday = n_894_0_0 if n_894_0_0 >= 0
label var modperday "moderate exercise minutes per day"

*Frequency of moderate exercise (no days per week)*
capture drop modperweek
gen modperweek =  n_884_0_0 if  n_884_0_0 >= 0
label var modperweek "moderate exercise days per week"

*Calculate moderate exercise MET-min/week*
capture drop modMETmin
gen modMETmin = 4.0 * modperday * modperweek
label var modMETmin "MET-min per week moderate exercise"

*Vigorous exercise MET-min/week*
capture drop vigperday
gen vigperday = n_914_0_0 if n_914_0_0 >= 0
label var vigperday "vigorous exercise minutes per day"

*Frequency of vigorous exercise (no days per week)*
capture drop vigperweek
gen vigperweek = n_904_0_0 if n_904_0_0 >= 0
label var vigperweek "vigorous exercise days per week"

*Calculate vigorous exercise MET-min/week*
capture drop vigMETmin
gen vigMETmin = 8.0 * vigperday * vigperweek
label var vigMETmin "MET-min per week vigorous exercise"

****Calculate TOTAL MET-min per week*******
capture drop METmin
order modMETmin, before(vigMETmin)
order walkMETmin, before(modMETmin)
egen METmin = rowtotal(walkMETmin modMETmin vigMETmin)
label var METmin "MET-min per week total exercise" // missing values exist - consider imputation

////USE METmin as the PA measure, z-scored////

capture drop PA
egen PA=std(METmin)

save, replace


//STEP 4: GENERATE LIFESTYLE VARIABLES: DIET//

use SMALLERDATASETUKBfin,clear

keep n_eid n_1289_0_0 n_1299_0_0 n_1309_0_0 n_1319_0_0 n_1329_0_0 n_1339_0_0 n_1349_0_0 n_1359_0_0 n_1369_0_0 n_1379_0_0 n_1389_0_0 n_6144_0_0 ///
n_6144_0_1 n_6144_0_2 n_6144_0_3 n_10855_0_0 n_1408_0_0 n_1418_0_0 n_2654_0_0 n_1428_0_0 n_1438_0_0 n_1448_0_0 n_1458_0_0 n_1468_0_0 ///
n_1478_0_0 n_1478_0_0 n_1548_0_0  n_6144_0_0

**(ALL ITEMS UNDER THE DIET CATEGORY)
**URL: https://biobank.ndph.ox.ac.uk/showcase/label.cgi?id=100052


save LIFESTYLEDIET_UKB,replace

**https://www.ahajournals.org/doi/10.1161/CIRCULATIONAHA.115.018585#d3e341


**********Recoding as missing data fields and -10 as 0.50***********************
**-10:<1 --> to 0.5 throughout
**-3: prefer not to answer
**-1: do not know

capture drop n_1289_0_0r n_1299_0_0r n_1309_0_0r n_1319_0_0r n_1329_0_0r n_1339_0_0r n_1349_0_0r n_1359_0_0r n_1369_0_0r n_1379_0_0r n_1389_0_0r 
capture drop n_6144_0_0r n_6144_0_1r n_6144_0_2r n_6144_0_3r n_10855_0_0r n_1408_0_0r n_1418_0_0r n_2654_0_0r n_1438_0_0r n_1448_0_0r n_1458_0_0r 
capture drop n_1468_0_0r n_1478_0_0r n_1478_0_0r


foreach x of varlist n_1289_0_0 n_1299_0_0 n_1309_0_0 n_1319_0_0 n_1329_0_0 n_1339_0_0 n_1349_0_0 n_1359_0_0 n_1369_0_0 n_1379_0_0 n_1389_0_0 n_6144_0_0 n_6144_0_1 n_6144_0_2 n_6144_0_3 n_10855_0_0 n_1408_0_0 n_1418_0_0 n_2654_0_0 n_1428_0_0 n_1438_0_0 n_1448_0_0 n_1458_0_0 n_1468_0_0 n_1478_0_0  {
	gen `x'r=`x'
}

foreach y of varlist n_1289_0_0r n_1299_0_0r n_1309_0_0r n_1319_0_0r n_1329_0_0r n_1339_0_0r n_1349_0_0r n_1359_0_0r n_1369_0_0r n_1379_0_0r n_1389_0_0r n_6144_0_0r n_6144_0_1r n_6144_0_2r n_6144_0_3r n_10855_0_0r n_1408_0_0r n_1418_0_0r n_1428_0_0r n_2654_0_0r n_1438_0_0r n_1448_0_0r n_1458_0_0r n_1468_0_0r n_1478_0_0r n_1478_0_0r {
replace `y'=. if `y'==-3 | `y'==-1 | `y'==-5
}



foreach y of varlist n_1289_0_0r n_1299_0_0r n_1309_0_0r n_1319_0_0r n_1329_0_0r n_1339_0_0r n_1349_0_0r n_1359_0_0r n_1369_0_0r n_1379_0_0r n_1389_0_0r  n_6144_0_0r n_6144_0_1r n_6144_0_2r n_6144_0_3r n_10855_0_0r n_1408_0_0r n_1418_0_0r n_2654_0_0r n_1438_0_0r n_1448_0_0r n_1458_0_0r n_1468_0_0r n_1478_0_0r n_1478_0_0r {
replace `y'=0.5 if `y'==-10 
}

save, replace


/////////////////////FRUITS COMPONENT //////////////////////


**Servings per day for all fruits**

**1 piece of dried fruit (e.g. apricot)~=2.5 TBSP, 1 TBSP= 0.063 cups; ½ cup of dried fruit (1 serving) is 3 pieces of dried fruit.

**1 medium sized fruit is one serving.

capture drop allfruits
gen allfruits=.
replace allfruits=(n_1309_0_0r+(n_1319_0_0r/3))

**>=3 servings per day**


capture drop allfruits_component1
gen allfruits_component1=.
replace allfruits_component1=1 if allfruits>=3 & allfruits~=.
replace allfruits_component1=0 if allfruits_component1~=1 & allfruits~=.



//////////////////////VEGETABLES COMPONENT/////////////////////

**Servings per day for all vegetables**

**1 cup of raw leafy vegetables is 16 TBSP. ½ cup of cooked or non-leafy raw vegetables is 8 TBSP. 

**1 serving of raw leafy/non-leafy vegetables is ~=12 TBSP; 1 serving of cooked vegetables is ~=8 TBSP


capture drop allvegs
gen allvegs=.
replace allvegs=((n_1289_0_0r/8))+((n_1299_0_0r/12))

**>=3 servings per day**

capture drop allvegs_component2
gen allvegs_component2=.
replace allvegs_component2=1 if allvegs>=3 & allvegs~=.
replace allvegs_component2=0 if allvegs_component2~=1 & allvegs~=.

//////////////WHOLE GRAINS///////////////////////////////////

**Bread intake, slices/week: n_1438_0_0r
**Type of bread: n_1448_0_0r	

**1 White
**2	Brown
**3	Wholemeal or wholegrain
**4	Other type of bread


**Cereal intake, bowls/week: n_1458_0_0r


**Cereal type:n_1448_0_0r

**1	Bran cereal (e.g. All Bran, Branflakes)
**2	Biscuit cereal (e.g. Weetabix)
**3	Oat cereal (e.g. Ready Brek, porridge)
**4	Muesli
**5	Other (e.g. Cornflakes, Frosties)

capture drop wholegrain_bread
gen wholegrain_bread=.
replace wholegrain_bread=n_1438_0_0r if n_1448_0_0r==3
replace wholegrain_bread=0 if n_1448_0_0r~=3 & n_1438_0_0r~=.

capture drop wholegrain_bread_day
gen wholegrain_bread_day=.
replace wholegrain_bread_day=wholegrain_bread/7 

capture drop wholegrain_cereal
gen wholegrain_cereal=.
replace wholegrain_cereal=n_1458_0_0r if n_1448_0_0r==1 | n_1448_0_0r==2 | n_1448_0_0r==3 | n_1448_0_0r==4
replace wholegrain_cereal=0 if n_1448_0_0r~=3 & n_1458_0_0r~=.

capture drop wholegrain_cereal_day
gen wholegrain_cereal_day=.
replace wholegrain_cereal_day=wholegrain_cereal/7 


capture drop wholegrain
gen wholegrain=(wholegrain_bread_day+wholegrain_cereal_day)

capture drop wholegrain_component3
gen wholegrain_component3=.
replace wholegrain_component3=1 if wholegrain>=3 & wholegrain~=.
replace wholegrain_component3=0 if wholegrain_component3~=1 & wholegrain~=.

//////////////FISH/SHELLFISH////////////////////////////////

**non-oily fish, times/week: n_1329_0_0r
**oily fish, times/week: n_1339_0_0r


**0	Never
**1	Less than once a week
**2	Once a week
**3	2-4 times a week
**4	5-6 times a week
**5	Once or more daily


capture drop fish
gen fish=n_1329_0_0r+n_1339_0_0r

capture drop fish_component4
gen fish_component4=.
replace fish_component4=1 if fish>=3 & fish~=.
replace fish_component4=0 if fish_component4~=1 & fish~=.

//////////////DAIRY PRODUCTS///////////////////////////////


**Never eat eggs, dairy, weat, sugar: n_6144_0_0r
**1	Eggs or foods containing eggs
**2	Dairy products
**3	Wheat products
**4	Sugar or foods/drinks containing sugar
**5	I eat all of the above

**Cheese intake: n_1408_0_0r**
**0	Never
**1	Less than once a week
**2	Once a week
**3	2-4 times a week
**4	5-6 times a week
**5	Once or more daily

**Milk type used: n_1418_0_0r
**1	Full cream
**2	Semi-skimmed
**3	Skimmed
**4	Soya
**5	Other type of milk
**6	Never/rarely have milk


capture drop dairy_component5
gen dairy_component5=.
replace dairy_component5=1 if n_6144_0_0r~=2 & n_1408_0_0r==5 & n_1418_0_0r~=6 |n_6144_0_1r~=2 & n_1408_0_0r==5 & n_1418_0_0r~=6 |n_6144_0_2r~=2 & n_1408_0_0r==5 & n_1418_0_0r~=6 | n_6144_0_3r~=2 & n_1408_0_0r==5 & n_1418_0_0r~=6
replace dairy_component5=0 if dairy_component5~=1 & n_6144_0_0r~=. & n_1408_0_0r~=. & n_1418_0_0r~=.

/////////////VEGETABLE OILS//////////////////////////////

**Other types of non-butter spreads: n_2654_0_0r**

**4	Soft (tub) margarine
**5	Hard (block) margarine
**6	Olive oil based spread (eg: Bertolli)
**7	Polyunsaturated/sunflower oil based spread (eg: Flora)
**2	Flora Pro-Active or Benecol
**8	Other low or reduced fat spread
**9	Other type of spread/margarine


capture drop vegoil_component6
gen vegoil_component6=.
replace vegoil_component6=1 if n_2654_0_0r==6 | n_2654_0_0r==7 
replace vegoil_component6=0 if vegoil_component6~=1 


////////////REFINED GRAINS, STARCHES, ADDED SUGARS///////

**Bread intake, slices/week: n_1438_0_0r
**Type of bread: n_1448_0_0r	

**1 White
**2	Brown
**3	wholemeal or wholegrain
**4	Other type of bread


**Cereal intake, bowls/week: n_1458_0_0r


**Cereal type:n_1448_0_0r

**1	Bran cereal (e.g. All Bran, Branflakes)
**2	Biscuit cereal (e.g. Weetabix)
**3	Oat cereal (e.g. Ready Brek, porridge)
**4	Muesli
**5	Other (e.g. Cornflakes, Frosties)

capture drop nonwholegrain_bread
gen nonwholegrain_bread=.
replace nonwholegrain_bread=n_1438_0_0r if n_1448_0_0r~=3 & n_1448_0_0r~=.
replace nonwholegrain_bread=0 if n_1448_0_0r==3 & n_1438_0_0r~=.

capture drop nonwholegrain_bread_day
gen nonwholegrain_bread_day=.
replace nonwholegrain_bread_day=nonwholegrain_bread/7 

capture drop nonwholegrain_cereal
gen nonwholegrain_cereal=.
replace nonwholegrain_cereal=n_1458_0_0r if n_1448_0_0r==5 
replace nonwholegrain_cereal=0 if n_1448_0_0r~=5 & n_1458_0_0r~=.

capture drop nonwholegrain_cereal_day
gen nonwholegrain_cereal_day=.
replace nonwholegrain_cereal_day=nonwholegrain_cereal/7 


capture drop nonwholegrain
gen nonwholegrain=nonwholegrain_bread_day+nonwholegrain_cereal_day

capture drop nonwholegrain_component7
gen nonwholegrain_component7=.
replace nonwholegrain_component7=1 if nonwholegrain<1.5 & nonwholegrain~=.
replace nonwholegrain_component7=0 if nonwholegrain_component7~=1 & nonwholegrain~=.



////////////PROCESSED MEATS/////////////////////////////



**0	Never
**1	Less than once a week
**2	Once a week
**3	2-4 times a week
**4	5-6 times a week
**5	Once or more daily

capture drop processed_meat
gen processed_meat=n_1349_0_0r

capture drop processed_meat_component8
gen processed_meat_component8=.
replace processed_meat_component8=1 if processed_meat==0 | processed_meat==1 | processed_meat==2
replace processed_meat_component8=0 if processed_meat==3 | processed_meat==4 | processed_meat==5



///////////UNPROCESSED RED MEATS/////////////////////////////

**Poultry: n_1359_0_0r: White meat
**Lamb/mutton: n_1379_0_0r: Red meat
**Beef:n_1369_0_0r: Red meat
**Pork:n_1389_0_0r: Red meat


**0	Never
**1	Less than once a week
**2	Once a week
**3	2-4 times a week
**4	5-6 times a week
**5	Once or more daily

capture drop unprocessed_meats
gen unprocessed_meats=(n_1369_0_0r+n_1379_0_0r+n_1389_0_0r)


capture drop unprocessed_meats_component9
gen unprocessed_meats_component9=.
replace unprocessed_meats_component9=1 if unprocessed_meats<3 & unprocessed_meats~=.
replace unprocessed_meats_component9=0 if unprocessed_meats_component9~=1 & unprocessed_meats~=.


////////////INDUSTRIAL TRANS FAT////////////////////////////

**Type of spread: n_1428_0_0r

**1	Butter/spreadable butter
**3	Other type of spread/margarine
**0	Never/rarely use spread
**2	Flora Pro-Active/Benecol

**Non-butter spread type details: n_2654_0_0r

**4	Soft (tub) margarine
**5	Hard (block) margarine
**6	Olive oil based spread (eg: Bertolli)
**7	Polyunsaturated/sunflower oil based spread (eg: Flora)
**2	Flora Pro-Active or Benecol
**8	Other low or reduced fat spread
**9	Other type of spread/margarine

capture drop transfat_component10
gen transfat_component10=.
replace transfat_component10=1 if n_1428_0_0r==0
replace transfat_component10=0 if transfat_component10~=1 & n_1428_0_0r~=.


////////////SUGAR SWEETENDED BEVERAGES/////////////////////

**Never eat eggs, dairy, wheat, sugar: n_6144_0_0r
**1	Eggs or foods containing eggs
**2	Dairy products
**3	Wheat products
**4	Sugar or foods/drinks containing sugar
**5	I eat all of the above

capture drop sugar_bev_component11
gen sugar_bev_component11=.
replace sugar_bev_component11=0 if n_6144_0_0r==4 & n_6144_0_0r~=. | n_6144_0_0r==4 & n_6144_0_1r~=. | n_6144_0_0r==4 & n_6144_0_2r~=. | n_6144_0_0r==4 & n_6144_0_3r~=.
replace sugar_bev_component11=1 if sugar_bev_component11~=0 & n_6144_0_0r~=.


////////////SODIUM////////////////////////////////////////

**Salt added to food: n_1478_0_0r
**1	Never/rarely
**2	Sometimes
**3	Usually
**4	Always


capture drop sodium_component12
gen sodium_component12=.
replace sodium_component12=1 if n_1478_0_0r==1 | n_1478_0_0r==2
replace sodium_component12=0 if sodium_component12~=1 & n_1478_0_0r~=.

//////////HDI_TOTALSCORE//////////////////

capture drop rowmissHDI
egen rowmissHDI=rowmiss(allfruits_component1 allvegs_component2 wholegrain_component3 fish_component4 dairy_component5 vegoil_component6 nonwholegrain_component7 processed_meat_component8 unprocessed_meats_component9 transfat_component10 sugar_bev_component11 sodium_component12)

tab rowmissHDI


capture drop HDI_TOTALSCORE
egen HDI_TOTALSCORE=rowmean(allfruits_component1 allvegs_component2 wholegrain_component3 fish_component4 dairy_component5 vegoil_component6 nonwholegrain_component7 processed_meat_component8 unprocessed_meats_component9 transfat_component10 sugar_bev_component11 sodium_component12) if rowmissHDI<=6

replace HDI_TOTALSCORE=HDI_TOTALSCORE*12 

////////////////////

///////////////////RECODING FOR VARIATION IN DIET///////////////


**Coding	Meaning
**1	Never/rarely
**2	Sometimes
**3	Often
**-1	Do not know
**-3	Prefer not to answer

capture drop DIET_VARIATION
gen DIET_VARIATION=.
replace DIET_VARIATION=1 if n_1548_0_0==1
replace DIET_VARIATION=2 if n_1548_0_0==2
replace DIET_VARIATION=3 if n_1548_0_0==3
replace DIET_VARIATION=. if n_1548_0_0==-1
replace DIET_VARIATION=. if n_1548_0_0==-3


////////////DIET z-score///////////////

capture drop zHDI_TOTALSCORE
egen zHDI_TOTALSCORE=std(HDI_TOTALSCORE)

capture drop zDIET_VARIATION
egen zDIET_VARIATION=std(DIET_VARIATION)


capture drop DIET
gen DIET=zHDI_TOTALSCORE

save, replace


//STEP 5: GENERATE LIFESTYLE VARIABLES: NUTR//


use SMALLERDATASETUKBfin,clear

keep n_eid n_30890_0_0 n_30070_0_0

save NUTR_UKB,replace

label var n_30890_0_0 "Vitamin D"
label var n_30070_0_0 "Red blood cell (erythrocyte) distribution width"


pwcorr n_30890_0_0 n_30070_0_0, sig

capture drop vitamind
gen vitamind= n_30890_0_0 


capture drop rdw
gen rdw=n_30070_0_0 

capture drop zvitamind
egen zvitamind=std(vitamind)

capture drop zrdw
egen zrdw=std(rdw)

capture drop zrdwinv
gen zrdwinv=zrdw*-1

capture drop rowmissNUTR
egen rowmissNUTR=rowmiss(zvitamind zrdwinv)

tab rowmissNUTR

capture drop NUTR
egen NUTR=rmean(zvitamind zrdwinv) if rowmissNUTR<=1

save, replace


//STEP 6: GENERATE LIFESTYLE VARIABLES: SS//

use SMALLERDATASETUKBfin,clear

keep n_eid n_1031_0_0 n_6160_0_* n_2110_0_0

save SS_UKB,replace


//////////SOCIAL SUPPORT VARIABLE 1/////

**Frequency of friend/family visits**
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=1031

**WP11 How often do you visit friends or family
**or have them visit you?
**SELECT one of 9 from
**1 : Almost daily
**2 : 2-4 times a week
**3 : About once a week
**4 : About once a month
**5 : Once every few months
**6 : Never or almost never
**7 : No friends/family
**outside household
**-1 : Do not know
**-3 : Prefer not to answer
**Goto WP12 If this varies, please give an average of
**how often you visit or have had visits in
**the last year. Include meeting with
**friends or family in environments
**outside of the home such as in the park,
**at a sports field, at a restaurant or pub.

capture drop SS_friendsfamily
gen SS_friendsfamily=.
replace SS_friendsfamily=n_1031_0_0
replace SS_friendsfamily=. if n_1031_0_0==-1
replace SS_friendsfamily=. if n_1031_0_0==-3
recode SS_friendsfamily (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1)


///SOCIAL SUPPORT VARIABLE 2/////
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=6160

**WP12 Which of the following do you attend once
**a week or more often?
**(You can select more than one)
**TOGGLE of 7 choices
**1 : Sports club or gym
**2 : Pub or social club
**3 : Religious group
**4 : Adult education class
**5 : Other group activity
**-7 : None of the above
**-3 : Prefer not to answer
**Require ≥1
**choices
**-7 : is exclusive
**-3 : is exclusive
**Goto WP12A If this varies, please think about
**activities in the last year.


capture drop SS_leisuresocial1
gen SS_leisuresocial1=.
replace SS_leisuresocial1=1 if n_6160_0_0~=. & n_6160_0_0~=-7 & n_6160_0_0~=-3
replace SS_leisuresocial1=0 if SS_leisuresocial1~=1 & n_6160_0_0~=-7 & n_6160_0_0~=-3


capture drop SS_leisuresocial2
gen SS_leisuresocial2=.
replace SS_leisuresocial2=1 if n_6160_0_1~=. & n_6160_0_1~=-7 & n_6160_0_1~=-3
replace SS_leisuresocial2=0 if SS_leisuresocial2~=1 & n_6160_0_1~=-7 & n_6160_0_1~=-3


capture drop SS_leisuresocial3
gen SS_leisuresocial3=.
replace SS_leisuresocial3=1 if n_6160_0_2~=. & n_6160_0_2~=-7 & n_6160_0_2~=-3
replace SS_leisuresocial3=0 if SS_leisuresocial3~=1 & n_6160_0_2~=-7 & n_6160_0_2~=-3


capture drop SS_leisuresocial4
gen SS_leisuresocial4=.
replace SS_leisuresocial4=1 if n_6160_0_3~=. & n_6160_0_3~=-7 & n_6160_0_3~=-3
replace SS_leisuresocial4=0 if SS_leisuresocial4~=1 & n_6160_0_3~=-7 & n_6160_0_3~=-3


capture drop SS_leisuresocial5
gen SS_leisuresocial5=.
replace SS_leisuresocial5=1 if n_6160_0_4~=. & n_6160_0_4~=-7 & n_6160_0_4~=-3
replace SS_leisuresocial5=0 if SS_leisuresocial5~=1 & n_6160_0_4~=-7 & n_6160_0_4~=-3

capture drop rowmissSS1
egen rowmissSS1=rowmiss(SS_leisuresocial1 SS_leisuresocial2 SS_leisuresocial3 SS_leisuresocial4 SS_leisuresocial5)

tab rowmissSS1

capture drop SS_leisuresocial
egen SS_leisuresocial=rmean(SS_leisuresocial1 SS_leisuresocial2 SS_leisuresocial3 SS_leisuresocial4 SS_leisuresocial5) if rowmissSS1<=5

replace SS_leisuresocial=SS_leisuresocial*5

save, replace


**SOCIAL SUPPORT VARIABLE 3**
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=2110

**E1 How often are you able to confide in
**someone close to you?
**SELECT one of 8 from
**5 : Almost daily
**4 : 2-4 times a week
**3 : About once a week
**2 : About once a month
**1 : Once every few months
**0 : Never or almost never
**-1 : Do not know
**-3 : Prefer not to answer


capture drop SS_abilityconfide
gen SS_abilityconfide=.
replace SS_abilityconfide=n_2110_0_0
replace SS_abilityconfide=. if n_2110_0_0==-1 | n_2110_0_0==-3


save, replace

capture drop zSS_friendsfamily
egen zSS_friendsfamily=std(SS_friendsfamily)

capture drop zSS_leisuresocial
egen zSS_leisuresocial=std(SS_leisuresocial)

capture drop zSS_abilityconfide
egen zSS_abilityconfide=std(SS_abilityconfide)


capture drop rowmissSS
egen rowmissSS=rowmiss(zSS_friendsfamily zSS_leisuresocial zSS_abilityconfide)

tab rowmissSS



capture drop SS
egen SS=rmean(zSS_friendsfamily zSS_leisuresocial zSS_abilityconfide) if rowmissSS<=1


save, replace

//STEP 7: GENERATE HEALTH VARIABLES//

use SMALLERDATASETUKBfin,clear

keep n_eid n_135_0_0 n_134_0_0 n_2178_0_0 n_21001_0_0 n_21001_0_0 n_48_0_0 n_49_0_0 n_30600_0_0 n_30710_0_0 n_30690_0_0 n_30760_0_0 n_30750_0_0 n_102_0_0 n_4080_0_0 n_4079_0_0 n_31_0_0 n_2443_0_0 n_1160_0_0

save HEALTH_UKB,replace

capture drop sex
gen sex=n_31_0_0 
recode sex 0=2 1=1


********************CO-MORBIDITY INDEX**********

**NUMBER OF SELF-REPORTED NON-CANCER ILLNESSES:***

**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=135

capture drop comorbid_noncancer
gen comorbid_noncancer=.
replace comorbid_noncancer=n_135_0_0


***NUMBER OF SELF-REPORTED CANCERS*****

**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=134

capture drop comorbid_cancer
gen comorbid_cancer=.
replace comorbid_cancer=n_134_0_0

**NUMBER OF CO-MORBIDITIES**

capture drop comorbid
gen comorbid=comorbid_noncancer+comorbid_cancer


***********SELF-RATED HEALTH***************
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=2178

capture drop srh
gen srh=n_2178_0_0

capture drop srhbr
gen srhbr=.
replace srhbr=srh if srh~=-1 & srh~=-3



***********BODY MASS INDEX****************
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=23104

capture drop bmi
gen bmi=n_21001_0_0 
label var bmi "body mass index kg/m^2" //missing values exist - consider imputation




***********ALLOSTATIC LOAD****************

***WAIST TO HIP RATIO***
**https://biobank.ctsu.ox.ac.uk/crystal/search.cgi?wot=0&srch=waist+circumference&sta0=on&sta1=on&sta2=on&sta3=on&str0=on&str3=on&fit0=on&fit10=on&fit20=on&fit30=on&fvt11=on&fvt21=on&fvt22=on&fvt31=on&fvt41=on&fvt51=on&fvt61=on&fvt101=on&yfirst=2000&ylast=2021

su n_48_0_0 n_49_0_0, det

capture drop waist
gen waist=n_48_0_0
label var waist "waist circumference cm" //missing values exist - consider imputation

capture drop hip
gen hip=n_49_0_0
label var hip "hip circumference cm" //missing values exist - consider imputation

capture drop waisthipratio
gen waisthipratio=waist/hip
label var waisthipratio "waist-hip ratio" //missing values exist - consider imputation

capture drop whr_high
gen whr_high=.
replace whr_high=1 if waisthipratio>0.90 & waisthipratio~=. & sex==1 | waisthipratio>0.85 & waisthipratio~=. & sex==2
replace whr_high=0 if whr_high~=1 & waisthipratio~=. 

label var whr_high "elevated, sex-specific waist-hip ratio: 0.90 for men, 0.85 for women"

tab whr_high 

**LOW SERUM ALBUMIN, <38 g/L**
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=30600**

su n_30600_0_0, det

capture drop albumin_low
gen albumin_low=.
replace albumin_low=1 if n_30600_0_0<38 & n_30600_0_0~=.
replace albumin_low=0 if albumin_low~=1 & n_30600_0_0~=. 
label var albumin_low "low serum albumin, <38 g/l"

tab albumin_low

**HIGH CRP, >=3 mg/dL**
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=30710

su n_30710_0_0,det

capture drop crp_high
gen crp_high=. 
replace crp_high=1 if n_30710_0_0>=3 & n_30710_0_0~=.
replace crp_high=0 if crp_high~=1 & n_30710_0_0~=. 
label var crp_high "elevated C-reactive protein, >=3 g/l"

tab crp_high


**ELEVATED TC, >=240 mg/dL: divide by 38.67 to get mmol/L: >=6.21 mmol/L

**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=30690,det
**https://www.omnicalculator.com/health/cholesterol-units

su n_30690_0_0, det

capture drop tc_high
gen tc_high=.
replace tc_high=1 if n_30690_0_0>=6.21 & n_30690_0_0~=. 
replace tc_high=0 if tc_high~=1 & n_30690_0_0~=. 
label var tc_high "elevated total cholesterol, >=6.21 mmol/L"


tab tc_high

**LOW HDL-C, <40 mg/dL: divide by 38.67 to get mmol/L: <1.034 mmol/L**
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=30760
**https://www.omnicalculator.com/health/cholesterol-units

su n_30760_0_0, det


capture drop hdl_low
gen hdl_low=.
replace hdl_low=1 if n_30760_0_0<1.034 & n_30760_0_0~=.
replace hdl_low=0 if hdl_low~=1 & n_30760_0_0~=.
label var hdl_low "low HDL-C, <1.034 mmol/L"

tab hdl_low



**Glycated hemoglobin, % change to mmol/mol:  cutoff in % is 6.4% --> 46 mmol/mol
**https://www.hba1cnet.com/hba1c-calculator/
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=30750

su n_30750_0_0,det

capture drop ghp_high
gen ghp_high=.
replace ghp_high=1 if n_30750_0_0>=46 & n_30750_0_0~=. 
replace ghp_high=0 if ghp_high~=1 & n_30750_0_0~=. 
label var ghp_high "High glycated hemoglobin A1c, >=46 mmol/mol"


tab ghp_high


**PULSE RATE, automated reading, beats/min:
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=102


su n_102_0_0,det

capture drop rhr_high
gen rhr_high=.
replace rhr_high=1 if n_102_0_0>=90 & n_102_0_0~=.
replace rhr_high=0 if rhr_high~=1 & n_102_0_0~=.
label var rhr_high "Resting pulse rate, >=90 beats/min"

tab rhr_high

**Blood pressure, automated reading:

**Systolic blood pressure, automated reading, mm Hg, >=140 mm Hg: 
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=4080

su n_4080_0_0,det

capture drop sbp_high
gen sbp_high=.
replace sbp_high=1 if n_4080_0_0>=140 & n_4080_0_0~=.
replace sbp_high=0 if sbp_high~=1 & n_4080_0_0~=.
label var sbp_high "Systolic blood pressure >=140 mm Hg"

tab sbp_high


**Diastolic blood pressure, automated reading, mm Hg, >=90 mm Hg: 
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=4079

su n_4079_0_0,det


capture drop dbp_high
gen dbp_high=.
replace dbp_high=1 if n_4079_0_0>=90 & n_4079_0_0~=.
replace dbp_high=0 if dbp_high~=1 & n_4079_0_0~=.
label var dbp_high "Diastolic blood pressure >=90 mm Hg"

tab dbp_high

**allostatic load, total score**

capture drop allostatic
gen allostatic=.
replace allostatic=albumin_low+crp_high+whr_high+tc_high+hdl_low+ghp_high+rhr_high+sbp_high+dbp_high


save, replace


capture drop zcomorbid
egen zcomorbid=std(comorbid)

capture drop zbmi
egen zbmi=std(bmi)

capture drop zsrh
egen zsrh=std(srhbr)

capture drop zallostatic
egen zallostatic=std(allostatic)

capture drop rowmissHEALTH
egen rowmissHEALTH=rowmiss(zcomorbid zbmi zsrh zallostatic)

tab rowmissHEALTH

capture drop HEALTH
egen HEALTH=rmean(zcomorbid zbmi zsrh zallostatic) if rowmissHEALTH<=2

save, replace



**************************Diabetes*************************
capture drop diabetes
gen diabetes = n_2443_0_0
recode diabetes -3 = 0 -1 =0
label var diabetes "previously diagnosed with diabetes"



********************Sleep duration***********************

capture drop sleep_duration
gen sleep_duration=n_1160_0_0 if n_1160_0_0>0

save, replace


****************************STEP 8: MERGE FILES TOGETHER FOR LIFE'S ESSENTIAL 8****************************

use DEMOG_SES_UKB,clear
sort n_eid
capture drop _merge
save, replace

use LIFESTYLENODIET_UKB,clear
sort n_eid
capture drop _merge
save, replace


use LIFESTYLEDIET_UKB,clear
sort n_eid
capture drop _merge
save, replace


use SS_UKB,clear
sort n_eid
capture drop _merge
save, replace

use HEALTH_UKB,clear
sort n_eid
capture drop _merge
save, replace


use NUTR_UKB,clear
sort n_eid
capture drop _merge
save, replace



use DEMOG_SES_UKB,clear
merge n_eid using LIFESTYLENODIET_UKB
sort n_eid
capture drop _merge
merge n_eid using LIFESTYLEDIET_UKB
sort n_eid
capture drop _merge
merge n_eid using SS_UKB
sort n_eid
capture drop _merge
merge n_eid using HEALTH_UKB
sort n_eid
capture drop _merge
merge n_eid using NUTR_UKB
sort n_eid
capture drop _merge

save LE8_UKB, replace


//STEP 9: GET MEDICATION VARIABLES: STATINS, ANTI-HYPERTENSIVES AND OTHER MEDICATIONS AND MERGE WITH LE8_UKB///////

use SMALLERDATASETUKB,clear

keep n_eid n_20003_0_* n_20004_0_* n_6153_0_0 

save MEDICATIONS_UKB, replace

*Aspirin*
capture drop aspirin
gen aspirin = 0
forval i=0/47 {
replace aspirin = 1 if n_20003_0_`i' == 1140868226 
}
label var aspirin "currently taking aspirin"
label define aspirinL 0 "no" 1 "yes"
label values aspirin aspirinL

*Warfarin*
capture drop warfarin
gen warfarin = 0
forval i=0/47 {
replace warfarin = 1 if  n_20003_0_`i' == 1140888266
}
label var warfarin "currently taking warfarin"
label values warfarin aspirinL

*Digoxin*
capture drop digoxin
gen digoxin = 0
forval i=0/47 {
replace digoxin = 1 if  n_20003_0_`i' == 2038459814
}
label var digoxin "currently taking digoxin"
label values digoxin aspirinL

*Metformin*
capture drop metformin
gen metformin = 0
forval i=0/47 {
replace metformin = 1 if  n_20003_0_`i' == 1140884600
}
label var metformin "currently taking metformin"
label values metformin aspirinL

*Radiotherapy*
capture drop radiotherapy
gen radiotherapy = 0 
forval i = 0/31 {
replace radiotherapy = 1 if n_20004_0_`i' == 1228
}

label var radiotherapy "thyroid radioablation therapy"
label define radiotherapyL 0 "no" 1 "yes"
label values radiotherapy radiotherapyL

*Menopause*
capture drop menopause
gen menopause = 0
forval i = 0/31 {
replace menopause = 1 if n_20004_0_`i' == 1665
}

label var menopause "menopause/menopausal symptoms"
label define menopauseL 0 "no" 1 "yes"
label values menopause menopauseL


*Lipid Lowering Drugs*
capture drop statins
gen statins = .
forval i = 0/0 {
replace statins = 1 if n_6153_0_`i' == 1
}
replace statins = 0 if statins ==.
label var statins "currently taking statins"
label values statins aspirinL

*Blood Pressure Treatment*
*Lipid Lowering Drugs*
capture drop bptreat
gen bptreat = .
forval i = 0/0 {
replace bptreat = 1 if n_6153_0_`i' == 2
}
replace bptreat = 0 if bptreat ==.
label var bptreat "currently on anti-hypertensives"
label values bptreat aspirinL



save,replace


use LE8_UKB,clear
sort n_eid
capture drop _merge
save, replace


use MEDICATIONS_UKB,clear
sort n_eid
capture drop _merge
save, replace

use LE8_UKB,clear
merge n_eid using MEDICATIONS_UKB
save, replace


//STEP 10: GENERATE LIFE'S ESSENTIAL 8 INDEX//////

use LE8_UKB, clear



**************************************COMPONENT 1: DIET************************************************

**HDI_TOTALSCORE

su HDI_TOTALSCORE
histogram HDI_TOTALSCORE

**>=95th percentile: 100
**75th-94th percentile: 80
**50th-74th: 50
**25th-49th: 25
**1st-24th: 0

xtile HDI_TOTALSCOREpct=HDI_TOTALSCORE,nq(100)

capture drop LE8_COMP1DIET
gen LE8_COMP1DIET=.
replace LE8_COMP1DIET=100 if HDI_TOTALSCOREpct>=95 & HDI_TOTALSCORE~=.
replace LE8_COMP1DIET=80 if HDI_TOTALSCOREpct>=75 & HDI_TOTALSCOREpct<95 & HDI_TOTALSCORE~=.
replace LE8_COMP1DIET=50 if HDI_TOTALSCOREpct>=50 & HDI_TOTALSCOREpct<75 & HDI_TOTALSCORE~=.
replace LE8_COMP1DIET=25 if HDI_TOTALSCOREpct>=25 & HDI_TOTALSCOREpct<50 & HDI_TOTALSCORE~=.
replace LE8_COMP1DIET=0 if HDI_TOTALSCOREpct>=1 & HDI_TOTALSCOREpct<25 & HDI_TOTALSCORE~=.


************************************COMPONENT 2: PHYSICAL ACTIVITY*************************************


*Moderate exercise MET-min/week*
**gen modperday = n_894_0_0 if n_894_0_0 >= 0
**label var modperday "moderate exercise minutes per day"


*Vigorous exercise MET-min/week*
**gen vigperday = n_914_0_0 if n_914_0_0 >= 0
**label var vigperday "vigorous exercise minutes per day"

**Minutes per day of moderate or greater activity**

capture drop modvigperday
egen modvigperday=rowtotal(modperday vigperday)


**100: >=150
**90: 120-149
**80: 90-119
**60: 60-89
**40: 30-59
**20: 1-29
**0: 0

capture drop LE8_COMP2PA
gen LE8_COMP2PA=.
replace LE8_COMP2PA=100 if modvigperday>=150 & modvigperday~=.
replace LE8_COMP2PA=90 if modvigperday>=120 & modvigperday<150 & modvigperday~=.
replace LE8_COMP2PA=80 if modvigperday>=90 & modvigperday<120 & modvigperday~=.
replace LE8_COMP2PA=60 if modvigperday>=60 & modvigperday<90 & modvigperday~=.
replace LE8_COMP2PA=40 if modvigperday>=30 & modvigperday<60 & modvigperday~=.
replace LE8_COMP2PA=20 if modvigperday>=1 & modvigperday<30 & modvigperday~=.
replace LE8_COMP2PA=0 if modvigperday==0 

save, replace

************************************COMPONENT 3: NICOTINE EXPOSURE*************************************

*Combine Current Smoking with Ex-smoking duration for protective effects*


**gen smokingstatus = 0 if smoking == 2
**replace smokingstatus = agestop if smokingstatus ==.
**replace smokingstatus = 4 if smoking == 0
**label var smokingstatus "complete smoking status"
**label define statusL 0 "current smoker" 1 "ex-smoker < 5 years" 2 "ex-smoker between 5-10 years" 3 "ex-smoker > 10 years" 4 "never smoker"
**label values smokingstatus statusL
**recode smokingstatus .=4

*Environmental tobacco smoke*

**replace n_1279_0_0 = . if n_1279_0_0 < 0
**replace n_1269_0_0  = . if n_1269_0_0 < 0
**order n_1279_0_0, after(n_1269_0_0)
**egen ets = rowtotal(n_1269_0_0-n_1279_0_0)
**gen etsmoke = ets
**label var etsmoke "environmental tobacco exposures (hours per week)"

save, replace

**100 Never smoker
** 75 Former smoker, quit >=5 years
** 50 Former smoker, quit 1-<5 years
**25 Former smoker, quit <1 year, or currently using inhaled NDS
**0 Current smoker

capture drop LE8_COMP3NICOTINE
gen LE8_COMP3NICOTINE=.
replace LE8_COMP3NICOTINE=100 if smokingstatus==4
replace LE8_COMP3NICOTINE=75 if smokingstatus==2 | smokingstatus==3
replace LE8_COMP3NICOTINE=37.5 if smokingstatus==1 
replace LE8_COMP3NICOTINE=0 if smokingstatus==0
replace LE8_COMP3NICOTINE=LE8_COMP3NICOTINE-20 if LE8_COMP3NICOTINE~=0 & etsmoke~=0



**[Note that 25 and 50 are combined to denote <5 years, into 37.5 ] 
save, replace



*************************************COMPONENT 4: SLEEP HEALTH*****************************************


**capture drop sleep_duration
**gen sleep_duration=n_1160_0_0 if n_1160_0_0>0


**100: 7-<9
**90: 9-<10
**70: 6-<7
**40: 5-<6 or >=10
**20: 4-<5
**0: <4


capture drop LE8_COMP4SLEEP
gen LE8_COMP4SLEEP=.
replace LE8_COMP4SLEEP=100 if sleep_duration>=7 & sleep_duration<9
replace LE8_COMP4SLEEP=90 if sleep_duration>=9 & sleep_duration<10
replace LE8_COMP4SLEEP=70 if sleep_duration>=6 & sleep_duration<7
replace LE8_COMP4SLEEP=40 if (sleep_duration>=5 & sleep_duration<6) | (sleep_duration>=10 & sleep_duration~=.)
replace LE8_COMP4SLEEP=20 if sleep_duration>=4 & sleep_duration<5
replace LE8_COMP4SLEEP=0 if sleep_duration<4

save, replace


**************************************COMPONENT 5: BODY MASS INDEX************************************

**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=23104

**capture drop bmi
**gen bmi=n_21001_0_0 
**label var bmi "body mass index kg/m^2" 

**100: <25
**70: 25-29.9
**30: 30.0-34.9
**15: 35.0-39.9
**0: >=40.0


capture drop LE8_COMP5BMI
gen LE8_COMP5BMI=.
replace LE8_COMP5BMI=100 if bmi<25 & bmi~=.
replace LE8_COMP5BMI=70 if bmi>=25 & bmi<30
replace LE8_COMP5BMI=30 if bmi>=30 & bmi<35
replace LE8_COMP5BMI=15 if bmi>=35 & bmi<40
replace LE8_COMP5BMI=0 if bmi>=40 & bmi~=.


save, replace


***************************************COMPONENT 6: Blood lipids **************************************

**ELEVATED TC, >=240 mg/dL: divide by 38.67 to get mmol/L: >=6.21 mmol/L

**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=30690,det
**https://www.omnicalculator.com/health/cholesterol-units

su n_30690_0_0, det



**LOW HDL-C, <40 mg/dL: divide by 38.67 to get mmol/L: <1.034 mmol/L**
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=30760
**https://www.omnicalculator.com/health/cholesterol-units

su n_30760_0_0, det


capture drop nonhdlchol
gen nonhdlchol=(n_30690_0_0-n_30760_0_0)


*Lipid Lowering Drugs*
capture drop statins
gen statins = .
forval i = 0/0 {
replace statins = 1 if n_6153_0_`i' == 1
}
replace statins = 0 if statins ==.
label var statins "currently taking statins"
label values statins aspirinL


**100: <130 or <3.36
**60: 130-159 or 3.36-<4.13
**40: 160-189 or 4.13-<4.91
**20: 190-219 or 4.91-<5.69
**0: >=220 or >=5.69

capture drop LE8_COMP6LIPIDS
gen LE8_COMP6LIPIDS=.
replace LE8_COMP6LIPIDS=100 if nonhdlchol<3.36
replace LE8_COMP6LIPIDS=60 if nonhdlchol>=3.36 & nonhdlchol<4.13
replace LE8_COMP6LIPIDS=40 if nonhdlchol>=4.13 & nonhdlchol<4.91
replace LE8_COMP6LIPIDS=20 if nonhdlchol>=4.91 & nonhdlchol<5.69
replace LE8_COMP6LIPIDS=0 if nonhdlchol>=5.69 & nonhdlchol~=.
replace LE8_COMP6LIPIDS=LE8_COMP6LIPIDS-20 if LE8_COMP6LIPIDS~=0 & statins==1

save, replace

***************************************COMPONENT 7: Blood glucose or HbA1c*************************************

**Glycated hemoglobin, % change to mmol/mol: (35.3 mmol/mol is 5.4%), cutoff in % is 6.4% --> 46 mmol/mol
**Use the converter below

**https://www.hba1cnet.com/hba1c-calculator/
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=30750

su n_30750_0_0,det



*Diabetes*
**gen diabetes = n_2443_0_0
**recode diabetes -3 = 0 -1 =0
**label var diabetes "previously diagnosed with diabetes"
**label values diabetes aspirinL

**Points	Level (for HANDLS SE8)
**100	If dxDiabetes is not "Diabetes" and hbA1c < 5.7
**60	If dxDiabetes is not "Diabetes" and HbA1c 5.7–6.4
**40	HbA1c <7.0 and dxDiabetes = "Diabetes", 
**OR If dxDiabetes is not "Diabetes"(or dx missing) and HbA1C 6.4-7.0
**30	HbA1c 7.0–7.9  (regardless of dx)
**20	HbA1c 8.0–8.9  (regardless of dx)
**10	Hb A1c 9.0–9.9  (regardless of dx)
**0	HbA1c ≥10.0  (regardless of dx)


capture drop LE8_COMP7GLUC
gen LE8_COMP7GLUC=.
replace LE8_COMP7GLUC=100 if diabetes==0 & n_30750_0_0<39 
replace LE8_COMP7GLUC=60 if  diabetes==0 & (n_30750_0_0>=39 &  n_30750_0_0<46)
replace LE8_COMP7GLUC=40 if  (diabetes==1 & (n_30750_0_0<53)) | (diabetes==0 & (n_30750_0_0>=46 & n_30750_0_0<53))
replace LE8_COMP7GLUC=30 if  (n_30750_0_0>=53 & n_30750_0_0<64)
replace LE8_COMP7GLUC=20 if  (n_30750_0_0>=64 & n_30750_0_0<75)
replace LE8_COMP7GLUC=10 if  (n_30750_0_0>=75 & n_30750_0_0<86)
replace LE8_COMP7GLUC=0 if  (n_30750_0_0>=86) & n_30750_0_0~=.

save, replace

***************************************COMPONENT 8: Blood pressure************************************


**Systolic blood pressure, automated reading, mm Hg, >=140 mm Hg: 
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=4080

su n_4080_0_0,det


**Diastolic blood pressure, automated reading, mm Hg, >=90 mm Hg: 
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=4079

su n_4079_0_0,det


*Blood Pressure Treatment*

**capture drop bptreat
**gen bptreat = .
**forval i = 0/3 {
**replace bptreat = 1 if n_6153_0_`i' == 2
**}
**replace bptreat = 0 if bptreat ==.
**label var bptreat "currently on anti-hypertensives"
**label values bptreat aspirinL


**100: <120/<80 (Optimal)
**75: 120-129/<80 (Elevated)
**50: 130-139 or 80-89 (Stage | HTN)
**25: 140-159 or 90-99
**0: >=160 or >=100
**Subtact 20 pionts if treated level**

capture drop LE8_COMP8BP
gen LE8_COMP8BP=.
replace LE8_COMP8BP=100 if n_4080_0_0<120 & n_4079_0_0<80
replace LE8_COMP8BP=75 if (n_4080_0_0>=120 & n_4080_0_0<130) & n_4079_0_0<80
replace LE8_COMP8BP=50 if (n_4080_0_0>=130 & n_4080_0_0<140) | (n_4079_0_0>=80 & n_4079_0_0<90)
replace LE8_COMP8BP=25 if (n_4080_0_0>=140 & n_4080_0_0<160) | (n_4079_0_0>=90 & n_4079_0_0<100)
replace LE8_COMP8BP=0 if (n_4080_0_0>=160 & n_4080_0_0~=.) | (n_4079_0_0>=100 & n_4079_0_0~=.)
replace LE8_COMP8BP=LE8_COMP8BP-20 if LE8_COMP8BP~=0 & bptreat==1



*******************************************LE8 TOTAL SCORE**********************************************
capture drop rowmissLE8TOTAL
egen rowmissLE8TOTAL=rowmiss(LE8_COMP1DIET LE8_COMP2PA LE8_COMP3NICOTINE LE8_COMP4SLEEP LE8_COMP5BMI LE8_COMP6LIPIDS LE8_COMP7GLUC LE8_COMP8BP)

tab rowmissLE8TOTAL

capture drop LE8_TOTALSCORE
egen LE8_TOTALSCORE=rmean(LE8_COMP1DIET LE8_COMP2PA LE8_COMP3NICOTINE LE8_COMP4SLEEP LE8_COMP5BMI LE8_COMP6LIPIDS LE8_COMP7GLUC LE8_COMP8BP) if rowmissLE8TOTAL<=4

replace LE8_TOTALSCORE=LE8_TOTALSCORE*8


*******************************************LE8 LIFESTYLE SCORE*******************************************
capture drop rowmissLE8LIFESTYLE
egen rowmissLE8LIFESTYLE=rowmiss(LE8_COMP1DIET LE8_COMP2PA LE8_COMP3NICOTINE LE8_COMP4SLEEP)

tab rowmissLE8LIFESTYLE

capture drop LE8_LIFESTYLE
egen LE8_LIFESTYLE=rmean(LE8_COMP1DIET LE8_COMP2PA LE8_COMP3NICOTINE LE8_COMP4SLEEP) if rowmissLE8LIFESTYLE<=2


replace LE8_LIFESTYLE=LE8_LIFESTYLE*4



********************************************LE8 BIOLOGICAL SCORE***********************************************
capture drop rowmissLE8BIOLOGICAL
egen rowmissLE8BIOLOGICAL=rowmiss(LE8_COMP5BMI LE8_COMP6LIPIDS LE8_COMP7GLUC LE8_COMP8BP)

tab rowmissLE8BIOLOGICAL

capture drop LE8_BIOLOGICAL
egen LE8_BIOLOGICAL=rmean(LE8_COMP5BMI LE8_COMP6LIPIDS LE8_COMP7GLUC LE8_COMP8BP) if rowmissLE8BIOLOGICAL<=2

replace LE8_BIOLOGICAL=LE8_BIOLOGICAL*4

 

save, replace



//STEP 11: GENERATE COGNITION VARIABLES//

use SMALLERDATASETUKBfin,clear

keep n_eid n_20023_0_0 n_399_0_1 n_399_0_2 n_399_0_3 n_400_0_1 n_400_0_2 n_400_0_3

save COGN_UKB,replace

capture drop n_400_0_1r
capture drop n_400_0_2r

gen n_400_0_1r=n_400_0_1 if n_400_0_1~="Test not completed"
gen n_400_0_2r=n_400_0_2 if n_400_0_2~="Test not completed"

destring n_399_0_1 n_399_0_2 n_400_0_1r n_400_0_2r,replace

**Reaction time: mean time to correctly identify matches**
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=20023

capture drop REACTION_TIME
gen REACTION_TIME=.
replace REACTION_TIME=ln(n_20023_0_0)



**Pairs matching: number incorrect**
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=399
capture drop n_399_0_mean
gen n_399_0_mean=(n_399_0_1+n_399_0_2)/2

su n_399_0_mean


capture drop PAIRSMATCHING_INC
gen PAIRSMATCHING_INC=.
replace PAIRSMATCHING_INC=ln(n_399_0_mean)

save, replace

**Pairs matching: time to complete**
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=400

capture drop n_400_0_mean
gen n_400_0_mean=(n_400_0_1r+n_400_0_2r)/2


capture drop PAIRSMATCHING_TTC
gen PAIRSMATCHING_TTC=.
replace PAIRSMATCHING_TTC=ln(n_400_0_mean)


capture drop rowmissCOGN
egen rowmissCOGN=rowmiss(REACTION_TIME PAIRSMATCHING_INC PAIRSMATCHING_TTC)

tab rowmissCOGN

***PCA for cognitive performance**

pca REACTION_TIME PAIRSMATCHING_INC PAIRSMATCHING_TTC if rowmissCOGN<=1, factors(1)
predict POORCOGN
 
save, replace


//STEP 12: GENERATE AD/DEMENTIA AND RELATED TIME VARIABLES//

use SMALLERDATASETUKBfin,clear

keep n_eid n_21022_0_0 n_20009_0_* n_20002_0_* s_41202_0_* n_34_0_0 n_52_0_0 ts_53_0_0 ts_40000_*_0  n_40007_*_0  ts_42018_0_0 ts_42020_0_0 





save ADDEMENTIA_UKB,replace


**DEMENTIA AND ALZHEIMER'S DISEASE, INCIDENT CASES AND DATE OF INCIDENCE**

**https://biobank.ctsu.ox.ac.uk/crystal/search.cgi?wot=0&srch=dementia&sta0=on&sta1=on&sta2=on&sta3=on&str0=on&str3=on&fit0=on&fit10=on&fit20=on&fit30=on&fvt11=on&fvt21=on&fvt22=on&fvt31=on&fvt41=on&fvt51=on&fvt61=on&fvt101=on&yfirst=2000&ylast=2021

**Main resource: algorithmically defined outcomes: 
**https://biobank.ctsu.ox.ac.uk/crystal/ukb/docs/alg_outcome_main.pdf**: pages 14-15


**Field ID	Description	Category

**130836	Date F00 first reported (dementia in alzheimer's disease)	Mental and behavioural disorders  
**130838	Date F01 first reported (vascular dementia)	Mental and behavioural disorders  
**130840	Date F02 first reported (dementia in other diseases classified elsewhere)	Mental and behavioural disorders  
**130842	Date F03 first reported (unspecified dementia)	Mental and behavioural disorders  
**42018	Date of all cause dementia report	Dementia outcomes  
**42024	Date of frontotemporal dementia report	Dementia outcomes  
**42022	Date of vascular dementia report	Dementia outcomes  
**42019	Source of all cause dementia report	Dementia outcomes  
**42025	Source of frontotemporal dementia report	Dementia outcomes  
**130837	Source of report of F00 (dementia in alzheimer's disease)	Mental and behavioural disorders  
**130839	Source of report of F01 (vascular dementia)	Mental and behavioural disorders  
**130841	Source of report of F02 (dementia in other diseases classified elsewhere)	Mental and behavioural disorders  
**130843	Source of report of F03 (unspecified dementia)	Mental and behavioural disorders  
**42023	Source of vascular dementia report	Dementia outcomes  
**20112	Illnesses of adopted father	Family history  
**20113	Illnesses of adopted mother	Family history  
**20114	Illnesses of adopted siblings	Family history  
**20107	Illnesses of father	Family history  
**20110	Illnesses of mother	Family history  
**20111	Illnesses of siblings	Family history  
**40002	Contributory (secondary) causes of death: ICD10	Death register  
**41270	Diagnoses - ICD10	Summary Diagnoses  
**41202	Diagnoses - main ICD10	Summary Diagnoses  
**41204	Diagnoses - secondary ICD10	Summary Diagnoses  
**41201	External causes - ICD10	Summary Diagnoses  
**40006	Type of cancer: ICD10	Cancer register  
**40001	Underlying (primary) cause of death: ICD10	Death register  
**41271	Diagnoses - ICD9	Summary Diagnoses  
**41203	Diagnoses - main ICD9	Summary Diagnoses  
**41205	Diagnoses - secondary ICD9	Summary Diagnoses  
**40013	Type of cancer: ICD9	Cancer register  
**20002	Non-cancer illness code, self-reported	Medical conditions  
**41246	Treatment speciality of consultant (recoded)	Summary Administration  


**Field ID	Description	Category
**20009	Interpolated Age of participant when non-cancer illness first diagnosed	Medical conditions  
**40007	Age at death	Death register  


**Field ID	Description	Category
**131036	Date G30 first reported (alzheimer's disease)	Nervous system disorders  (**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=131036)  
**42020	        Date of alzheimer's disease report	Dementia outcomes  (**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=42020)
**42021	        Source of alzheimer's disease report	Dementia outcomes  
**130837	Source of report of F00 (dementia in alzheimer's disease)	Mental and behavioural disorders  
**131037	Source of report of G30 (alzheimer's disease)	Nervous system disorders  

/////////////////////////////////////////////////////////////////////////////////////////////////
***Field 20002: https://biobank.ctsu.ox.ac.uk/crystal/coding.cgi?id=6
***Field 20009: https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=20009

*Years of Birth*
capture drop birthyear
gen birthyear=n_34_0_0 

*Month of Birth*
capture drop birthmonth
gen birthmonth=n_52_0_0 

*Date of birth*
capture drop birthdate
gen birthdate=mdy(birthmonth,14,birthyear)

*Baseline Cohort Start Date*
capture drop startdate
gen startdate=ts_53_0_0 
format startdate %d

*Baseline age**
capture drop baselineage
gen baselineage=(startdate-birthdate)/365.25


**Prior dementia**
forval i = 0/28 {
replace n_20009_0_`i' = . if n_20009_0_`i' < 0
}

gen dem = 0
gen agedem = .
forval i=0/28 {
replace dem = 1 if n_20002_0_`i' == 1263
	forval k=0/28 {
	replace agedem = n_20009_0_`k' if dem == 1 & n_20009_0_`k' < n_20009_0_`k-1'
	}
}

capture drop dem
capture drop priordem 
gen priordem = 1 if agedem < baselineage 
recode priordem .=0 
label var priordem "individuals with prior history of dementia"
label define priorL 0 "none" 1 "had disease before cohort start date"
label values priordem priorL

**Source: https://bmcmedicine.biomedcentral.com/track/pdf/10.1186/s12916-021-01980-z.pdf


**Dementia: A81.0, F00, F01, F02, F03, F05, G30, G31.0, G31.1, G31.8, and I67.3

**AD: (F00, G30)

**VaD: (F01, I67.3)


format ts_42018_0_0 %d 

capture drop DEMENTIA_EARLIESTDATE
gen DEMENTIA_EARLIESTDATE= ts_42018_0_0  

capture drop dem_diag
gen dem_diag=.
replace dem_diag=1 if DEMENTIA_EARLIESTDATE~=.
replace dem_diag=0 if dem_diag~=1



****Incident Alzheimer's Disease***


format ts_42020_0_0 %d 

capture drop AD_EARLIESTDATE
gen AD_EARLIESTDATE = ts_42020_0_0


capture drop ad_diag
gen ad_diag=.
replace ad_diag=1 if AD_EARLIESTDATE~=.
replace ad_diag=0 if ad_diag~=1

*Years of Birth*
capture drop birthyear
gen birthyear=n_34_0_0 

*Month of Birth*
capture drop birthmonth
gen birthmonth=n_52_0_0 

*Date of birth*
capture drop birthdate
gen birthdate=mdy(birthmonth,14,birthyear)

*Baseline Cohort Start Date*
capture drop startdate
gen startdate=ts_53_0_0 
format startdate %d

*Baseline age**
capture drop baselineage
gen baselineage=(startdate-birthdate)/365.25

*Death Date*
capture drop deathdate
gen deathdate = ts_40000_0_0 
replace deathdate =  ts_40000_1_0 if deathdate ==.
format deathdate %d
label var deathdate "date of death"

**Died vs. not**
capture drop died
gen died=.
replace died=1 if deathdate~=.
replace died=0 if deathdate==.

**Age of death**
**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=40007

capture drop deathage
gen deathage=.
replace deathage=n_40007_0_0 if n_40007_0_0~=.
replace deathage=n_40007_1_0 if n_40007_1_0~=.

**https://biobank.ndph.ox.ac.uk/ukb/exinfo.cgi?src=Data_providers_and_dates**

*Generate exit date:
capture drop doexit
gen doexit = deathdate if died==1
replace doexit = d(31oct2021) if doexit==. & died==0
format doexit %d

*Generate follow-up time between start and end among those who survived during follow-up without incident outcome*
capture drop time0_0 timeyrs0_0
gen time0_0 = doexit - startdate if died==0
gen timeyrs0_0 = time0_0/365.25
label var time0_0 "follow up time in days if no incident outcome and survived, days"
label var timeyrs0_0 "follow up time in years if no incident outcome and survived, years"

*Generate follow-up time between start and end among those who died during follow-up without incident outcome*
capture drop time1_0 timeyrs1_0
gen time1_0 = doexit - startdate if died==1
gen timeyrs1_0 = time1_0 /365.25
label var time1_0 "follow up time in days if no incident outcome and died, days"
label var timeyrs1_0 "follow up time in years if no incident outcome and died, years"


***Generate dementia earliest date for incident cases: **

**Field IDField title
**42018Date of all cause dementia report
**42019Source of all cause dementia report
**42020Date of alzheimer's disease report
**42021Source of alzheimer's disease report
**42022Date of vascular dementia report
**42023Source of vascular dementia report
**42024Date of frontotemporal dementia report
**42025Source of frontotemporal dementia r


***Generate Alzheimer's Disease earliest date for incident cases**
**42020	        Date of alzheimer's disease report	Dementia outcomes  (**https://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=42020)



****Generate follow-up time between start and end among those who survived or died during follow-up but with  incident all-cause dementia*
capture drop time01_1A 
capture drop time01_1Ayears
gen time01_1A = DEMENTIA_EARLIESTDATE - startdate 
gen time01_1Ayears = time01_1A/365.25 
replace time01_1Ayears=time01_1Ayears if time01_1Ayears>-10
label var time01_1A "follow up time in days if Dementia incident outcome and died/survived, days"
label var time01_1Ayears "follow up time in days if Dementia incident outcome and died/survived, years"


****Generate follow-up time between start and end among those who survived or died during follow-up but with  incident AD*
capture drop time01_1B 
capture drop time01_1Byears
gen time01_1B = AD_EARLIESTDATE - startdate
gen time01_1Byears = time01_1B/365.25 
replace time01_1Byears=time01_1Byears if time01_1Byears>-10
label var time01_1B "follow up time in days if AD incident outcome and died/survived, days"
label var time01_1Byears "follow up time in years if AD incident outcome and died/survived, years"


**Generate time to all-cause dementia**

capture drop time_dementia
gen time_dementia=.
replace time_dementia=timeyrs1_0  if dem_diag==0 & died==1
replace time_dementia=time01_1Ayears   if dem_diag==1 
replace time_dementia=timeyrs0_0   if time_dementia==.



**Generate time to AD dementia**
capture drop time_AD
gen time_AD=.
replace time_AD=timeyrs1_0  if ad_diag==0 & died==1
replace time_AD=time01_1Byears   if ad_diag==1 
replace time_AD=timeyrs0_0   if time_AD==.


**Generate Age to incident all-cause dementia or death or end of follow-up**
capture drop Age_dementia
gen Age_dementia=.
replace Age_dementia=baselineage+time_dementia 
 

**Generate Age to incident AD dementia or death or end of follow-up**

capture drop Age_AD
gen Age_AD=baselineage+time_AD 

save, replace

//STEP 13: MERGE DATASETS TOGETHER//


use ADDEMENTIA_UKB
sort n_eid
capture drop _merge
save, replace

use COGN_UKB,clear
sort n_eid
capture drop _merge
save, replace


use LE8_UKB
sort n_eid
capture drop _merge
save, replace

merge n_eid using COGN_UKB
capture drop _merge
sort n_eid
merge n_eid using ADDEMENTIA_UKB

save UKB_PAPER1_RACESESDEM, replace


//STEP 14: DETERMINE FINAL ANALYTIC SAMPLE SIZE/////
use UKB_PAPER1_RACESESDEM,clear


**Sample 1**

capture drop sample1
gen sample1=.
replace sample1=1 if baselineage~=. 
replace sample1=0 if sample1~=1


**Sample 2: >=50 y**

capture drop sample2
gen sample2=.
replace sample2=1 if baselineage>=50 & baselineage~=.
replace sample2=0 if sample2~=1


**Sample 3: exclude those with missing cognitive performance test scores**

capture drop sample3
gen sample3=.
replace sample3=1 if baselineage>=50 & baselineage~=. & POORCOGN~=. & SES~=. & SMOKE~=. & SS~=. & NUTR~=. & DIET~=. & PA~=. & ALCOHOL~=. & HEALTH~=. & LE8_TOTALSCORE~=. & LE8_LIFESTYLE~=. & LE8_BIOLOGICAL~=. & baselineage~=. & sex~=. & householdsize~=. & ethnicity2~=.
replace sample3=0 if sample3~=1


**Sample 4: final sample: exclude prevalent dementia cases and incident dementia cases within a year**

stset Age_dementia, failure(dem_diag==1) enter(baselineage) id(n_eid) scale(1)

capture drop sample4
gen sample4=.
replace sample4=1 if (sample3==1 & priordem==0 & _t~=.) | (sample3==1 & time01_1Ayears>1 & time01_1Ayears~=. & dem_diag==1 & _t~=.)
replace sample4=0 if sample4~=1


capture drop sample_final
gen sample_final=sample4

tab sample_final

save, replace

//STEP 15: Correlate the mediators and regress against their individual measures: THIS NEEDS TO BE RE-RUN ON IMPUTED DATA AFTER //

pwcorr SES SMOKE ALCOHOL DIET NUTR PA SS HEALTH POORCOGN, sig

reg SES educationbr householdincome townsend if sample_final==1
reg SMOKE smokingstatus etsmoke packyearssmoke if sample_final==1
reg DIET HDI_TOTALSCORE if sample_final==1
reg PA METmin
reg ALCOHOL alcohol if sample_final==1
reg NUTR vitamind rdw if sample_final==1
reg SS SS_friendsfamily SS_leisuresocial SS_abilityconfide  if sample_final==1
reg HEALTH comorbid bmi srhbr allostatic if sample_final==1
reg POORCOGN REACTION_TIME PAIRSMATCHING_INC PAIRSMATCHING_TTC if sample_final==1
reg LE8_TOTALSCORE LE8_LIFESTYLE LE8_BIOLOGICAL if sample_final==1


//STEP 16: stset for dementia and AD incidence and estimate median age and percentiles, plus incidence rates across sex and racial groups//

capture drop RACE_ETHN
gen RACE_ETHN=ethnicity2

capture drop NonWhite
gen NonWhite=.
replace NonWhite=1 if RACE_ETHN==1 | RACE_ETHN==2 | RACE_ETHN==3
replace NonWhite=0 if RACE_ETHN==0


save, replace

*************stsum code******************************


**AD INCIDENCE**

stset Age_AD, failure(ad_diag==1) enter(baselineage) id(n_eid) scale(1)

stsum if sample4==1
stsum if sample4==1  & RACE_ETHN==0
stsum if sample4==1  & RACE_ETHN==1 | RACE_ETHN==2 | RACE_ETHN==3
stsum if sample4==1  & RACE_ETHN==1
stsum if sample4==1 & RACE_ETHN==2
stsum if sample4==1 & RACE_ETHN==3

stsum if sample4==1 & sex==1
stsum if sample4==1 & sex==1 & RACE_ETHN==0
stsum if sample4==1 & sex==1 & RACE_ETHN==1
stsum if sample4==1 & sex==1 & RACE_ETHN==2
stsum if sample4==1 & sex==1 & RACE_ETHN==3


stsum if sample4==1 & sex==2
stsum if sample4==1 & sex==2 & RACE_ETHN==0
stsum if sample4==1 & sex==2 & RACE_ETHN==1
stsum if sample4==1 & sex==2 & RACE_ETHN==2
stsum if sample4==1 & sex==2 & RACE_ETHN==3

stptime if sample4==1
stptime if sample4==1  & RACE_ETHN==0
stptime if sample4==1  & RACE_ETHN==1 | RACE_ETHN==2 | RACE_ETHN==3
stptime if sample4==1  & RACE_ETHN==1
stptime if sample4==1 &  RACE_ETHN==2
stptime if sample4==1 & RACE_ETHN==3

stptime if sample4==1 & sex==1
stptime if sample4==1 & sex==1 & RACE_ETHN==0
stptime if sample4==1 & sex==1 & RACE_ETHN==1
stptime if sample4==1 & sex==1 & RACE_ETHN==2
stptime if sample4==1 & sex==1 & RACE_ETHN==3

stptime if sample4==1 & sex==2
stptime if sample4==1 & sex==2 & RACE_ETHN==0
stptime if sample4==1 & sex==2 & RACE_ETHN==1
stptime if sample4==1 & sex==2 & RACE_ETHN==2
stptime if sample4==1 & sex==2 & RACE_ETHN==3


save, replace



**DEMENTIA INCIDENCE**

stset Age_dementia, failure(dem_diag==1) enter(baselineage) id(n_eid) scale(1)

stsum if sample4==1
stsum if sample4==1  & RACE_ETHN==0
stsum if sample4==1  & RACE_ETHN==1 | RACE_ETHN==2 | RACE_ETHN==3
stsum if sample4==1  & RACE_ETHN==1
stsum if sample4==1 & RACE_ETHN==2
stsum if sample4==1 & RACE_ETHN==3

stsum if sample4==1 & sex==1
stsum if sample4==1 & sex==1 & RACE_ETHN==0
stsum if sample4==1 & sex==1 & RACE_ETHN==1
stsum if sample4==1 & sex==1 & RACE_ETHN==2
stsum if sample4==1 & sex==1 & RACE_ETHN==3


stsum if sample4==1 & sex==2
stsum if sample4==1 & sex==2 & RACE_ETHN==0
stsum if sample4==1 & sex==2 & RACE_ETHN==1
stsum if sample4==1 & sex==2 & RACE_ETHN==2
stsum if sample4==1 & sex==2 & RACE_ETHN==3

stptime if sample4==1
stptime if sample4==1  & RACE_ETHN==0
stptime if sample4==1  & RACE_ETHN==1 | RACE_ETHN==2 | RACE_ETHN==3
stptime if sample4==1  & RACE_ETHN==1
stptime if sample4==1 &  RACE_ETHN==2
stptime if sample4==1 & RACE_ETHN==3

stptime if sample4==1 & sex==1
stptime if sample4==1 & sex==1 & RACE_ETHN==0
stptime if sample4==1 & sex==1 & RACE_ETHN==1
stptime if sample4==1 & sex==1 & RACE_ETHN==2
stptime if sample4==1 & sex==1 & RACE_ETHN==3

stptime if sample4==1 & sex==2
stptime if sample4==1 & sex==2 & RACE_ETHN==0
stptime if sample4==1 & sex==2 & RACE_ETHN==1
stptime if sample4==1 & sex==2 & RACE_ETHN==2
stptime if sample4==1 & sex==2 & RACE_ETHN==3

save, replace


//STEP 17: DETERMINE DIFFERENCES IN FINAL ANALYTIC SAMPLE VS. EXCLUDED SAMPLE BY BASIC SOCIO-DEMOGRAPHICS//

logistic sample_final baselineage sex i.RACE_ETHN if baselineage>=50 & baselineage~=.

xi:probit sample_final baselineage sex i.RACE_ETHN if baselineage>=50 & baselineage~=.
capture drop p1
predict p1, xb

capture drop phi
capture drop caphi
capture drop invmills

gen phi=(1/sqrt(2*_pi))*exp(-(p1^2/2))

egen caphi=std(p1)

capture drop invmills
gen invmills=phi/caphi

save, replace


save, replace

//STEP 18: IMPUTATIONS FAILED, ALL ANALYSIS SHOULD BE ON UNIMPUTED DATA///

use UKB_PAPER1_RACESESDEM, clear

capture drop AGE
gen AGE=baselineage

capture drop SEX
gen SEX=sex

save, replace

save finaldata_unimputed, replace

sort n_eid 

save, replace



capture drop White
 gen White=.
 replace White=1 if RACE_ETHN==0
 replace White=0 if RACE_ETHN~=0 & RACE_ETHN~=.

capture drop Black
 gen Black=.
 replace Black=1 if RACE_ETHN==1
 replace Black=0 if RACE_ETHN~=1 & RACE_ETHN~=.


capture drop SA
 gen SA=.
 replace SA=1 if RACE_ETHN==2
 replace SA=0 if RACE_ETHN~=2 & RACE_ETHN~=.

capture drop OTHER
 gen OTHER=.
 replace OTHER=1 if RACE_ETHN==2
 replace OTHER=0 if RACE_ETHN~=2 & RACE_ETHN~=.

capture drop NonWhite
 gen NonWhite=.
 replace NonWhite=1 if RACE_ETHN~=0 & RACE_ETHN~=.
 replace NonWhite=0 if RACE_ETHN==0 



capture drop Men
 gen Men=.
 replace Men=1 if SEX==1
 replace Men=0 if SEX==2



capture drop Women
 gen Women=.
 replace Women=1 if SEX==2
 replace Women=0 if SEX==1


*******WITHIN FINAL SAMPLE SUBPOP VARIABLES*************

capture drop sample_final
 gen sample_final=.
 replace sample_final=1 if AGE>=50 & AGE~=. & sample4==1 
 replace sample_final=0 if sample_final~=1 


*****OVERALL*******

capture drop RACE_ETHN0
gen RACE_ETHN0=.
replace RACE_ETHN0=1 if AGE>=50 & AGE~=. & RACE_ETHN==0 & sample_final==1 
replace RACE_ETHN0=0 if RACE_ETHN0~=1 & sample4==1


capture drop RACE_ETHN1
gen RACE_ETHN1=.
replace RACE_ETHN1=1 if AGE>=50 & AGE~=. & RACE_ETHN==1 & sample_final==1 
replace RACE_ETHN1=0 if RACE_ETHN1~=1 & sample4==1


capture drop RACE_ETHN2
gen RACE_ETHN2=.
replace RACE_ETHN2=1 if AGE>=50 & AGE~=. & RACE_ETHN==2 & sample_final==1 
replace RACE_ETHN2=0 if RACE_ETHN2~=1 & sample4==1


capture drop RACE_ETHN3
gen RACE_ETHN3=.
replace RACE_ETHN3=1 if AGE>=50 & AGE~=. & RACE_ETHN==3 & sample_final==1 
replace RACE_ETHN3=0 if RACE_ETHN3~=1 & sample4==1

**MEN***************************************

capture drop MEN_FINAL
capture drop MEN_FINAL
gen MEN_FINAL=.
replace MEN_FINAL=1 if AGE>=50 & AGE~=.  & sample_final==1 & SEX==1
replace MEN_FINAL=0 if MEN_FINAL~=1 & sample4==1


capture drop WHITEMEN
gen WHITEMEN=.
replace WHITEMEN=1 if AGE>=50 & AGE~=. & RACE_ETHN==0 & sample_final==1 & SEX==1
replace WHITEMEN=0 if WHITEMEN~=1 & sample4==1 & SEX==1


capture drop BLACKMEN
gen BLACKMEN=.
replace BLACKMEN=1 if AGE>=50 & AGE~=. & RACE_ETHN==1 & sample_final==1 & SEX==1
replace BLACKMEN=0 if BLACKMEN~=1 & sample4==1 & SEX==1


capture drop SAMEN
gen SAMEN=.
replace SAMEN=1 if AGE>=50 & AGE~=. & RACE_ETHN==2 & sample_final==1 & SEX==1
replace SAMEN=0 if SAMEN~=1 & sample4==1 & SEX==1


capture drop OTHERMEN
gen OTHERMEN=.
replace OTHERMEN=1 if AGE>=50 & AGE~=. & RACE_ETHN==3 & sample_final==1 & SEX==1
replace OTHERMEN=0 if OTHERMEN~=1 & sample4==1 & SEX==1


*******WOMEN*****************************
capture drop WOMEN_FINAL
capture drop WOMEN_FINAL
gen WOMEN_FINAL=.
replace WOMEN_FINAL=1 if AGE>=50 & AGE~=. & sample_final==1  & SEX==2
replace WOMEN_FINAL=0 if WOMEN_FINAL~=1 & sample_final==1



capture drop WHITEWOMEN
gen WHITEWOMEN=.
replace WHITEWOMEN=1 if AGE>=50 & AGE~=. & RACE_ETHN==0 & sample_final==1 & SEX==2
replace WHITEWOMEN=0 if WHITEWOMEN~=1 & sample_final==1 & SEX==2


capture drop BLACKWOMEN
gen BLACKWOMEN=.
replace BLACKWOMEN=1 if AGE>=50 & AGE~=. & RACE_ETHN==1 & sample_final==1 & SEX==2
replace BLACKWOMEN=0 if BLACKWOMEN~=1 & sample_final==1 & SEX==2


capture drop SAWOMEN
gen SAWOMEN=.
replace SAWOMEN=1 if AGE>=50 & AGE~=. & RACE_ETHN==2 & sample_final==1 & SEX==2
replace SAWOMEN=0 if SAWOMEN~=1 & sample_final==1 & SEX==2


capture drop OTHERWOMEN
gen OTHERWOMEN=.
replace OTHERWOMEN=1 if AGE>=50 & AGE~=. & RACE_ETHN==3 & sample_final==1 & SEX==2
replace OTHERWOMEN=0 if OTHERWOMEN~=1 & sample_final==1 & SEX==2


***************RE-GENERATE MEDIATORS AND RUN PCA**************


**SES: educationbr townsend householdincome**
capture drop SES

capture drop zeducationbr
 egen zeducationbr=std(educationbr) if  sample_final==1

capture drop ztownsend
 egen ztownsend=std(townsend) if sample_final==1


capture drop zhouseholdincome
 egen zhouseholdincome=std(householdincome) if sample_final==1 


capture drop ztownsendinv
gen ztownsendinv=ztownsend*-1

capture drop SES
egen SES=rowmean(zeducationbr zhouseholdincome ztownsendinv)

tabstat SES, statistics(count mean sd)
  mean SES if sample_final==1
  reg SES zeducationbr ztownsendinv zhouseholdincome if sample_final==1


pca zeducationbr ztownsendinv zhouseholdincome if sample_final==1 , factors(1)

**SMOKING**

capture drop SMOKING

capture drop zsmoking
 egen zsmoking=std(smoking) if sample_final==1

capture drop zetsmoke
 egen zetsmoke=std(etsmoke) if sample_final==1

capture drop zpackyearssmoke
 egen zpackyearssmoke=std(packyearssmoke) if sample_final==1



capture drop SMOKING
 egen SMOKING=rmean(zsmoking zetsmoke zpackyearssmoke)


tabstat SMOKING, statistics(count mean sd)
  mean SMOKING if sample_final==1
  reg SMOKING smoking etsmoke packyearssmoke if sample_final==1

pca  smoking etsmoke packyearssmoke, factors(1)


**ALCOHOL**

capture drop ALCOHOL

capture drop zalcohol
 egen zalcohol=std(alcohol) if sample_final==1


capture drop ALCOHOL
 egen ALCOHOL=rmean(zalcohol) if sample_final==1


tabstat ALCOHOL, statistics(count mean sd)
  mean ALCOHOL if sample_final==1
  reg ALCOHOL alcohol if sample_final==1


**PA**
capture drop PA

capture drop zMETmin
 egen zMETmin=std(METmin) if sample_final==1 

capture drop PA
 egen PA=rmean(zMETmin) if sample_final==1



tabstat PA, statistics(count mean sd)
  mean PA if sample_final==1
  reg PA METmin if sample_final==1


**DIET**

capture drop DIET

capture drop zHDI_TOTALSCORE 
 egen zHDI_TOTALSCORE=std(HDI_TOTALSCORE) if sample_final==1


capture drop DIET
 gen DIET=zHDI_TOTALSCORE 
 


tabstat DIET, statistics(count mean sd)
  mean DIET if sample_final==1


**NUTR**

capture drop NUTR

capture drop zvitamind
 egen zvitamind=std(vitamind) if sample_final==1


capture drop zrdw
 egen zrdw=std(rdw) if sample_final==1


capture drop zrdwinv
 gen zrdwinv=zrdw*-1 if sample_final==1


capture drop NUTR
egen NUTR=rmean(zvitamind zrdwinv) if sample_final==1


tabstat NUTR, statistics(count mean sd)
  mean NUTR if sample_final==1
  reg NUTR vitamind rdw if sample_final==1

pca vitamind rdw , factors(1)

**SS**

capture drop SS

capture drop zSS_friendsfamily
 egen zSS_friendsfamily=std(SS_friendsfamily) if sample_final==1


capture drop zSS_leisuresocial
 egen zSS_leisuresocial=std(SS_leisuresocial) if sample_final==1

capture drop zSS_abilityconfide
 egen zSS_abilityconfide=std(SS_abilityconfide) if sample_final==1

 
capture drop SS
egen SS=rmean(zSS_friendsfamily zSS_leisuresocial zSS_abilityconfide) if sample_final==1
 
tabstat SS, statistics(count mean sd)
  mean SS if sample_final==1
  reg SS SS_friendsfamily SS_leisuresocial SS_abilityconfide if sample_final==1

  
  
pca SS_friendsfamily SS_leisuresocial SS_abilityconfide if sample_final==1 , factors(1)

**HEALTH***************


capture drop HEALTH

capture drop zcomorbid
 egen zcomorbid=std(comorbid) if sample_final==1


capture drop zbmi
 egen zbmi=std(bmi) if sample_final==1

capture drop zsrh
 egen zsrh=std(srhbr) if sample_final==1

capture drop zallostatic
 egen zallostatic=std(allostatic) if sample_final==1


capture drop HEALTH
 egen HEALTH=rmean(zcomorbid zbmi zsrh zallostatic) if sample_final==1 


tabstat HEALTH, statistics(count mean sd)
  mean HEALTH if sample_final==1
  reg HEALTH comorbid bmi srh allostatic if sample_final==1

pca comorbid bmi srhbr allostatic if sample_final==1 , factors(1)


**POORCOGN*************

capture drop POORCOGN

capture drop zREACTION_TIME
 egen zREACTION_TIME=std(REACTION_TIME) if sample_final==1


capture drop zPAIRSMATCHING_INC
 egen zPAIRSMATCHING_INC=std(PAIRSMATCHING_INC) if sample_final==1

capture drop zPAIRSMATCHING_TTC
 egen zPAIRSMATCHING_TTC=std(PAIRSMATCHING_TTC) if sample_final==1



capture drop POORCOGN
 egen POORCOGN=rmean(zREACTION_TIME zPAIRSMATCHING_INC zPAIRSMATCHING_TTC) if sample_final==1


tabstat POORCOGN, statistics(count mean sd)
  mean POORCOGN if sample_final==1
  reg POORCOGN REACTION_TIME PAIRSMATCHING_INC PAIRSMATCHING_TTC if sample_final==1

pca REACTION_TIME PAIRSMATCHING_INC PAIRSMATCHING_TTC if sample_final==1, factors(1)

save, replace

********************************LE8_BIOLOGICAL LE8LIFESYLTE**************************************************
capture drop zLE8_BIOLOGICAL
egen zLE8_BIOLOGICAL=std(LE8_BIOLOGICAL) if sample_final==1

capture drop zLE8_LIFESTYLE
egen zLE8_LIFESTYLE=std(LE8_LIFESTYLE) if sample_final==1


save, replace

**************************************************************MAIN PART OF THE ANALYSIS************************************************


capture log close
capture log using "E:\UK_BIOBANK_PROJECT\UKB_PAPER1_RACESESDEM\OUTPUT\TABLE1_UNIMPUTED.smcl"

use finaldata_unimputed,clear

**********TABLE 1: ***************

****OVERALL****

su AGE if sample_final==1  
tab SEX if sample_final==1
tab RACE_ETHN if sample_final==1
su householdsize if sample_final==1
tab educationbr if sample_final==1
tab householdincome if sample_final==1
su townsend if sample_final==1
su SES if sample_final==1
tab smoking if sample_final==1
su etsmoke if sample_final==1 
su packyearssmoke if sample_final==1 
su SMOKE if sample_final==1
tab alcohol if sample_final==1
su ALCOHOL if sample_final==1
su METmin if sample_final==1
su PA if sample_final==1
su HDI_TOTALSCORE if sample_final==1
su DIET if sample_final==1
su vitamind if sample_final==1
su rdw if sample_final==1
su NUTR if sample_final==1
su SS_friendsfamily if sample_final==1
su SS_leisuresocial if sample_final==1
su SS_abilityconfide if sample_final==1
su SS if sample_final==1
su bmi if sample_final==1
su allostatic if sample_final==1
su comorbid if sample_final==1
tab srhbr if sample_final==1
su HEALTH if sample_final==1
su LE8* if sample_final==1
su REACTION_TIME if sample_final==1
su PAIRSMATCHING_INC if sample_final==1
su PAIRSMATCHING_TTC if sample_final==1
su POORCOGN if sample_final==1
tab dem_diag if sample_final==1
tab ad_diag if sample_final==1


save, replace


*****ALL MALES PARTICIPANTS***


su AGE if MEN_FINAL==1  
tab SEX if MEN_FINAL==1
tab RACE_ETHN if MEN_FINAL==1
su householdsize if MEN_FINAL==1
tab educationbr if MEN_FINAL==1
tab householdincome if MEN_FINAL==1
su townsend if MEN_FINAL==1
su SES if MEN_FINAL==1
tab smoking if MEN_FINAL==1
su etsmoke if MEN_FINAL==1 
su packyearssmoke if MEN_FINAL==1 
su SMOKE if MEN_FINAL==1 
tab alcohol if MEN_FINAL==1
su ALCOHOL if MEN_FINAL==1
su METmin if MEN_FINAL==1
su PA if MEN_FINAL==1
su HDI_TOTALSCORE if MEN_FINAL==1
su DIET if MEN_FINAL==1
su vitamind if MEN_FINAL==1
su rdw if MEN_FINAL==1
su NUTR if MEN_FINAL==1
su SS_friendsfamily if MEN_FINAL==1
su SS_leisuresocial if MEN_FINAL==1
su SS_abilityconfide if MEN_FINAL==1
su SS if MEN_FINAL==1
su bmi if MEN_FINAL==1
su allostatic if MEN_FINAL==1
su comorbid if MEN_FINAL==1
tab srhbr if MEN_FINAL==1
su HEALTH if MEN_FINAL==1
su LE8* if MEN_FINAL==1
su REACTION_TIME if MEN_FINAL==1
su PAIRSMATCHING_INC if MEN_FINAL==1
su PAIRSMATCHING_TTC if MEN_FINAL==1
su POORCOGN if MEN_FINAL==1
tab dem_diag if MEN_FINAL==1
tab ad_diag if MEN_FINAL==1


***ALL FEMALE PARTICIPANTS***

su AGE if WOMEN_FINAL==1  
tab SEX if WOMEN_FINAL==1
tab RACE_ETHN if WOMEN_FINAL==1
su householdsize if WOMEN_FINAL==1
tab educationbr if WOMEN_FINAL==1
tab householdincome if WOMEN_FINAL==1
su townsend if WOMEN_FINAL==1
su SES if WOMEN_FINAL==1
tab smoking if WOMEN_FINAL==1
su etsmoke if WOMEN_FINAL==1 
su packyearssmoke if WOMEN_FINAL==1 
su SMOKE if WOMEN_FINAL==1 
tab alcohol if WOMEN_FINAL==1
su ALCOHOL if WOMEN_FINAL==1
su METmin if WOMEN_FINAL==1
su PA if WOMEN_FINAL==1
su HDI_TOTALSCORE if WOMEN_FINAL==1
su DIET if WOMEN_FINAL==1
su vitamind if WOMEN_FINAL==1
su rdw if WOMEN_FINAL==1
su NUTR if WOMEN_FINAL==1
su SS_friendsfamily if WOMEN_FINAL==1
su SS_leisuresocial if WOMEN_FINAL==1
su SS_abilityconfide if WOMEN_FINAL==1
su SS if WOMEN_FINAL==1
su bmi if WOMEN_FINAL==1
su allostatic if WOMEN_FINAL==1
su comorbid if WOMEN_FINAL==1
tab srhbr if WOMEN_FINAL==1
su HEALTH if WOMEN_FINAL==1
su LE8* if WOMEN_FINAL==1
su REACTION_TIME if WOMEN_FINAL==1
su PAIRSMATCHING_INC if WOMEN_FINAL==1
su PAIRSMATCHING_TTC if WOMEN_FINAL==1
su POORCOGN if WOMEN_FINAL==1
tab dem_diag if WOMEN_FINAL==1
tab ad_diag if WOMEN_FINAL==1


***DIFFERENCE BY SEX**


reg AGE SEX if sample_final==1  
mlogit RACE_ETHN SEX if sample_final==1, baseoutcome(1)
reg householdsize SEX if sample_final==1
mlogit educationbr SEX if sample_final==1, baseoutcome(0)
reg householdincome SEX if sample_final==1
reg townsend SEX if sample_final==1
reg SES SEX if sample_final==1
mlogit smoking SEX if sample_final==1, baseoutcome(0)
reg etsmoke SEX if sample_final==1 
reg SMOKE SEX if sample_final==1 
reg packyearssmoke SEX if sample_final==1 
mlogit alcohol SEX if sample_final==1, baseoutcome(0)
reg ALCOHOL SEX if sample_final==1
reg METmin SEX if sample_final==1
reg PA SEX if sample_final==1
reg HDI_TOTALSCORE SEX if sample_final==1
reg DIET SEX if sample_final==1
reg vitamind SEX if sample_final==1
reg rdw SEX if sample_final==1
reg NUTR SEX if sample_final==1
reg SS_friendsfamily SEX if sample_final==1
reg SS_leisuresocial SEX if sample_final==1
reg SS_abilityconfide SEX if sample_final==1
reg SS SEX if sample_final==1
reg bmi SEX if sample_final==1
reg allostatic SEX if sample_final==1
reg comorbid SEX if sample_final==1
reg srhbr SEX if sample_final==1
reg HEALTH SEX if sample_final==1
foreach x of varlist LE8* {
reg `x' SEX if sample_final==1	
}
reg REACTION_TIME SEX if sample_final==1
reg PAIRSMATCHING_INC SEX if sample_final==1
reg PAIRSMATCHING_TTC SEX if sample_final==1
reg POORCOGN SEX if sample_final==1
logit dem_diag SEX if sample_final==1
logit ad_diag SEX if sample_final==1

*************************************DIFFERENCE BY RACE: NON-WHITE VS. WHITE////////////////////////////////////////////////////////////

reg AGE NonWhite if sample_final==1  
mlogit SEX NonWhite if sample_final==1, baseoutcome(1)
reg householdsize NonWhite if sample_final==1
mlogit educationbr NonWhite if sample_final==1, baseoutcome(0)
reg householdincome NonWhite if sample_final==1
reg townsend NonWhite if sample_final==1
reg SES NonWhite if sample_final==1
mlogit smoking NonWhite if sample_final==1, baseoutcome(0)
reg etsmoke NonWhite if sample_final==1 
reg packyearssmoke NonWhite if sample_final==1 
reg SMOKE NonWhite if sample_final==1 
mlogit alcohol NonWhite if sample_final==1, baseoutcome(0)
reg ALCOHOL NonWhite if sample_final==1
reg METmin NonWhite if sample_final==1
reg PA NonWhite if sample_final==1
reg HDI_TOTALSCORE NonWhite if sample_final==1
reg DIET NonWhite if sample_final==1
reg vitamind NonWhite if sample_final==1
reg rdw NonWhite if sample_final==1
reg NUTR NonWhite if sample_final==1
reg SS_friendsfamily NonWhite if sample_final==1
reg SS_leisuresocial NonWhite if sample_final==1
reg SS_abilityconfide NonWhite if sample_final==1
reg SS NonWhite if sample_final==1
reg bmi NonWhite if sample_final==1
reg allostatic NonWhite if sample_final==1
reg comorbid NonWhite if sample_final==1
reg srhbr NonWhite if sample_final==1
reg HEALTH NonWhite if sample_final==1
foreach x of varlist LE8* {
reg `x' NonWhite if sample_final==1	
}
reg REACTION_TIME NonWhite if sample_final==1
reg PAIRSMATCHING_INC NonWhite if sample_final==1
reg PAIRSMATCHING_TTC NonWhite if sample_final==1
reg POORCOGN NonWhite if sample_final==1
logit dem_diag NonWhite if sample_final==1
logit ad_diag NonWhite if sample_final==1


*******************************************AMONG WHITES*********************************************************************************

su AGE if sample_final==1 & NonWhite==0  
tab SEX if sample_final==1 & NonWhite==0
tab RACE_ETHN if sample_final==1 & NonWhite==0
su householdsize if sample_final==1 & NonWhite==0
tab educationbr if sample_final==1 & NonWhite==0
tab householdincome if sample_final==1 & NonWhite==0
su townsend if sample_final==1 & NonWhite==0
su SES if sample_final==1 & NonWhite==0
tab smoking if sample_final==1 & NonWhite==0
su etsmoke if sample_final==1 & NonWhite==0 
su packyearssmoke if sample_final==1 & NonWhite==0 
su SMOKE if sample_final==1 & NonWhite==0 
tab alcohol if sample_final==1 & NonWhite==0
su ALCOHOL if sample_final==1 & NonWhite==0
su METmin if sample_final==1 & NonWhite==0
su PA if sample_final==1 & NonWhite==0
su HDI_TOTALSCORE if sample_final==1 & NonWhite==0
su DIET if sample_final==1 & NonWhite==0
su vitamind if sample_final==1 & NonWhite==0
su rdw if sample_final==1 & NonWhite==0
su NUTR if sample_final==1 & NonWhite==0
su SS_friendsfamily if sample_final==1 & NonWhite==0
su SS_leisuresocial if sample_final==1 & NonWhite==0
su SS_abilityconfide if sample_final==1 & NonWhite==0
su SS if sample_final==1 & NonWhite==0
su bmi if sample_final==1 & NonWhite==0
su allostatic if sample_final==1 & NonWhite==0
su comorbid if sample_final==1 & NonWhite==0
tab srhbr if sample_final==1 & NonWhite==0
su HEALTH if sample_final==1 & NonWhite==0
su LE8* if sample_final==1 & NonWhite==0
su REACTION_TIME if sample_final==1 & NonWhite==0
su PAIRSMATCHING_INC if sample_final==1 & NonWhite==0
su PAIRSMATCHING_TTC if sample_final==1 & NonWhite==0
su POORCOGN if sample_final==1 & NonWhite==0
tab dem_diag if sample_final==1 & NonWhite==0
tab ad_diag if sample_final==1 & NonWhite==0




*******************************************AMONG NON-WHITES*****************************************************************************

su AGE if sample_final==1 & NonWhite==1  
tab SEX if sample_final==1 & NonWhite==1
tab RACE_ETHN if sample_final==1 & NonWhite==1
su householdsize if sample_final==1 & NonWhite==1
tab educationbr if sample_final==1 & NonWhite==1
tab householdincome if sample_final==1 & NonWhite==1
su townsend if sample_final==1 & NonWhite==1
su SES if sample_final==1 & NonWhite==1
tab smoking if sample_final==1 & NonWhite==1
su etsmoke if sample_final==1 & NonWhite==1 
su packyearssmoke if sample_final==1 & NonWhite==1 
su SMOKE if sample_final==1 & NonWhite==1 
tab alcohol if sample_final==1 & NonWhite==1
su ALCOHOL if sample_final==1 & NonWhite==1
su METmin if sample_final==1 & NonWhite==1
su PA if sample_final==1 & NonWhite==1
su HDI_TOTALSCORE if sample_final==1 & NonWhite==1
su DIET if sample_final==1 & NonWhite==1
su vitamind if sample_final==1 & NonWhite==1
su rdw if sample_final==1 & NonWhite==1
su NUTR if sample_final==1 & NonWhite==1
su SS_friendsfamily if sample_final==1 & NonWhite==1
su SS_leisuresocial if sample_final==1 & NonWhite==1
su SS_abilityconfide if sample_final==1 & NonWhite==1
su SS if sample_final==1 & NonWhite==1
su bmi if sample_final==1 & NonWhite==1
su allostatic if sample_final==1 & NonWhite==1
su comorbid if sample_final==1 & NonWhite==1
tab srhbr if sample_final==1 & NonWhite==1
su HEALTH if sample_final==1 & NonWhite==1
su LE8* if sample_final==1 & NonWhite==1
su REACTION_TIME if sample_final==1 & NonWhite==1
su PAIRSMATCHING_INC if sample_final==1 & NonWhite==1
su PAIRSMATCHING_TTC if sample_final==1 & NonWhite==1
su POORCOGN if sample_final==1 & NonWhite==1
tab dem_diag if sample_final==1 & NonWhite==1
tab ad_diag if sample_final==1 & NonWhite==1

****************************************************AMONG MEN, DIFFERENCE BY RACE/ETHNICITY AND DISTRIBUTION****************************


*************************************DIFFERENCE BY RACE: NON-WHITE VS. WHITE////////////////////////////////////////////////////////////

reg AGE NonWhite if sample_final==1 & SEX==1  
reg householdsize NonWhite if sample_final==1 & SEX==1
mlogit educationbr NonWhite if sample_final==1 & SEX==1, baseoutcome(0)
reg householdincome NonWhite if sample_final==1 & SEX==1
reg townsend NonWhite if sample_final==1 & SEX==1
reg SES NonWhite if sample_final==1 & SEX==1
mlogit smoking NonWhite if sample_final==1 & SEX==1, baseoutcome(0)
reg etsmoke NonWhite if sample_final==1 & SEX==1 
reg packyearssmoke NonWhite if sample_final==1 & SEX==1 
reg SMOKE NonWhite if sample_final==1 & SEX==1 
mlogit alcohol NonWhite if sample_final==1 & SEX==1, baseoutcome(0)
reg ALCOHOL NonWhite if sample_final==1 & SEX==1
reg METmin NonWhite if sample_final==1 & SEX==1
reg PA NonWhite if sample_final==1 & SEX==1
reg HDI_TOTALSCORE NonWhite if sample_final==1 & SEX==1
reg DIET NonWhite if sample_final==1 & SEX==1
reg vitamind NonWhite if sample_final==1 & SEX==1
reg rdw NonWhite if sample_final==1 & SEX==1
reg NUTR NonWhite if sample_final==1 & SEX==1
reg SS_friendsfamily NonWhite if sample_final==1 & SEX==1
reg SS_leisuresocial NonWhite if sample_final==1 & SEX==1
reg SS_abilityconfide NonWhite if sample_final==1 & SEX==1
reg SS NonWhite if sample_final==1 & SEX==1
reg bmi NonWhite if sample_final==1 & SEX==1
reg allostatic NonWhite if sample_final==1 & SEX==1
reg comorbid NonWhite if sample_final==1 & SEX==1
reg srhbr NonWhite if sample_final==1 & SEX==1
reg HEALTH NonWhite if sample_final==1 & SEX==1
foreach x of varlist LE8* {
reg `x' NonWhite if sample_final==1 & SEX==1	
}
reg REACTION_TIME NonWhite if sample_final==1 & SEX==1
reg PAIRSMATCHING_INC NonWhite if sample_final==1 & SEX==1
reg PAIRSMATCHING_TTC NonWhite if sample_final==1 & SEX==1
reg POORCOGN NonWhite if sample_final==1 & SEX==1
logit dem_diag NonWhite if sample_final==1 & SEX==1
logit ad_diag NonWhite if sample_final==1 & SEX==1


*******************************************AMONG WHITES*********************************************************************************

su AGE if sample_final==1 & SEX==1 & NonWhite==0  
tab SEX if sample_final==1 & SEX==1 & NonWhite==0
tab RACE_ETHN if sample_final==1 & SEX==1 & NonWhite==0
su householdsize if sample_final==1 & SEX==1 & NonWhite==0
tab educationbr if sample_final==1 & SEX==1 & NonWhite==0
tab householdincome if sample_final==1 & SEX==1 & NonWhite==0
su townsend if sample_final==1 & SEX==1 & NonWhite==0
su SES if sample_final==1 & SEX==1 & NonWhite==0
tab smoking if sample_final==1 & SEX==1 & NonWhite==0
su etsmoke if sample_final==1 & SEX==1 & NonWhite==0 
su packyearssmoke if sample_final==1 & SEX==1 & NonWhite==0 
su SMOKE if sample_final==1 & SEX==1 & NonWhite==0 
tab alcohol if sample_final==1 & SEX==1 & NonWhite==0
su ALCOHOL if sample_final==1 & SEX==1 & NonWhite==0
su METmin if sample_final==1 & SEX==1 & NonWhite==0
su PA if sample_final==1 & SEX==1 & NonWhite==0
su HDI_TOTALSCORE if sample_final==1 & SEX==1 & NonWhite==0
su DIET if sample_final==1 & SEX==1 & NonWhite==0
su vitamind if sample_final==1 & SEX==1 & NonWhite==0
su rdw if sample_final==1 & SEX==1 & NonWhite==0
su NUTR if sample_final==1 & SEX==1 & NonWhite==0
su SS_friendsfamily if sample_final==1 & SEX==1 & NonWhite==0
su SS_leisuresocial if sample_final==1 & SEX==1 & NonWhite==0
su SS_abilityconfide if sample_final==1 & SEX==1 & NonWhite==0
su SS if sample_final==1 & SEX==1 & NonWhite==0
su bmi if sample_final==1 & SEX==1 & NonWhite==0
su allostatic if sample_final==1 & SEX==1 & NonWhite==0
su comorbid if sample_final==1 & SEX==1 & NonWhite==0
tab srhbr if sample_final==1 & SEX==1 & NonWhite==0
su HEALTH if sample_final==1 & SEX==1 & NonWhite==0
su LE8* if sample_final==1 & SEX==1 & NonWhite==0
su REACTION_TIME if sample_final==1 & SEX==1 & NonWhite==0
su PAIRSMATCHING_INC if sample_final==1 & SEX==1 & NonWhite==0
su PAIRSMATCHING_TTC if sample_final==1 & SEX==1 & NonWhite==0
su POORCOGN if sample_final==1 & SEX==1 & NonWhite==0
tab dem_diag if sample_final==1 & SEX==1 & NonWhite==0
tab ad_diag if sample_final==1 & SEX==1 & NonWhite==0




*******************************************AMONG NON-WHITES*****************************************************************************

su AGE if sample_final==1 & SEX==1 & NonWhite==1  
tab SEX if sample_final==1 & SEX==1 & NonWhite==1
tab RACE_ETHN if sample_final==1 & SEX==1 & NonWhite==1
su householdsize if sample_final==1 & SEX==1 & NonWhite==1
tab educationbr if sample_final==1 & SEX==1 & NonWhite==1
tab householdincome if sample_final==1 & SEX==1 & NonWhite==1
su townsend if sample_final==1 & SEX==1 & NonWhite==1
su SES if sample_final==1 & SEX==1 & NonWhite==1
tab smoking if sample_final==1 & SEX==1 & NonWhite==1
su etsmoke if sample_final==1 & SEX==1 & NonWhite==1 
su packyearssmoke if sample_final==1 & SEX==1 & NonWhite==1 
su SMOKE if sample_final==1 & SEX==1 & NonWhite==1 
tab alcohol if sample_final==1 & SEX==1 & NonWhite==1
su ALCOHOL if sample_final==1 & SEX==1 & NonWhite==1
su METmin if sample_final==1 & SEX==1 & NonWhite==1
su PA if sample_final==1 & SEX==1 & NonWhite==1
su HDI_TOTALSCORE if sample_final==1 & SEX==1 & NonWhite==1
su DIET if sample_final==1 & SEX==1 & NonWhite==1
su vitamind if sample_final==1 & SEX==1 & NonWhite==1
su rdw if sample_final==1 & SEX==1 & NonWhite==1
su NUTR if sample_final==1 & SEX==1 & NonWhite==1
su SS_friendsfamily if sample_final==1 & SEX==1 & NonWhite==1
su SS_leisuresocial if sample_final==1 & SEX==1 & NonWhite==1
su SS_abilityconfide if sample_final==1 & SEX==1 & NonWhite==1
su SS if sample_final==1 & SEX==1 & NonWhite==1
su bmi if sample_final==1 & SEX==1 & NonWhite==1
su allostatic if sample_final==1 & SEX==1 & NonWhite==1
su comorbid if sample_final==1 & SEX==1 & NonWhite==1
tab srhbr if sample_final==1 & SEX==1 & NonWhite==1
su HEALTH if sample_final==1 & SEX==1 & NonWhite==1
su LE8* if sample_final==1 & SEX==1 & NonWhite==1
su REACTION_TIME if sample_final==1 & SEX==1 & NonWhite==1
su PAIRSMATCHING_INC if sample_final==1 & SEX==1 & NonWhite==1
su PAIRSMATCHING_TTC if sample_final==1 & SEX==1 & NonWhite==1
su POORCOGN if sample_final==1 & SEX==1 & NonWhite==1
tab dem_diag if sample_final==1 & SEX==1 & NonWhite==1
tab ad_diag if sample_final==1 & SEX==1 & NonWhite==1

****************************************************AMONG WOMEN, DIFFERENCE BY RACE/ETHNICITY AND DISTRIBUTION****************************


*************************************DIFFERENCE BY RACE: NON-WHITE VS. WHITE////////////////////////////////////////////////////////////

reg AGE NonWhite if sample_final==1 & SEX==2  
reg householdsize NonWhite if sample_final==1 & SEX==2
mlogit educationbr NonWhite if sample_final==1 & SEX==2, baseoutcome(0)
reg householdincome NonWhite if sample_final==1 & SEX==2
reg townsend NonWhite if sample_final==1 & SEX==2
reg SES NonWhite if sample_final==1 & SEX==2
mlogit smoking NonWhite if sample_final==1 & SEX==2, baseoutcome(0)
reg etsmoke NonWhite if sample_final==1 & SEX==2 
reg packyearssmoke NonWhite if sample_final==1 & SEX==2 
reg SMOKE NonWhite if sample_final==1 & SEX==2 
mlogit alcohol NonWhite if sample_final==1 & SEX==2, baseoutcome(0)
reg ALCOHOL NonWhite if sample_final==1 & SEX==2
reg METmin NonWhite if sample_final==1 & SEX==2
reg PA NonWhite if sample_final==1 & SEX==2
reg HDI_TOTALSCORE NonWhite if sample_final==1 & SEX==2
reg DIET NonWhite if sample_final==1 & SEX==2
reg vitamind NonWhite if sample_final==1 & SEX==2
reg rdw NonWhite if sample_final==1 & SEX==2
reg NUTR NonWhite if sample_final==1 & SEX==2
reg SS_friendsfamily NonWhite if sample_final==1 & SEX==2
reg SS_leisuresocial NonWhite if sample_final==1 & SEX==2
reg SS_abilityconfide NonWhite if sample_final==1 & SEX==2
reg SS NonWhite if sample_final==1 & SEX==2
reg bmi NonWhite if sample_final==1 & SEX==2
reg allostatic NonWhite if sample_final==1 & SEX==2
reg comorbid NonWhite if sample_final==1 & SEX==2
reg srhbr NonWhite if sample_final==1 & SEX==2
reg HEALTH NonWhite if sample_final==1 & SEX==2
foreach x of varlist LE8* {
reg `x' NonWhite if sample_final==1 & SEX==2	
}
reg REACTION_TIME NonWhite if sample_final==1 & SEX==2
reg PAIRSMATCHING_INC NonWhite if sample_final==1 & SEX==2
reg PAIRSMATCHING_TTC NonWhite if sample_final==1 & SEX==2
reg POORCOGN NonWhite if sample_final==1 & SEX==2
logit dem_diag NonWhite if sample_final==1 & SEX==2
logit ad_diag NonWhite if sample_final==1 & SEX==2


*******************************************AMONG WHITES*********************************************************************************

su AGE if sample_final==1 & SEX==2 & NonWhite==0  
tab SEX if sample_final==1 & SEX==2 & NonWhite==0
tab RACE_ETHN if sample_final==1 & SEX==2 & NonWhite==0
su householdsize if sample_final==1 & SEX==2 & NonWhite==0
tab educationbr if sample_final==1 & SEX==2 & NonWhite==0
tab householdincome if sample_final==1 & SEX==2 & NonWhite==0
su townsend if sample_final==1 & SEX==2 & NonWhite==0
su SES if sample_final==1 & SEX==2 & NonWhite==0
tab smoking if sample_final==1 & SEX==2 & NonWhite==0
su etsmoke if sample_final==1 & SEX==2 & NonWhite==0 
su packyearssmoke if sample_final==1 & SEX==2 & NonWhite==0 
su SMOKE if sample_final==1 & SEX==2 & NonWhite==0 
tab alcohol if sample_final==1 & SEX==2 & NonWhite==0
su ALCOHOL if sample_final==1 & SEX==2 & NonWhite==0
su METmin if sample_final==1 & SEX==2 & NonWhite==0
su PA if sample_final==1 & SEX==2 & NonWhite==0
su HDI_TOTALSCORE if sample_final==1 & SEX==2 & NonWhite==0
su DIET if sample_final==1 & SEX==2 & NonWhite==0
su vitamind if sample_final==1 & SEX==2 & NonWhite==0
su rdw if sample_final==1 & SEX==2 & NonWhite==0
su NUTR if sample_final==1 & SEX==2 & NonWhite==0
su SS_friendsfamily if sample_final==1 & SEX==2 & NonWhite==0
su SS_leisuresocial if sample_final==1 & SEX==2 & NonWhite==0
su SS_abilityconfide if sample_final==1 & SEX==2 & NonWhite==0
su SS if sample_final==1 & SEX==2 & NonWhite==0
su bmi if sample_final==1 & SEX==2 & NonWhite==0
su allostatic if sample_final==1 & SEX==2 & NonWhite==0
su comorbid if sample_final==1 & SEX==2 & NonWhite==0
tab srhbr if sample_final==1 & SEX==2 & NonWhite==0
su HEALTH if sample_final==1 & SEX==2 & NonWhite==0
su LE8* if sample_final==1 & SEX==2 & NonWhite==0
su REACTION_TIME if sample_final==1 & SEX==2 & NonWhite==0
su PAIRSMATCHING_INC if sample_final==1 & SEX==2 & NonWhite==0
su PAIRSMATCHING_TTC if sample_final==1 & SEX==2 & NonWhite==0
su POORCOGN if sample_final==1 & SEX==2 & NonWhite==0
tab dem_diag if sample_final==1 & SEX==2 & NonWhite==0
tab ad_diag if sample_final==1 & SEX==2 & NonWhite==0




*******************************************AMONG NON-WHITES*****************************************************************************

su AGE if sample_final==1 & SEX==2 & NonWhite==1  
tab SEX if sample_final==1 & SEX==2 & NonWhite==1
tab RACE_ETHN if sample_final==1 & SEX==2 & NonWhite==1
su householdsize if sample_final==1 & SEX==2 & NonWhite==1
tab educationbr if sample_final==1 & SEX==2 & NonWhite==1
tab householdincome if sample_final==1 & SEX==2 & NonWhite==1
su townsend if sample_final==1 & SEX==2 & NonWhite==1
su SES if sample_final==1 & SEX==2 & NonWhite==1
tab smoking if sample_final==1 & SEX==2 & NonWhite==1
su etsmoke if sample_final==1 & SEX==2 & NonWhite==1 
su packyearssmoke if sample_final==1 & SEX==2 & NonWhite==1 
su SMOKE if sample_final==1 & SEX==2 & NonWhite==1 
tab alcohol if sample_final==1 & SEX==2 & NonWhite==1
su ALCOHOL if sample_final==1 & SEX==2 & NonWhite==1
su METmin if sample_final==1 & SEX==2 & NonWhite==1
su PA if sample_final==1 & SEX==2 & NonWhite==1
su HDI_TOTALSCORE if sample_final==1 & SEX==2 & NonWhite==1
su DIET if sample_final==1 & SEX==2 & NonWhite==1
su vitamind if sample_final==1 & SEX==2 & NonWhite==1
su rdw if sample_final==1 & SEX==2 & NonWhite==1
su NUTR if sample_final==1 & SEX==2 & NonWhite==1
su SS_friendsfamily if sample_final==1 & SEX==2 & NonWhite==1
su SS_leisuresocial if sample_final==1 & SEX==2 & NonWhite==1
su SS_abilityconfide if sample_final==1 & SEX==2 & NonWhite==1
su SS if sample_final==1 & SEX==2 & NonWhite==1
su bmi if sample_final==1 & SEX==2 & NonWhite==1
su allostatic if sample_final==1 & SEX==2 & NonWhite==1
su comorbid if sample_final==1 & SEX==2 & NonWhite==1
tab srhbr if sample_final==1 & SEX==2 & NonWhite==1
su HEALTH if sample_final==1 & SEX==2 & NonWhite==1
su LE8* if sample_final==1 & SEX==2 & NonWhite==1
su REACTION_TIME if sample_final==1 & SEX==2 & NonWhite==1
su PAIRSMATCHING_INC if sample_final==1 & SEX==2 & NonWhite==1
su PAIRSMATCHING_TTC if sample_final==1 & SEX==2 & NonWhite==1
su POORCOGN if sample_final==1 & SEX==2 & NonWhite==1
tab dem_diag if sample_final==1 & SEX==2 & NonWhite==1
tab ad_diag if sample_final==1 & SEX==2 & NonWhite==1


save, replace


******************************************************************************************



*************stsum code******************************


**AD INCIDENCE**

stset Age_AD, failure(ad_diag==1) enter(baselineage) id(n_eid) scale(1)

stsum if sample_final==1 & sex==1
stsum if sample_final==1 & sex==1 & RACE_ETHN==0
stsum if sample_final==1 & sex==1 & RACE_ETHN==1
stsum if sample_final==1 & sex==1 & RACE_ETHN==2
stsum if sample_final==1 & sex==1 & RACE_ETHN==3


stsum if sample_final==1 & sex==2
stsum if sample_final==1 & sex==2 & RACE_ETHN==0
stsum if sample_final==1 & sex==2 & RACE_ETHN==1
stsum if sample_final==1 & sex==2 & RACE_ETHN==2
stsum if sample_final==1 & sex==2 & RACE_ETHN==3

stptime if sample_final==1 & sex==1
stptime if sample_final==1 & sex==1 & RACE_ETHN==0
stptime if sample_final==1 & sex==1 & RACE_ETHN==1
stptime if sample_final==1 & sex==1 & RACE_ETHN==2
stptime if sample_final==1 & sex==1 & RACE_ETHN==3

stptime if sample_final==1 & sex==2
stptime if sample_final==1 & sex==2 & RACE_ETHN==0
stptime if sample_final==1 & sex==2 & RACE_ETHN==1
stptime if sample_final==1 & sex==2 & RACE_ETHN==2
stptime if sample_final==1 & sex==2 & RACE_ETHN==3

capture drop NonWhite
gen NonWhite=.
replace NonWhite=1 if RACE_ETHN==1 | RACE_ETHN==2 | RACE_ETHN==3
replace NonWhite=0 if RACE_ETHN==0

save, replace



**DEMENTIA INCIDENCE**

stset Age_dementia, failure(dem_diag==1) enter(baselineage) id(n_eid) scale(1)

stsum if sample_final==1 & sex==1
stsum if sample_final==1 & sex==1 & RACE_ETHN==0
stsum if sample_final==1 & sex==1 & RACE_ETHN==1
stsum if sample_final==1 & sex==1 & RACE_ETHN==2
stsum if sample_final==1 & sex==1 & RACE_ETHN==3


stsum if sample_final==1 & sex==2
stsum if sample_final==1 & sex==2 & RACE_ETHN==0
stsum if sample_final==1 & sex==2 & RACE_ETHN==1
stsum if sample_final==1 & sex==2 & RACE_ETHN==2
stsum if sample_final==1 & sex==2 & RACE_ETHN==3

stptime if sample_final==1 & sex==1
stptime if sample_final==1 & sex==1 & RACE_ETHN==0
stptime if sample_final==1 & sex==1 & RACE_ETHN==1
stptime if sample_final==1 & sex==1 & RACE_ETHN==2
stptime if sample_final==1 & sex==1 & RACE_ETHN==3

stptime if sample_final==1 & sex==2
stptime if sample_final==1 & sex==2 & RACE_ETHN==0
stptime if sample_final==1 & sex==2 & RACE_ETHN==1
stptime if sample_final==1 & sex==2 & RACE_ETHN==2
stptime if sample_final==1 & sex==2 & RACE_ETHN==3

capture drop NonWhite
gen NonWhite=.
replace NonWhite=1 if RACE_ETHN==1 | RACE_ETHN==2 | RACE_ETHN==3
replace NonWhite=0 if RACE_ETHN==0


save, replace

capture log close
capture log using "E:\UK_BIOBANK_PROJECT\UKB_PAPER1_RACESESDEM\OUTPUT\TABLE2.smcl"



**********TABLE 2:****************
use finaldata_unimputed, clear


*************************************************STSET FOR DEMENTIA**********************************
stset Age_dementia, failure(dem_diag==1) enter(baselineage) id(n_eid) scale(1)

***MEN, BLACK VS. WHITE****

**MODEL 1***

 stcox i.RACE_ETHN AGE householdsize invmills if BLACKMEN==1 | WHITEMEN==1

**MODEL 2**
 stcox i.RACE_ETHN AGE householdsize SES invmills if BLACKMEN==1 | WHITEMEN==1

**MODEL 3**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if BLACKMEN==1 | WHITEMEN==1

**MODEL 4**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if BLACKMEN==1 | WHITEMEN==1

**MODEL 5**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if BLACKMEN==1 | WHITEMEN==1


**MODEL 6**
 stcox i.RACE_ETHN AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if BLACKMEN==1 | WHITEMEN==1

**WOMEN, BLACK VS. WHITE**

**MODEL 1***

 stcox i.RACE_ETHN AGE householdsize invmills if BLACKWOMEN==1 | WHITEWOMEN==1

**MODEL 2**
 stcox i.RACE_ETHN AGE householdsize SES invmills if BLACKWOMEN==1 | WHITEWOMEN==1

**MODEL 3**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if BLACKWOMEN==1 | WHITEWOMEN==1

**MODEL 4**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if BLACKWOMEN==1 | WHITEWOMEN==1

**MODEL 5**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if BLACKWOMEN==1 | WHITEWOMEN==1

**MODEL 6**
stcox i.RACE_ETHN AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if BLACKWOMEN==1 | WHITEWOMEN==1


 
 
***MEN, SA VS. WHITE****

**MODEL 1***

 stcox i.RACE_ETHN AGE householdsize invmills if SAMEN==1 | WHITEMEN==1

**MODEL 2**
 stcox i.RACE_ETHN AGE householdsize SES invmills if SAMEN==1 | WHITEMEN==1

**MODEL 3**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if SAMEN==1 | WHITEMEN==1

**MODEL 4**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if SAMEN==1 | WHITEMEN==1

**MODEL 5**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if SAMEN==1 | WHITEMEN==1

**MODEL 6** 
 stcox i.RACE_ETHN AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if SAMEN==1 | WHITEMEN==1


**WOMEN, SA VS. WHITE**

**MODEL 1***

 stcox i.RACE_ETHN AGE householdsize invmills if SAWOMEN==1 | WHITEWOMEN==1

**MODEL 2**
 stcox i.RACE_ETHN AGE householdsize SES invmills if SAWOMEN==1 | WHITEWOMEN==1

**MODEL 3**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if SAWOMEN==1 | WHITEWOMEN==1

**MODEL 4**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if SAWOMEN==1 | WHITEWOMEN==1

**MODEL 5**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if SAWOMEN==1 | WHITEWOMEN==1

**MODEL 6**
 stcox i.RACE_ETHN AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if SAWOMEN==1 | WHITEWOMEN==1

 
****MEN, NON-WHITE VS. WHITE********


**MODEL 1***

 stcox i.NonWhite AGE householdsize invmills if sample_final==1 & SEX==1

**MODEL 2**
 stcox i.NonWhite AGE householdsize SES invmills if sample_final==1 & SEX==1

**MODEL 3**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if sample_final==1 & SEX==1

**MODEL 4**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if sample_final==1 & SEX==1

**MODEL 5**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if sample_final==1 & SEX==1

**MODEL 6**
stcox i.NonWhite AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if sample_final==1 & SEX==1



****WOMEN, NON-WHITE VS. WHITE********



**MODEL 1***

 stcox i.NonWhite AGE householdsize invmills if sample_final==1 & SEX==2

**MODEL 2**
 stcox i.NonWhite AGE householdsize SES invmills if sample_final==1 & SEX==2

**MODEL 3**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if sample_final==1 & SEX==2

**MODEL 4**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if sample_final==1 & SEX==2

**MODEL 5**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if sample_final==1 & SEX==2


**MODEL 6**
stcox i.NonWhite AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if sample_final==1 & SEX==2


****OVERALL, NON-WHITE VS. WHITE*******


**MODEL 1***

 stcox i.NonWhite AGE SEX householdsize invmills if sample_final==1 

**MODEL 2**
 stcox i.NonWhite AGE SEX householdsize SES invmills if sample_final==1 

**MODEL 3**
 stcox i.NonWhite AGE SEX householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if sample_final==1 

**MODEL 4**
 stcox i.NonWhite AGE SEX householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if sample_final==1 

**MODEL 5**
 stcox i.NonWhite AGE SEX householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if sample_final==1 

**MODEL 6**
 stcox i.NonWhite AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if sample_final==1 

save, replace

*************************************************STSET FOR AD**********************************
stset Age_AD, failure(ad_diag==1) enter(baselineage) id(n_eid) scale(1)


***MEN, BLACK VS. WHITE****

**MODEL 1***

 stcox i.RACE_ETHN AGE householdsize invmills if BLACKMEN==1 | WHITEMEN==1

**MODEL 2**
 stcox i.RACE_ETHN AGE householdsize SES invmills if BLACKMEN==1 | WHITEMEN==1

**MODEL 3**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if BLACKMEN==1 | WHITEMEN==1

**MODEL 4**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if BLACKMEN==1 | WHITEMEN==1

**MODEL 5**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if BLACKMEN==1 | WHITEMEN==1


**MODEL 6**
 stcox i.RACE_ETHN AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if BLACKMEN==1 | WHITEMEN==1

**WOMEN, BLACK VS. WHITE**

**MODEL 1***

 stcox i.RACE_ETHN AGE householdsize invmills if BLACKWOMEN==1 | WHITEWOMEN==1

**MODEL 2**
 stcox i.RACE_ETHN AGE householdsize SES invmills if BLACKWOMEN==1 | WHITEWOMEN==1

**MODEL 3**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if BLACKWOMEN==1 | WHITEWOMEN==1

**MODEL 4**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if BLACKWOMEN==1 | WHITEWOMEN==1

**MODEL 5**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if BLACKWOMEN==1 | WHITEWOMEN==1

**MODEL 6**
stcox i.RACE_ETHN AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if BLACKWOMEN==1 | WHITEWOMEN==1


 
 
***MEN, SA VS. WHITE****

**MODEL 1***

 stcox i.RACE_ETHN AGE householdsize invmills if SAMEN==1 | WHITEMEN==1

**MODEL 2**
 stcox i.RACE_ETHN AGE householdsize SES invmills if SAMEN==1 | WHITEMEN==1

**MODEL 3**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if SAMEN==1 | WHITEMEN==1

**MODEL 4**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if SAMEN==1 | WHITEMEN==1

**MODEL 5**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if SAMEN==1 | WHITEMEN==1

**MODEL 6** 
 stcox i.RACE_ETHN AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if SAMEN==1 | WHITEMEN==1


**WOMEN, SA VS. WHITE**

**MODEL 1***

 stcox i.RACE_ETHN AGE householdsize invmills if SAWOMEN==1 | WHITEWOMEN==1

**MODEL 2**
 stcox i.RACE_ETHN AGE householdsize SES invmills if SAWOMEN==1 | WHITEWOMEN==1

**MODEL 3**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if SAWOMEN==1 | WHITEWOMEN==1

**MODEL 4**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if SAWOMEN==1 | WHITEWOMEN==1

**MODEL 5**
 stcox i.RACE_ETHN AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if SAWOMEN==1 | WHITEWOMEN==1

**MODEL 6**
 stcox i.RACE_ETHN AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if SAWOMEN==1 | WHITEWOMEN==1

 
****MEN, NON-WHITE VS. WHITE********


**MODEL 1***

 stcox i.NonWhite AGE householdsize invmills if sample_final==1 & SEX==1

**MODEL 2**
 stcox i.NonWhite AGE householdsize SES invmills if sample_final==1 & SEX==1

**MODEL 3**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if sample_final==1 & SEX==1

**MODEL 4**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if sample_final==1 & SEX==1

**MODEL 5**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if sample_final==1 & SEX==1

**MODEL 6**
stcox i.NonWhite AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if sample_final==1 & SEX==1



****WOMEN, NON-WHITE VS. WHITE********



**MODEL 1***

 stcox i.NonWhite AGE householdsize invmills if sample_final==1 & SEX==2

**MODEL 2**
 stcox i.NonWhite AGE householdsize SES invmills if sample_final==1 & SEX==2

**MODEL 3**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if sample_final==1 & SEX==2

**MODEL 4**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if sample_final==1 & SEX==2

**MODEL 5**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if sample_final==1 & SEX==2


**MODEL 6**
stcox i.NonWhite AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if sample_final==1 & SEX==2


****OVERALL, NON-WHITE VS. WHITE*******


**MODEL 1***

 stcox i.NonWhite AGE SEX householdsize invmills if sample_final==1 

**MODEL 2**
 stcox i.NonWhite AGE SEX householdsize SES invmills if sample_final==1 

**MODEL 3**
 stcox i.NonWhite AGE SEX householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if sample_final==1 

**MODEL 4**
 stcox i.NonWhite AGE SEX householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if sample_final==1 

**MODEL 5**
 stcox i.NonWhite AGE SEX householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if sample_final==1 

**MODEL 6**
 stcox i.NonWhite AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if sample_final==1 


save, replace



capture log close
capture log using "E:\UK_BIOBANK_PROJECT\UKB_PAPER1_RACESESDEM\OUTPUT\TABLE3.smcl"

*********TABLE 3: *****************
use finaldata_unimputed, clear


*************************************************STSET FOR DEMENTIA**********************************
stset Age_dementia, failure(dem_diag==1) enter(baselineage) id(n_eid) scale(1)

****MEN, NON-WHITE VS. WHITE********


**MODEL 1**
 stcox i.NonWhite AGE householdsize SES invmills if sample_final==1 & SEX==1

**MODEL 2**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if sample_final==1 & SEX==1

**MODEL 3**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if sample_final==1 & SEX==1

**MODEL 4**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if sample_final==1 & SEX==1

**MODEL 5**
stcox i.NonWhite AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if sample_final==1 & SEX==1


****WOMEN, NON-WHITE VS. WHITE********


**MODEL 1**
 stcox i.NonWhite AGE householdsize SES invmills if sample_final==1 & SEX==2

**MODEL 2**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if sample_final==1 & SEX==2

**MODEL 3**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if sample_final==1 & SEX==2

**MODEL 4**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if sample_final==1 & SEX==2

**MODEL 5**
stcox i.NonWhite AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if sample_final==1 & SEX==2


****OVERALL, NON-WHITE VS. WHITE*******


**MODEL 1**
 stcox i.NonWhite AGE SEX householdsize SES invmills if sample_final==1 

**MODEL 2**
 stcox i.NonWhite AGE SEX householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if sample_final==1 

**MODEL 3**
 stcox i.NonWhite AGE SEX householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if sample_final==1 

**MODEL 4**
 stcox i.NonWhite AGE SEX householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if sample_final==1 

**MODEL 5**
stcox i.NonWhite AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if sample_final==1 

save, replace

*************************************************STSET FOR AD**********************************
stset Age_AD, failure(ad_diag==1) enter(baselineage) id(n_eid) scale(1)



****MEN, NON-WHITE VS. WHITE********


**MODEL 1**
 stcox i.NonWhite AGE householdsize SES invmills if sample_final==1 & SEX==1

**MODEL 2**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if sample_final==1 & SEX==1

**MODEL 3**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if sample_final==1 & SEX==1

**MODEL 4**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if sample_final==1 & SEX==1

**MODEL 5**
stcox i.NonWhite AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if sample_final==1 & SEX==1


****WOMEN, NON-WHITE VS. WHITE********


**MODEL 1**
 stcox i.NonWhite AGE householdsize SES invmills if sample_final==1 & SEX==2

**MODEL 2**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if sample_final==1 & SEX==2

**MODEL 3**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if sample_final==1 & SEX==2

**MODEL 4**
 stcox i.NonWhite AGE householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if sample_final==1 & SEX==2

**MODEL 5**
stcox i.NonWhite AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if sample_final==1 & SEX==2


****OVERALL, NON-WHITE VS. WHITE*******


**MODEL 1**
 stcox i.NonWhite AGE SEX householdsize SES invmills if sample_final==1 

**MODEL 2**
 stcox i.NonWhite AGE SEX householdsize SES SMOKING PA DIET NUTR SS ALCOHOL invmills if sample_final==1 

**MODEL 3**
 stcox i.NonWhite AGE SEX householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH invmills if sample_final==1 

**MODEL 4**
 stcox i.NonWhite AGE SEX householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN invmills if sample_final==1 

**MODEL 5**
stcox i.NonWhite AGE householdsize SES zLE8_BIOLOGICAL zLE8_LIFESTYLE POORCOGN invmills if sample_final==1 

save, replace

capture log close



***********************************************DEMENTIA MAIN TABLES 4 AND 5******************************************************

capture log using "E:\UK_BIOBANK_PROJECT\UKB_PAPER1_RACESESDEM\OUTPUT\TABLES4_5.smcl"




*******************************************TABLE 4: ***********************************************************************************


use finaldata_unimputed, clear

keep n_eid NonWhite AGE SEX householdsize SES SMOKING PA DIET NUTR SS ALCOHOL HEALTH POORCOGN dem_diag baselineage Age_dementia RACE_ETHN sample* LE8* zLE8* invmills

save finaldata_IMPUTEDDEMENTIALONG,replace


stset Age_dementia, failure(dem_diag==1) enter(baselineage) id(n_eid) scale(1)



************************************************************************
stcox i.RACE_ETHN if sample4==1
stcox i.RACE_ETHN AGE if sample4==1


save, replace

//ACCELERATED FAILURE TIME//

**gsem timevar<- indepvar U1[panel(varname)]@gamma, fam-
**ily(survsubmodel, failure(event) aft))
**[survsubmodel(####) covstruct(U1, ####) startvalues(#) iter-
**ate(#) intmethod(####) intpoints(#)]


************************************************************zLE8_LIFESTYLE and zLE8_BIOLOGICAL************************************************************

********************************************WEIBULL PH MODEL WITH COGNITIVE PERFORMANCE******************************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES zLE8_LIFESTYLE zLE8_BIOLOGICAL POORCOGN invmills, family(weibull, failure(_d) ) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> zLE8_LIFESTYLE, family(gaussian) link(identity)) (SES -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) (NonWhite -> zLE8_LIFESTYLE, family(gaussian) link(identity)) (AGE -> zLE8_LIFESTYLE, family(gaussian) link(identity)) (SEX -> zLE8_LIFESTYLE, family(gaussian) link(identity))  (householdsize -> zLE8_LIFESTYLE, family(gaussian) link(identity)) ///
(zLE8_LIFESTYLE -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) (zLE8_LIFESTYLE -> POORCOGN, family(gaussian) link(identity)) ///
(NonWhite -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) (AGE -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) ///
(SEX -> zLE8_BIOLOGICAL, family(gaussian) link(identity))  (householdsize -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) ///
(zLE8_BIOLOGICAL -> POORCOGN, family(gaussian) link(identity))  ///
(NonWhite -> POORCOGN, family(gaussian) link(identity)) (AGE -> POORCOGN, family(gaussian) link(identity)) ///
(SEX -> POORCOGN, family(gaussian) link(identity)) (householdsize -> POORCOGN, family(gaussian) link(identity)) (SES -> POORCOGN, family(gaussian) link(identity)) (zLE8_LIFESTYLE -> POORCOGN, family(gaussian) link(identity)) (zLE8_BIOLOGICAL -> POORCOGN, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 



 //////////////////INDIRECT EFFECTS FOR RACE//////////////////

 

 
******************Indirect effect THROUGH SES ONLY*****

nlcom _b[_t:SES]*_b[SES:NonWhite]



******************Indirect effect THROUGH SES AND LIFESTYLE FACTORS*****

nlcom (_b[SES:NonWhite]*_b[zLE8_LIFESTYLE:SES]*_b[_t:zLE8_LIFESTYLE])


******************Indirect effect THROUGH SES, LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom (_b[SES:NonWhite]*_b[zLE8_LIFESTYLE:SES]*_b[_t:zLE8_BIOLOGICAL]*_b[zLE8_BIOLOGICAL:zLE8_LIFESTYLE])



******************Indirect effect THROUGH SES, LIFESTYLE FACTORS, HEALTH AND COGNITIVE PERFORMANCE*****


nlcom (_b[SES:NonWhite]*_b[zLE8_LIFESTYLE:SES]*_b[_t:POORCOGN]*_b[POORCOGN:zLE8_BIOLOGICAL]*_b[zLE8_BIOLOGICAL:zLE8_LIFESTYLE])

******************Indirect effect THROUGH SES, LIFESTYLE FACTORS,  AND COGNITIVE PERFORMANCE*****

nlcom (_b[SES:NonWhite]*_b[zLE8_LIFESTYLE:SES]*_b[_t:POORCOGN]*_b[POORCOGN:zLE8_LIFESTYLE])

******************Indirect effect THROUGH SES,  AND COGNITIVE PERFORMANCE*****

nlcom _b[_t:POORCOGN]*_b[SES:NonWhite]*_b[POORCOGN:SES]



********************************WEIBULL PH MODEL WITHOUT POORCOGN**************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES zLE8_LIFESTYLE zLE8_BIOLOGICAL invmills , family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> zLE8_LIFESTYLE, family(gaussian) link(identity)) (SES -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) (NonWhite -> zLE8_LIFESTYLE, family(gaussian) link(identity)) (AGE -> zLE8_LIFESTYLE, family(gaussian) link(identity)) (SEX -> zLE8_LIFESTYLE, family(gaussian) link(identity))  (householdsize -> zLE8_LIFESTYLE, family(gaussian) link(identity)) ///
(zLE8_LIFESTYLE -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) ///
(NonWhite -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) (AGE -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) ///
(SEX -> zLE8_BIOLOGICAL, family(gaussian) link(identity))  (householdsize -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 


******************Indirect effect THROUGH SES ONLY*****

nlcom _b[_t:SES]*_b[SES:NonWhite]



******************Indirect effect THROUGH SES AND LIFESTYLE FACTORS*****

nlcom (_b[SES:NonWhite]*_b[zLE8_LIFESTYLE:SES]*_b[_t:zLE8_LIFESTYLE])


******************Indirect effect THROUGH SES, LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom (_b[SES:NonWhite]*_b[zLE8_LIFESTYLE:SES]*_b[_t:zLE8_BIOLOGICAL]*_b[zLE8_BIOLOGICAL:zLE8_LIFESTYLE])



*************************TABLE 5****************

********************************************WEIBULL PH WITH COGNITIVE PERFORMANCE******************************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES zLE8_LIFESTYLE zLE8_BIOLOGICAL POORCOGN invmills, family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> zLE8_LIFESTYLE, family(gaussian) link(identity)) (SES -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) (NonWhite -> zLE8_LIFESTYLE, family(gaussian) link(identity)) (AGE -> zLE8_LIFESTYLE, family(gaussian) link(identity)) (SEX -> zLE8_LIFESTYLE, family(gaussian) link(identity))  (householdsize -> zLE8_LIFESTYLE, family(gaussian) link(identity)) ///
(zLE8_LIFESTYLE -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) (zLE8_LIFESTYLE -> POORCOGN, family(gaussian) link(identity)) ///
(NonWhite -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) (AGE -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) ///
(SEX -> zLE8_BIOLOGICAL, family(gaussian) link(identity))  (householdsize -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) ///
(zLE8_BIOLOGICAL -> POORCOGN, family(gaussian) link(identity))  ///
(NonWhite -> POORCOGN, family(gaussian) link(identity)) (AGE -> POORCOGN, family(gaussian) link(identity)) ///
(SEX -> POORCOGN, family(gaussian) link(identity)) (householdsize -> POORCOGN, family(gaussian) link(identity)) (SES -> POORCOGN, family(gaussian) link(identity)) (zLE8_LIFESTYLE -> POORCOGN, family(gaussian) link(identity)) (zLE8_BIOLOGICAL -> POORCOGN, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 




 //////////////////INDIRECT EFFECTS FOR SES///////////////////////

 
 
******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS*****

nlcom (_b[zLE8_LIFESTYLE:SES]*_b[_t:zLE8_LIFESTYLE])


******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom _b[zLE8_LIFESTYLE:SES]*_b[_t:zLE8_BIOLOGICAL]*_b[zLE8_BIOLOGICAL:zLE8_LIFESTYLE]


******************Indirect effect OF SES THROUGH  LIFESTYLE FACTORS, HEALTH AND COGNITIVE PERFORMANCE*****


nlcom (_b[zLE8_LIFESTYLE:SES]*_b[_t:POORCOGN]*_b[POORCOGN:zLE8_BIOLOGICAL]*_b[zLE8_BIOLOGICAL:zLE8_LIFESTYLE])

******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS,  AND COGNITIVE PERFORMANCE*****

nlcom (_b[zLE8_LIFESTYLE:SES]*_b[_t:POORCOGN]*_b[POORCOGN:zLE8_LIFESTYLE])


******************Indirect effect OF SES THROUGH COGNITIVE PERFORMANCE*****

nlcom _b[_t:POORCOGN]*_b[POORCOGN:SES]


********************************WEIBULL PH MODEL WITHOUT POORCOGN**************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES zLE8_LIFESTYLE zLE8_BIOLOGICAL invmills , family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> zLE8_LIFESTYLE, family(gaussian) link(identity)) (SES -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) (NonWhite -> zLE8_LIFESTYLE, family(gaussian) link(identity)) (AGE -> zLE8_LIFESTYLE, family(gaussian) link(identity)) (SEX -> zLE8_LIFESTYLE, family(gaussian) link(identity))  (householdsize -> zLE8_LIFESTYLE, family(gaussian) link(identity)) ///
(zLE8_LIFESTYLE -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) ///
(NonWhite -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) (AGE -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) ///
(SEX -> zLE8_BIOLOGICAL, family(gaussian) link(identity))  (householdsize -> zLE8_BIOLOGICAL, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 

******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS*****

nlcom (_b[zLE8_LIFESTYLE:SES]*_b[_t:zLE8_LIFESTYLE])


******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom _b[zLE8_LIFESTYLE:SES]*_b[_t:zLE8_BIOLOGICAL]*_b[zLE8_BIOLOGICAL:zLE8_LIFESTYLE]


save, replace



*************************************TOTAL EFFECT OF NonWhite*****************************************

gsem (_t <- NonWhite AGE SEX householdsize invmills if sample_final , family(weibull, failure(_d) ) link(log) nocapslatent) 





*************************************TOTAL EFFECT OF SES*****************************************

gsem (_t <- NonWhite SES AGE SEX  householdsize invmills if sample_final , family(weibull, failure(_d) ) link(log) nocapslatent) 



*********************************************************SENSITIVITY ANALYSIS***************************************************************


************************************************************DIET and HEALTH************************************************************

********************************************WEIBULL PH MODEL WITH COGNITIVE PERFORMANCE******************************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES DIET HEALTH POORCOGN invmills, family(weibull, failure(_d) ) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> DIET, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> DIET, family(gaussian) link(identity)) (AGE -> DIET, family(gaussian) link(identity)) (SEX -> DIET, family(gaussian) link(identity))  (householdsize -> DIET, family(gaussian) link(identity)) ///
(DIET -> HEALTH, family(gaussian) link(identity)) (DIET -> POORCOGN, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
(HEALTH -> POORCOGN, family(gaussian) link(identity))  ///
(NonWhite -> POORCOGN, family(gaussian) link(identity)) (AGE -> POORCOGN, family(gaussian) link(identity)) ///
(SEX -> POORCOGN, family(gaussian) link(identity)) (householdsize -> POORCOGN, family(gaussian) link(identity)) (SES -> POORCOGN, family(gaussian) link(identity)) (DIET -> POORCOGN, family(gaussian) link(identity)) (HEALTH -> POORCOGN, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 



 //////////////////INDIRECT EFFECTS FOR RACE//////////////////

 

 
******************Indirect effect THROUGH SES ONLY*****

nlcom _b[_t:SES]*_b[SES:NonWhite]



******************Indirect effect THROUGH SES AND LIFESTYLE FACTORS*****

nlcom (_b[SES:NonWhite]*_b[DIET:SES]*_b[_t:DIET])


******************Indirect effect THROUGH SES, LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom (_b[SES:NonWhite]*_b[DIET:SES]*_b[_t:HEALTH]*_b[HEALTH:DIET])



******************Indirect effect THROUGH SES, LIFESTYLE FACTORS, HEALTH AND COGNITIVE PERFORMANCE*****


nlcom (_b[SES:NonWhite]*_b[DIET:SES]*_b[_t:POORCOGN]*_b[POORCOGN:HEALTH]*_b[HEALTH:DIET])

******************Indirect effect THROUGH SES, LIFESTYLE FACTORS,  AND COGNITIVE PERFORMANCE*****

nlcom (_b[SES:NonWhite]*_b[DIET:SES]*_b[_t:POORCOGN]*_b[POORCOGN:DIET])

******************Indirect effect THROUGH SES,  AND COGNITIVE PERFORMANCE*****

nlcom _b[_t:POORCOGN]*_b[SES:NonWhite]*_b[POORCOGN:SES]



********************************WEIBULL PH MODEL WITHOUT POORCOGN**************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES DIET HEALTH invmills , family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> DIET, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> DIET, family(gaussian) link(identity)) (AGE -> DIET, family(gaussian) link(identity)) (SEX -> DIET, family(gaussian) link(identity))  (householdsize -> DIET, family(gaussian) link(identity)) ///
(DIET -> HEALTH, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 


******************Indirect effect THROUGH SES ONLY*****

nlcom _b[_t:SES]*_b[SES:NonWhite]



******************Indirect effect THROUGH SES AND LIFESTYLE FACTORS*****

nlcom (_b[SES:NonWhite]*_b[DIET:SES]*_b[_t:DIET])


******************Indirect effect THROUGH SES, LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom (_b[SES:NonWhite]*_b[DIET:SES]*_b[_t:HEALTH]*_b[HEALTH:DIET])



*************************TABLE 5****************

********************************************WEIBULL PH WITH COGNITIVE PERFORMANCE******************************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES DIET HEALTH POORCOGN invmills, family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> DIET, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> DIET, family(gaussian) link(identity)) (AGE -> DIET, family(gaussian) link(identity)) (SEX -> DIET, family(gaussian) link(identity))  (householdsize -> DIET, family(gaussian) link(identity)) ///
(DIET -> HEALTH, family(gaussian) link(identity)) (DIET -> POORCOGN, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
(HEALTH -> POORCOGN, family(gaussian) link(identity))  ///
(NonWhite -> POORCOGN, family(gaussian) link(identity)) (AGE -> POORCOGN, family(gaussian) link(identity)) ///
(SEX -> POORCOGN, family(gaussian) link(identity)) (householdsize -> POORCOGN, family(gaussian) link(identity)) (SES -> POORCOGN, family(gaussian) link(identity)) (DIET -> POORCOGN, family(gaussian) link(identity)) (HEALTH -> POORCOGN, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 




 //////////////////INDIRECT EFFECTS FOR SES///////////////////////

 
 
******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS*****

nlcom (_b[DIET:SES]*_b[_t:DIET])


******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom _b[DIET:SES]*_b[_t:HEALTH]*_b[HEALTH:DIET]


******************Indirect effect OF SES THROUGH  LIFESTYLE FACTORS, HEALTH AND COGNITIVE PERFORMANCE*****


nlcom (_b[DIET:SES]*_b[_t:POORCOGN]*_b[POORCOGN:HEALTH]*_b[HEALTH:DIET])

******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS,  AND COGNITIVE PERFORMANCE*****

nlcom (_b[DIET:SES]*_b[_t:POORCOGN]*_b[POORCOGN:DIET])


******************Indirect effect OF SES THROUGH COGNITIVE PERFORMANCE*****

nlcom _b[_t:POORCOGN]*_b[POORCOGN:SES]


********************************WEIBULL PH MODEL WITHOUT POORCOGN**************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES DIET HEALTH invmills , family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> DIET, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> DIET, family(gaussian) link(identity)) (AGE -> DIET, family(gaussian) link(identity)) (SEX -> DIET, family(gaussian) link(identity))  (householdsize -> DIET, family(gaussian) link(identity)) ///
(DIET -> HEALTH, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 

******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS*****

nlcom (_b[DIET:SES]*_b[_t:DIET])


******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom _b[DIET:SES]*_b[_t:HEALTH]*_b[HEALTH:DIET]


save, replace



*************************************TOTAL EFFECT OF NonWhite*****************************************

gsem (_t <- NonWhite AGE SEX householdsize invmills if sample_final , family(weibull, failure(_d) ) link(log) nocapslatent) 





*************************************TOTAL EFFECT OF SES*****************************************

gsem (_t <- NonWhite SES AGE SEX  householdsize invmills if sample_final , family(weibull, failure(_d) ) link(log) nocapslatent) 





************************************************************PA and HEALTH************************************************************

********************************************WEIBULL PH MODEL WITH COGNITIVE PERFORMANCE******************************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES PA HEALTH POORCOGN invmills, family(weibull, failure(_d) ) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> PA, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> PA, family(gaussian) link(identity)) (AGE -> PA, family(gaussian) link(identity)) (SEX -> PA, family(gaussian) link(identity))  (householdsize -> PA, family(gaussian) link(identity)) ///
(PA -> HEALTH, family(gaussian) link(identity)) (PA -> POORCOGN, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
(HEALTH -> POORCOGN, family(gaussian) link(identity))  ///
(NonWhite -> POORCOGN, family(gaussian) link(identity)) (AGE -> POORCOGN, family(gaussian) link(identity)) ///
(SEX -> POORCOGN, family(gaussian) link(identity)) (householdsize -> POORCOGN, family(gaussian) link(identity)) (SES -> POORCOGN, family(gaussian) link(identity)) (PA -> POORCOGN, family(gaussian) link(identity)) (HEALTH -> POORCOGN, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 



 //////////////////INDIRECT EFFECTS FOR RACE//////////////////

 

 
******************Indirect effect THROUGH SES ONLY*****

nlcom _b[_t:SES]*_b[SES:NonWhite]



******************Indirect effect THROUGH SES AND LIFESTYLE FACTORS*****

nlcom (_b[SES:NonWhite]*_b[PA:SES]*_b[_t:PA])


******************Indirect effect THROUGH SES, LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom (_b[SES:NonWhite]*_b[PA:SES]*_b[_t:HEALTH]*_b[HEALTH:PA])



******************Indirect effect THROUGH SES, LIFESTYLE FACTORS, HEALTH AND COGNITIVE PERFORMANCE*****


nlcom (_b[SES:NonWhite]*_b[PA:SES]*_b[_t:POORCOGN]*_b[POORCOGN:HEALTH]*_b[HEALTH:PA])

******************Indirect effect THROUGH SES, LIFESTYLE FACTORS,  AND COGNITIVE PERFORMANCE*****

nlcom (_b[SES:NonWhite]*_b[PA:SES]*_b[_t:POORCOGN]*_b[POORCOGN:PA])

******************Indirect effect THROUGH SES,  AND COGNITIVE PERFORMANCE*****

nlcom _b[_t:POORCOGN]*_b[SES:NonWhite]*_b[POORCOGN:SES]



********************************WEIBULL PH MODEL WITHOUT POORCOGN**************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES PA HEALTH invmills , family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> PA, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> PA, family(gaussian) link(identity)) (AGE -> PA, family(gaussian) link(identity)) (SEX -> PA, family(gaussian) link(identity))  (householdsize -> PA, family(gaussian) link(identity)) ///
(PA -> HEALTH, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 


******************Indirect effect THROUGH SES ONLY*****

nlcom _b[_t:SES]*_b[SES:NonWhite]



******************Indirect effect THROUGH SES AND LIFESTYLE FACTORS*****

nlcom (_b[SES:NonWhite]*_b[PA:SES]*_b[_t:PA])


******************Indirect effect THROUGH SES, LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom (_b[SES:NonWhite]*_b[PA:SES]*_b[_t:HEALTH]*_b[HEALTH:PA])



*************************TABLE 5****************

********************************************WEIBULL PH WITH COGNITIVE PERFORMANCE******************************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES PA HEALTH POORCOGN invmills, family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> PA, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> PA, family(gaussian) link(identity)) (AGE -> PA, family(gaussian) link(identity)) (SEX -> PA, family(gaussian) link(identity))  (householdsize -> PA, family(gaussian) link(identity)) ///
(PA -> HEALTH, family(gaussian) link(identity)) (PA -> POORCOGN, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
(HEALTH -> POORCOGN, family(gaussian) link(identity))  ///
(NonWhite -> POORCOGN, family(gaussian) link(identity)) (AGE -> POORCOGN, family(gaussian) link(identity)) ///
(SEX -> POORCOGN, family(gaussian) link(identity)) (householdsize -> POORCOGN, family(gaussian) link(identity)) (SES -> POORCOGN, family(gaussian) link(identity)) (PA -> POORCOGN, family(gaussian) link(identity)) (HEALTH -> POORCOGN, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 




 //////////////////INDIRECT EFFECTS FOR SES///////////////////////

 
 
******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS*****

nlcom (_b[PA:SES]*_b[_t:PA])


******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom _b[PA:SES]*_b[_t:HEALTH]*_b[HEALTH:PA]


******************Indirect effect OF SES THROUGH  LIFESTYLE FACTORS, HEALTH AND COGNITIVE PERFORMANCE*****


nlcom (_b[PA:SES]*_b[_t:POORCOGN]*_b[POORCOGN:HEALTH]*_b[HEALTH:PA])

******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS,  AND COGNITIVE PERFORMANCE*****

nlcom (_b[PA:SES]*_b[_t:POORCOGN]*_b[POORCOGN:PA])


******************Indirect effect OF SES THROUGH COGNITIVE PERFORMANCE*****

nlcom _b[_t:POORCOGN]*_b[POORCOGN:SES]


********************************WEIBULL PH MODEL WITHOUT POORCOGN**************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES PA HEALTH invmills , family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> PA, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> PA, family(gaussian) link(identity)) (AGE -> PA, family(gaussian) link(identity)) (SEX -> PA, family(gaussian) link(identity))  (householdsize -> PA, family(gaussian) link(identity)) ///
(PA -> HEALTH, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 

******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS*****

nlcom (_b[PA:SES]*_b[_t:PA])


******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom _b[PA:SES]*_b[_t:HEALTH]*_b[HEALTH:PA]


save, replace



*************************************TOTAL EFFECT OF NonWhite*****************************************

gsem (_t <- NonWhite AGE SEX householdsize invmills if sample_final , family(weibull, failure(_d) ) link(log) nocapslatent) 





*************************************TOTAL EFFECT OF SES*****************************************

gsem (_t <- NonWhite SES AGE SEX  householdsize invmills if sample_final , family(weibull, failure(_d) ) link(log) nocapslatent) 



************************************************************SMOKING and HEALTH************************************************************

********************************************WEIBULL PH MODEL WITH COGNITIVE PERFORMANCE******************************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES SMOKING HEALTH POORCOGN invmills, family(weibull, failure(_d) ) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> SMOKING, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> SMOKING, family(gaussian) link(identity)) (AGE -> SMOKING, family(gaussian) link(identity)) (SEX -> SMOKING, family(gaussian) link(identity))  (householdsize -> SMOKING, family(gaussian) link(identity)) ///
(SMOKING -> HEALTH, family(gaussian) link(identity)) (SMOKING -> POORCOGN, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
(HEALTH -> POORCOGN, family(gaussian) link(identity))  ///
(NonWhite -> POORCOGN, family(gaussian) link(identity)) (AGE -> POORCOGN, family(gaussian) link(identity)) ///
(SEX -> POORCOGN, family(gaussian) link(identity)) (householdsize -> POORCOGN, family(gaussian) link(identity)) (SES -> POORCOGN, family(gaussian) link(identity)) (SMOKING -> POORCOGN, family(gaussian) link(identity)) (HEALTH -> POORCOGN, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 



 //////////////////INDIRECT EFFECTS FOR RACE//////////////////

 

 
******************Indirect effect THROUGH SES ONLY*****

nlcom _b[_t:SES]*_b[SES:NonWhite]



******************Indirect effect THROUGH SES AND LIFESTYLE FACTORS*****

nlcom (_b[SES:NonWhite]*_b[SMOKING:SES]*_b[_t:SMOKING])


******************Indirect effect THROUGH SES, LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom (_b[SES:NonWhite]*_b[SMOKING:SES]*_b[_t:HEALTH]*_b[HEALTH:SMOKING])



******************Indirect effect THROUGH SES, LIFESTYLE FACTORS, HEALTH AND COGNITIVE PERFORMANCE*****


nlcom (_b[SES:NonWhite]*_b[SMOKING:SES]*_b[_t:POORCOGN]*_b[POORCOGN:HEALTH]*_b[HEALTH:SMOKING])

******************Indirect effect THROUGH SES, LIFESTYLE FACTORS,  AND COGNITIVE PERFORMANCE*****

nlcom (_b[SES:NonWhite]*_b[SMOKING:SES]*_b[_t:POORCOGN]*_b[POORCOGN:SMOKING])

******************Indirect effect THROUGH SES,  AND COGNITIVE PERFORMANCE*****

nlcom _b[_t:POORCOGN]*_b[SES:NonWhite]*_b[POORCOGN:SES]



********************************WEIBULL PH MODEL WITHOUT POORCOGN**************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES SMOKING HEALTH invmills , family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> SMOKING, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> SMOKING, family(gaussian) link(identity)) (AGE -> SMOKING, family(gaussian) link(identity)) (SEX -> SMOKING, family(gaussian) link(identity))  (householdsize -> SMOKING, family(gaussian) link(identity)) ///
(SMOKING -> HEALTH, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 


******************Indirect effect THROUGH SES ONLY*****

nlcom _b[_t:SES]*_b[SES:NonWhite]



******************Indirect effect THROUGH SES AND LIFESTYLE FACTORS*****

nlcom (_b[SES:NonWhite]*_b[SMOKING:SES]*_b[_t:SMOKING])


******************Indirect effect THROUGH SES, LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom (_b[SES:NonWhite]*_b[SMOKING:SES]*_b[_t:HEALTH]*_b[HEALTH:SMOKING])



*************************TABLE 5****************

********************************************WEIBULL PH WITH COGNITIVE PERFORMANCE******************************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES SMOKING HEALTH POORCOGN invmills, family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> SMOKING, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> SMOKING, family(gaussian) link(identity)) (AGE -> SMOKING, family(gaussian) link(identity)) (SEX -> SMOKING, family(gaussian) link(identity))  (householdsize -> SMOKING, family(gaussian) link(identity)) ///
(SMOKING -> HEALTH, family(gaussian) link(identity)) (SMOKING -> POORCOGN, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
(HEALTH -> POORCOGN, family(gaussian) link(identity))  ///
(NonWhite -> POORCOGN, family(gaussian) link(identity)) (AGE -> POORCOGN, family(gaussian) link(identity)) ///
(SEX -> POORCOGN, family(gaussian) link(identity)) (householdsize -> POORCOGN, family(gaussian) link(identity)) (SES -> POORCOGN, family(gaussian) link(identity)) (SMOKING -> POORCOGN, family(gaussian) link(identity)) (HEALTH -> POORCOGN, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 




 //////////////////INDIRECT EFFECTS FOR SES///////////////////////

 
 
******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS*****

nlcom (_b[SMOKING:SES]*_b[_t:SMOKING])


******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom _b[SMOKING:SES]*_b[_t:HEALTH]*_b[HEALTH:SMOKING]


******************Indirect effect OF SES THROUGH  LIFESTYLE FACTORS, HEALTH AND COGNITIVE PERFORMANCE*****


nlcom (_b[SMOKING:SES]*_b[_t:POORCOGN]*_b[POORCOGN:HEALTH]*_b[HEALTH:SMOKING])

******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS,  AND COGNITIVE PERFORMANCE*****

nlcom (_b[SMOKING:SES]*_b[_t:POORCOGN]*_b[POORCOGN:SMOKING])


******************Indirect effect OF SES THROUGH COGNITIVE PERFORMANCE*****

nlcom _b[_t:POORCOGN]*_b[POORCOGN:SES]


********************************WEIBULL PH MODEL WITHOUT POORCOGN**************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES SMOKING HEALTH invmills , family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> SMOKING, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> SMOKING, family(gaussian) link(identity)) (AGE -> SMOKING, family(gaussian) link(identity)) (SEX -> SMOKING, family(gaussian) link(identity))  (householdsize -> SMOKING, family(gaussian) link(identity)) ///
(SMOKING -> HEALTH, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 

******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS*****

nlcom (_b[SMOKING:SES]*_b[_t:SMOKING])


******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom _b[SMOKING:SES]*_b[_t:HEALTH]*_b[HEALTH:SMOKING]


save, replace



*************************************TOTAL EFFECT OF NonWhite*****************************************

gsem (_t <- NonWhite AGE SEX householdsize invmills if sample_final , family(weibull, failure(_d) ) link(log) nocapslatent) 





*************************************TOTAL EFFECT OF SES*****************************************

gsem (_t <- NonWhite SES AGE SEX  householdsize invmills if sample_final , family(weibull, failure(_d) ) link(log) nocapslatent) 





************************************************************ALCOHOL and HEALTH************************************************************

********************************************WEIBULL PH MODEL WITH COGNITIVE PERFORMANCE******************************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES ALCOHOL HEALTH POORCOGN invmills, family(weibull, failure(_d) ) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> ALCOHOL, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> ALCOHOL, family(gaussian) link(identity)) (AGE -> ALCOHOL, family(gaussian) link(identity)) (SEX -> ALCOHOL, family(gaussian) link(identity))  (householdsize -> ALCOHOL, family(gaussian) link(identity)) ///
(ALCOHOL -> HEALTH, family(gaussian) link(identity)) (ALCOHOL -> POORCOGN, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
(HEALTH -> POORCOGN, family(gaussian) link(identity))  ///
(NonWhite -> POORCOGN, family(gaussian) link(identity)) (AGE -> POORCOGN, family(gaussian) link(identity)) ///
(SEX -> POORCOGN, family(gaussian) link(identity)) (householdsize -> POORCOGN, family(gaussian) link(identity)) (SES -> POORCOGN, family(gaussian) link(identity)) (ALCOHOL -> POORCOGN, family(gaussian) link(identity)) (HEALTH -> POORCOGN, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 



 //////////////////INDIRECT EFFECTS FOR RACE//////////////////

 

 
******************Indirect effect THROUGH SES ONLY*****

nlcom _b[_t:SES]*_b[SES:NonWhite]



******************Indirect effect THROUGH SES AND LIFESTYLE FACTORS*****

nlcom (_b[SES:NonWhite]*_b[ALCOHOL:SES]*_b[_t:ALCOHOL])


******************Indirect effect THROUGH SES, LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom (_b[SES:NonWhite]*_b[ALCOHOL:SES]*_b[_t:HEALTH]*_b[HEALTH:ALCOHOL])



******************Indirect effect THROUGH SES, LIFESTYLE FACTORS, HEALTH AND COGNITIVE PERFORMANCE*****


nlcom (_b[SES:NonWhite]*_b[ALCOHOL:SES]*_b[_t:POORCOGN]*_b[POORCOGN:HEALTH]*_b[HEALTH:ALCOHOL])

******************Indirect effect THROUGH SES, LIFESTYLE FACTORS,  AND COGNITIVE PERFORMANCE*****

nlcom (_b[SES:NonWhite]*_b[ALCOHOL:SES]*_b[_t:POORCOGN]*_b[POORCOGN:ALCOHOL])

******************Indirect effect THROUGH SES,  AND COGNITIVE PERFORMANCE*****

nlcom _b[_t:POORCOGN]*_b[SES:NonWhite]*_b[POORCOGN:SES]



********************************WEIBULL PH MODEL WITHOUT POORCOGN**************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES ALCOHOL HEALTH invmills , family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> ALCOHOL, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> ALCOHOL, family(gaussian) link(identity)) (AGE -> ALCOHOL, family(gaussian) link(identity)) (SEX -> ALCOHOL, family(gaussian) link(identity))  (householdsize -> ALCOHOL, family(gaussian) link(identity)) ///
(ALCOHOL -> HEALTH, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 


******************Indirect effect THROUGH SES ONLY*****

nlcom _b[_t:SES]*_b[SES:NonWhite]



******************Indirect effect THROUGH SES AND LIFESTYLE FACTORS*****

nlcom (_b[SES:NonWhite]*_b[ALCOHOL:SES]*_b[_t:ALCOHOL])


******************Indirect effect THROUGH SES, LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom (_b[SES:NonWhite]*_b[ALCOHOL:SES]*_b[_t:HEALTH]*_b[HEALTH:ALCOHOL])



*************************TABLE 5****************

********************************************WEIBULL PH WITH COGNITIVE PERFORMANCE******************************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES ALCOHOL HEALTH POORCOGN invmills, family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> ALCOHOL, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> ALCOHOL, family(gaussian) link(identity)) (AGE -> ALCOHOL, family(gaussian) link(identity)) (SEX -> ALCOHOL, family(gaussian) link(identity))  (householdsize -> ALCOHOL, family(gaussian) link(identity)) ///
(ALCOHOL -> HEALTH, family(gaussian) link(identity)) (ALCOHOL -> POORCOGN, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
(HEALTH -> POORCOGN, family(gaussian) link(identity))  ///
(NonWhite -> POORCOGN, family(gaussian) link(identity)) (AGE -> POORCOGN, family(gaussian) link(identity)) ///
(SEX -> POORCOGN, family(gaussian) link(identity)) (householdsize -> POORCOGN, family(gaussian) link(identity)) (SES -> POORCOGN, family(gaussian) link(identity)) (ALCOHOL -> POORCOGN, family(gaussian) link(identity)) (HEALTH -> POORCOGN, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 




 //////////////////INDIRECT EFFECTS FOR SES///////////////////////

 
 
******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS*****

nlcom (_b[ALCOHOL:SES]*_b[_t:ALCOHOL])


******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom _b[ALCOHOL:SES]*_b[_t:HEALTH]*_b[HEALTH:ALCOHOL]


******************Indirect effect OF SES THROUGH  LIFESTYLE FACTORS, HEALTH AND COGNITIVE PERFORMANCE*****


nlcom (_b[ALCOHOL:SES]*_b[_t:POORCOGN]*_b[POORCOGN:HEALTH]*_b[HEALTH:ALCOHOL])

******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS,  AND COGNITIVE PERFORMANCE*****

nlcom (_b[ALCOHOL:SES]*_b[_t:POORCOGN]*_b[POORCOGN:ALCOHOL])


******************Indirect effect OF SES THROUGH COGNITIVE PERFORMANCE*****

nlcom _b[_t:POORCOGN]*_b[POORCOGN:SES]


********************************WEIBULL PH MODEL WITHOUT POORCOGN**************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES ALCOHOL HEALTH invmills , family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> ALCOHOL, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> ALCOHOL, family(gaussian) link(identity)) (AGE -> ALCOHOL, family(gaussian) link(identity)) (SEX -> ALCOHOL, family(gaussian) link(identity))  (householdsize -> ALCOHOL, family(gaussian) link(identity)) ///
(ALCOHOL -> HEALTH, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 

******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS*****

nlcom (_b[ALCOHOL:SES]*_b[_t:ALCOHOL])


******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom _b[ALCOHOL:SES]*_b[_t:HEALTH]*_b[HEALTH:ALCOHOL]


save, replace



*************************************TOTAL EFFECT OF NonWhite*****************************************

gsem (_t <- NonWhite AGE SEX householdsize invmills if sample_final , family(weibull, failure(_d) ) link(log) nocapslatent) 





*************************************TOTAL EFFECT OF SES*****************************************

gsem (_t <- NonWhite SES AGE SEX  householdsize invmills if sample_final , family(weibull, failure(_d) ) link(log) nocapslatent) 




************************************************************NUTR and HEALTH************************************************************

********************************************WEIBULL PH MODEL WITH COGNITIVE PERFORMANCE******************************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES NUTR HEALTH POORCOGN invmills, family(weibull, failure(_d) ) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> NUTR, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> NUTR, family(gaussian) link(identity)) (AGE -> NUTR, family(gaussian) link(identity)) (SEX -> NUTR, family(gaussian) link(identity))  (householdsize -> NUTR, family(gaussian) link(identity)) ///
(NUTR -> HEALTH, family(gaussian) link(identity)) (NUTR -> POORCOGN, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
(HEALTH -> POORCOGN, family(gaussian) link(identity))  ///
(NonWhite -> POORCOGN, family(gaussian) link(identity)) (AGE -> POORCOGN, family(gaussian) link(identity)) ///
(SEX -> POORCOGN, family(gaussian) link(identity)) (householdsize -> POORCOGN, family(gaussian) link(identity)) (SES -> POORCOGN, family(gaussian) link(identity)) (NUTR -> POORCOGN, family(gaussian) link(identity)) (HEALTH -> POORCOGN, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 



 //////////////////INDIRECT EFFECTS FOR RACE//////////////////

 

 
******************Indirect effect THROUGH SES ONLY*****

nlcom _b[_t:SES]*_b[SES:NonWhite]



******************Indirect effect THROUGH SES AND LIFESTYLE FACTORS*****

nlcom (_b[SES:NonWhite]*_b[NUTR:SES]*_b[_t:NUTR])


******************Indirect effect THROUGH SES, LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom (_b[SES:NonWhite]*_b[NUTR:SES]*_b[_t:HEALTH]*_b[HEALTH:NUTR])



******************Indirect effect THROUGH SES, LIFESTYLE FACTORS, HEALTH AND COGNITIVE PERFORMANCE*****


nlcom (_b[SES:NonWhite]*_b[NUTR:SES]*_b[_t:POORCOGN]*_b[POORCOGN:HEALTH]*_b[HEALTH:NUTR])

******************Indirect effect THROUGH SES, LIFESTYLE FACTORS,  AND COGNITIVE PERFORMANCE*****

nlcom (_b[SES:NonWhite]*_b[NUTR:SES]*_b[_t:POORCOGN]*_b[POORCOGN:NUTR])

******************Indirect effect THROUGH SES,  AND COGNITIVE PERFORMANCE*****

nlcom _b[_t:POORCOGN]*_b[SES:NonWhite]*_b[POORCOGN:SES]



********************************WEIBULL PH MODEL WITHOUT POORCOGN**************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES NUTR HEALTH invmills , family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> NUTR, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> NUTR, family(gaussian) link(identity)) (AGE -> NUTR, family(gaussian) link(identity)) (SEX -> NUTR, family(gaussian) link(identity))  (householdsize -> NUTR, family(gaussian) link(identity)) ///
(NUTR -> HEALTH, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 


******************Indirect effect THROUGH SES ONLY*****

nlcom _b[_t:SES]*_b[SES:NonWhite]



******************Indirect effect THROUGH SES AND LIFESTYLE FACTORS*****

nlcom (_b[SES:NonWhite]*_b[NUTR:SES]*_b[_t:NUTR])


******************Indirect effect THROUGH SES, LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom (_b[SES:NonWhite]*_b[NUTR:SES]*_b[_t:HEALTH]*_b[HEALTH:NUTR])



*************************TABLE 5****************

********************************************WEIBULL PH WITH COGNITIVE PERFORMANCE******************************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES NUTR HEALTH POORCOGN invmills, family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> NUTR, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> NUTR, family(gaussian) link(identity)) (AGE -> NUTR, family(gaussian) link(identity)) (SEX -> NUTR, family(gaussian) link(identity))  (householdsize -> NUTR, family(gaussian) link(identity)) ///
(NUTR -> HEALTH, family(gaussian) link(identity)) (NUTR -> POORCOGN, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
(HEALTH -> POORCOGN, family(gaussian) link(identity))  ///
(NonWhite -> POORCOGN, family(gaussian) link(identity)) (AGE -> POORCOGN, family(gaussian) link(identity)) ///
(SEX -> POORCOGN, family(gaussian) link(identity)) (householdsize -> POORCOGN, family(gaussian) link(identity)) (SES -> POORCOGN, family(gaussian) link(identity)) (NUTR -> POORCOGN, family(gaussian) link(identity)) (HEALTH -> POORCOGN, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 




 //////////////////INDIRECT EFFECTS FOR SES///////////////////////

 
 
******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS*****

nlcom (_b[NUTR:SES]*_b[_t:NUTR])


******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom _b[NUTR:SES]*_b[_t:HEALTH]*_b[HEALTH:NUTR]


******************Indirect effect OF SES THROUGH  LIFESTYLE FACTORS, HEALTH AND COGNITIVE PERFORMANCE*****


nlcom (_b[NUTR:SES]*_b[_t:POORCOGN]*_b[POORCOGN:HEALTH]*_b[HEALTH:NUTR])

******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS,  AND COGNITIVE PERFORMANCE*****

nlcom (_b[NUTR:SES]*_b[_t:POORCOGN]*_b[POORCOGN:NUTR])


******************Indirect effect OF SES THROUGH COGNITIVE PERFORMANCE*****

nlcom _b[_t:POORCOGN]*_b[POORCOGN:SES]


********************************WEIBULL PH MODEL WITHOUT POORCOGN**************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES NUTR HEALTH invmills , family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> NUTR, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> NUTR, family(gaussian) link(identity)) (AGE -> NUTR, family(gaussian) link(identity)) (SEX -> NUTR, family(gaussian) link(identity))  (householdsize -> NUTR, family(gaussian) link(identity)) ///
(NUTR -> HEALTH, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 

******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS*****

nlcom (_b[NUTR:SES]*_b[_t:NUTR])


******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom _b[NUTR:SES]*_b[_t:HEALTH]*_b[HEALTH:NUTR]


save, replace



*************************************TOTAL EFFECT OF NonWhite*****************************************

gsem (_t <- NonWhite AGE SEX householdsize invmills if sample_final , family(weibull, failure(_d) ) link(log) nocapslatent) 




*************************************TOTAL EFFECT OF SES*****************************************

gsem (_t <- NonWhite SES AGE SEX  householdsize invmills if sample_final , family(weibull, failure(_d) ) link(log) nocapslatent) 




************************************************************SS and HEALTH************************************************************

********************************************WEIBULL PH MODEL WITH COGNITIVE PERFORMANCE******************************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES SS HEALTH POORCOGN invmills, family(weibull, failure(_d) ) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> SS, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> SS, family(gaussian) link(identity)) (AGE -> SS, family(gaussian) link(identity)) (SEX -> SS, family(gaussian) link(identity))  (householdsize -> SS, family(gaussian) link(identity)) ///
(SS -> HEALTH, family(gaussian) link(identity)) (SS -> POORCOGN, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
(HEALTH -> POORCOGN, family(gaussian) link(identity))  ///
(NonWhite -> POORCOGN, family(gaussian) link(identity)) (AGE -> POORCOGN, family(gaussian) link(identity)) ///
(SEX -> POORCOGN, family(gaussian) link(identity)) (householdsize -> POORCOGN, family(gaussian) link(identity)) (SES -> POORCOGN, family(gaussian) link(identity)) (SS -> POORCOGN, family(gaussian) link(identity)) (HEALTH -> POORCOGN, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 



 //////////////////INDIRECT EFFECTS FOR RACE//////////////////

 

 
******************Indirect effect THROUGH SES ONLY*****

nlcom _b[_t:SES]*_b[SES:NonWhite]



******************Indirect effect THROUGH SES AND LIFESTYLE FACTORS*****

nlcom (_b[SES:NonWhite]*_b[SS:SES]*_b[_t:SS])


******************Indirect effect THROUGH SES, LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom (_b[SES:NonWhite]*_b[SS:SES]*_b[_t:HEALTH]*_b[HEALTH:SS])



******************Indirect effect THROUGH SES, LIFESTYLE FACTORS, HEALTH AND COGNITIVE PERFORMANCE*****


nlcom (_b[SES:NonWhite]*_b[SS:SES]*_b[_t:POORCOGN]*_b[POORCOGN:HEALTH]*_b[HEALTH:SS])

******************Indirect effect THROUGH SES, LIFESTYLE FACTORS,  AND COGNITIVE PERFORMANCE*****

nlcom (_b[SES:NonWhite]*_b[SS:SES]*_b[_t:POORCOGN]*_b[POORCOGN:SS])

******************Indirect effect THROUGH SES,  AND COGNITIVE PERFORMANCE*****

nlcom _b[_t:POORCOGN]*_b[SES:NonWhite]*_b[POORCOGN:SES]



********************************WEIBULL PH MODEL WITHOUT POORCOGN**************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES SS HEALTH invmills , family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> SS, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> SS, family(gaussian) link(identity)) (AGE -> SS, family(gaussian) link(identity)) (SEX -> SS, family(gaussian) link(identity))  (householdsize -> SS, family(gaussian) link(identity)) ///
(SS -> HEALTH, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 


******************Indirect effect THROUGH SES ONLY*****

nlcom _b[_t:SES]*_b[SES:NonWhite]



******************Indirect effect THROUGH SES AND LIFESTYLE FACTORS*****

nlcom (_b[SES:NonWhite]*_b[SS:SES]*_b[_t:SS])


******************Indirect effect THROUGH SES, LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom (_b[SES:NonWhite]*_b[SS:SES]*_b[_t:HEALTH]*_b[HEALTH:SS])



*************************TABLE 5****************

********************************************WEIBULL PH WITH COGNITIVE PERFORMANCE******************************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES SS HEALTH POORCOGN invmills, family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> SS, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> SS, family(gaussian) link(identity)) (AGE -> SS, family(gaussian) link(identity)) (SEX -> SS, family(gaussian) link(identity))  (householdsize -> SS, family(gaussian) link(identity)) ///
(SS -> HEALTH, family(gaussian) link(identity)) (SS -> POORCOGN, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
(HEALTH -> POORCOGN, family(gaussian) link(identity))  ///
(NonWhite -> POORCOGN, family(gaussian) link(identity)) (AGE -> POORCOGN, family(gaussian) link(identity)) ///
(SEX -> POORCOGN, family(gaussian) link(identity)) (householdsize -> POORCOGN, family(gaussian) link(identity)) (SES -> POORCOGN, family(gaussian) link(identity)) (SS -> POORCOGN, family(gaussian) link(identity)) (HEALTH -> POORCOGN, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 




 //////////////////INDIRECT EFFECTS FOR SES///////////////////////

 
 
******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS*****

nlcom (_b[SS:SES]*_b[_t:SS])


******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom _b[SS:SES]*_b[_t:HEALTH]*_b[HEALTH:SS]


******************Indirect effect OF SES THROUGH  LIFESTYLE FACTORS, HEALTH AND COGNITIVE PERFORMANCE*****


nlcom (_b[SS:SES]*_b[_t:POORCOGN]*_b[POORCOGN:HEALTH]*_b[HEALTH:SS])

******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS,  AND COGNITIVE PERFORMANCE*****

nlcom (_b[SS:SES]*_b[_t:POORCOGN]*_b[POORCOGN:SS])


******************Indirect effect OF SES THROUGH COGNITIVE PERFORMANCE*****

nlcom _b[_t:POORCOGN]*_b[POORCOGN:SES]


********************************WEIBULL PH MODEL WITHOUT POORCOGN**************************************************

***********************OVERALL SAMPLE****

gsem (_t <- NonWhite AGE SEX householdsize SES SS HEALTH invmills , family(weibull, failure(_d)) link(log) nocapslatent) ///
(NonWhite -> SES, family(gaussian) link(identity)) ///  
(AGE -> SES, family(gaussian) link(identity)) (SEX -> SES, family(gaussian) link(identity))(householdsize -> SES, family(gaussian) link(identity)) ///
(SES -> SS, family(gaussian) link(identity)) (SES -> HEALTH, family(gaussian) link(identity)) (NonWhite -> SS, family(gaussian) link(identity)) (AGE -> SS, family(gaussian) link(identity)) (SEX -> SS, family(gaussian) link(identity))  (householdsize -> SS, family(gaussian) link(identity)) ///
(SS -> HEALTH, family(gaussian) link(identity)) ///
(NonWhite -> HEALTH, family(gaussian) link(identity)) (AGE -> HEALTH, family(gaussian) link(identity)) ///
(SEX -> HEALTH, family(gaussian) link(identity))  (householdsize -> HEALTH, family(gaussian) link(identity)) ///
if sample_final==1, nocapslatent method(ml) 

******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS*****

nlcom (_b[SS:SES]*_b[_t:SS])


******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom _b[SS:SES]*_b[_t:HEALTH]*_b[HEALTH:SS]


save, replace



*************************************TOTAL EFFECT OF NonWhite*****************************************

gsem (_t <- NonWhite AGE SEX householdsize invmills if sample_final , family(weibull, failure(_d) ) link(log) nocapslatent) 




*************************************TOTAL EFFECT OF SES*****************************************

gsem (_t <- NonWhite SES AGE SEX  householdsize invmills if sample_final , family(weibull, failure(_d) ) link(log) nocapslatent) 


capture log close







****************************************************************************END OF STATA CODE*************************************************************







*********************DISCRETE TIME HAZARD MODEL*****************************

capture drop id
gen id=n_eid
sort id
save, replace

stsplit x, every(5) 


capture drop period
gen period=int(x-60)

sort id period

bysort id: ge seqvar = _n


lab var seqvar "spell year identifier, by subject"
// NB generation of variable using a logical condition
bysort id: ge DEMENTIA = _d
lab var DEMENTIA "binary depvar for discrete hazard model"

list id period seqvar DEMENTIA if id<=4

ta x, ge(D)

capture drop d1-d3

**d6 onwards is for age 60+**

gen d1=D1+D2+D3+D4+D5+D6
gen d2=D7+D8+D9
gen d3=D10+D11
 

logit DEMENTIA d1-d3 i.RACE_ETHN if sample4==1
logit DEMENTIA d1-d3 i.RACE_ETHN AGE if sample4==1


save, replace

capture drop dem_diag baselineage Age_dementia RACE_ETHN 

save, replace


//No MEDIATOR: ONLY EXOGENOUS VARIABLES//
gsem (d2 -> DEMENTIA, family(bernoulli) link(logit)) (d3 -> DEMENTIA, family(bernoulli) link(logit)) ///
  (NonWhite -> DEMENTIA, family(bernoulli) link(logit)) (AGE -> DEMENTIA, family(bernoulli) link(logit)) ///
 (SEX -> DEMENTIA, family(bernoulli) link(logit))  (householdsize -> DEMENTIA, family(bernoulli) link(logit)) ///
 
  if sample_final==1, nocapslatent  method(ml) 



//FULL SEM MODEL: pir edyears smokenum smokeyears  hav1sr hav2sr hav3sr hav4sr hav6sr fopr vapr vepr totcarot  heiscore mar100 hat27r hat28r hat30r druguse ncpnalcor allostatic srhbr comorbid   bmi POORCOGN //
 

gsem (d2 -> DEMENTIA, family(bernoulli )link(logit)) ///  
 (NonWhite -> DEMENTIA, family(bernoulli) link(logit)) (AGE -> DEMENTIA, family(bernoulli) link(logit)) ///
 (SEX -> DEMENTIA, family(bernoulli) link(logit)) (SES -> DEMENTIA, family(bernoulli) link(logit)) ///
 (NonWhite -> SES, family(gaussian) link(identity)) (AGE -> SES, family(gaussian) link(identity)) ///
 (SEX -> SES, family(gaussian) link(identity))  ///
(SES -> LE8_LIFESTYLE, family(gaussian) link(identity))  ///
(NonWhite -> LE8_LIFESTYLE, family(gaussian) link(identity)) (AGE -> LE8_LIFESTYLE, family(gaussian) link(identity)) ///
 (SEX -> LE8_LIFESTYLE, family(gaussian) link(identity))   ///
(LE8_LIFESTYLE -> LE8_BIOLOGICAL, family(gaussian) link(identity)) (LE8_LIFESTYLE -> POORCOGN, family(gaussian) link(identity)) (LE8_LIFESTYLE -> DEMENTIA, family(bernoulli) link(logit)) /// ///
  (NonWhite -> LE8_BIOLOGICAL, family(gaussian) link(identity)) (AGE -> LE8_BIOLOGICAL, family(gaussian) link(identity)) ///
 (SEX -> LE8_BIOLOGICAL, family(gaussian) link(identity))   ///
 (LE8_BIOLOGICAL -> POORCOGN, family(gaussian) link(identity)) (LE8_BIOLOGICAL -> DEMENTIA, family(bernoulli) link(logit)) /// ///
  (NonWhite -> POORCOGN, family(gaussian) link(identity)) (AGE -> POORCOGN, family(gaussian) link(identity)) ///
 (SEX -> POORCOGN, family(gaussian) link(identity))   ///
 (POORCOGN -> DEMENTIA, family(bernoulli) link(logit)) if sample_final==1, nocapslatent method(ml) 

 
 **dnumerical**
 


sem (d1 -> DEMENTIA, ) (d2 -> DEMENTIA) ///  
 (NonWhite -> DEMENTIA) (AGE -> DEMENTIA) ///
 (SEX -> DEMENTIA)  (SES -> DEMENTIA) ///
 (NonWhite -> SES) (AGE -> SES) ///
 (SEX -> SES)  ///
(SES -> LE8_LIFESTYLE)  ///
(NonWhite -> LE8_LIFESTYLE) (AGE -> LE8_LIFESTYLE) ///
 (SEX -> LE8_LIFESTYLE)   ///
(LE8_LIFESTYLE -> LE8_BIOLOGICAL) (LE8_LIFESTYLE -> POORCOGN) (LE8_LIFESTYLE -> DEMENTIA) /// ///
  (NonWhite -> LE8_BIOLOGICAL) (AGE -> LE8_BIOLOGICAL) ///
 (SEX -> LE8_BIOLOGICAL)   ///
 (LE8_BIOLOGICAL -> POORCOGN) (LE8_BIOLOGICAL -> DEMENTIA) /// ///
  (NonWhite -> POORCOGN) (AGE -> POORCOGN) ///
 (SEX -> POORCOGN)   ///
 (POORCOGN -> DEMENTIA) if sample_final==1, nocapslatent method(ml) 

 //////////////////INDIRECT EFFECTS FOR RACE//////////////////

 

 
******************Indirect effect THROUGH SES ONLY*****

nlcom _b[DEMENTIA:SES]*_b[SES:NonWhite]



******************Indirect effect THROUGH SES AND LIFESTYLE FACTORS*****

nlcom (_b[SES:NonWhite]*_b[LE8_LIFESTYLE:SES]*_b[DEMENTIA:LE8_LIFESTYLE])


******************Indirect effect THROUGH SES, LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

nlcom (_b[SES:NonWhite]*_b[LE8_LIFESTYLE:SES]*_b[DEMENTIA:LE8_BIOLOGICAL]*_b[HEALTH:LE8_LIFESTYLE])



******************Indirect effect THROUGH SES, LIFESTYLE FACTORS, HEALTH AND COGNITIVE PERFORMANCE*****


nlcom (_b[SES:NonWhite]*_b[LE8_LIFESTYLE:SES]*_b[DEMENTIA:POORCOGN]*_b[POORCOGN:LE8_BIOLOGICAL]*_b[LE8_BIOLOGICAL:LE8_LIFESTYLE])

******************Indirect effect THROUGH SES, LIFESTYLE FACTORS,  AND COGNITIVE PERFORMANCE*****

nlcom (_b[SES:NonWhite]*_b[LE8_LIFESTYLE:SES]*_b[DEMENTIA:POORCOGN]*_b[POORCOGN:LE8_LIFESTYLE])

******************Indirect effect THROUGH SES,  AND COGNITIVE PERFORMANCE*****

nlcom _b[DEMENTIA:POORCOGN]*_b[SES:NonWhite]*_b[POORCOGN:SES]



capture log close
log using "E:\UK_BIOBANK_PROJECT\UKB_PAPER1_RACESESDEM\OUTPUT\TABLE5.smcl"



*************************TABLE 5****************




 //////////////////INDIRECT EFFECTS FOR SES///////////////////////

 
 
******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS*****

nlcom _b[LE8_LIFESTYLE:SES]*_b[DEMENTIA:LE8_LIFESTYLE])


******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS AND HEALTH-RELATED FACTORS*****

(_b[LE8_LIFESTYLE:SES]*_b[DEMENTIA:LE8_BIOLOGICAL]*_b[LE8_BIOLOGICAL:LE8_LIFESTYLE])


******************Indirect effect OF SES THROUGH  LIFESTYLE FACTORS, HEALTH AND COGNITIVE PERFORMANCE*****


nlcom (_b[LE8_LIFESTYLE:SES]*_b[DEMENTIA:POORCOGN]*_b[POORCOGN:LE8_BIOLOGICAL]*_b[LE8_BIOLOGICAL:LE8_LIFESTYLE])

******************Indirect effect OF SES THROUGH LIFESTYLE FACTORS,  AND COGNITIVE PERFORMANCE*****

nlcom (_b[LE8_LIFESTYLE:SES]*_b[DEMENTIA:POORCOGN]*_b[POORCOGN:LE8_LIFESTYLE])


******************Indirect effect OF SES THROUGH COGNITIVE PERFORMANCE*****

nlcom _b[DEMENTIA:POORCOGN]*_b[POORCOGN:SES]



save, replace
