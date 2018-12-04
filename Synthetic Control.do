ssc install synth

*Define a directory save data sets
cd "/Volumes/GoogleDrive/My Drive/Minerva/Data Sets" 

* Texas model of black male prisoners (per capita)
clear
scuse texas 

#delimit;

synth 	bmprison  
		bmprison(1990) bmprison(1992) bmprison(1991) bmprison(1988) 
		alcohol(1990) aidscapita(1990) aidscapita(1991)  
		income ur poverty black(1990) black(1991) black(1992) 
		perc1519(1990) 
		,		
		trunit(48) trperiod(1993) unitnames(state)  
		mspeperiod(1985(1)1993) resultsperiod(1985(1)2000) 
	    keep(synth_bmprate.dta) replace fig;

	   	mat list e(V_matrix);
#delimit cr


* Plot the gap in predicted error
use synth_bmprate.dta, clear
keep _Y_treated _Y_synthetic _time
drop if _time==.
rename _time year
rename _Y_treated  treat
rename _Y_synthetic counterfact
gen gap48=treat-counterfact
sort year 
twoway (line gap48 year,lp(solid)lw(vthin)lcolor(black)), yline(0, lpattern(shortdash) lcolor(black)) xline(1993, lpattern(shortdash) lcolor(black)) xtitle("",si(medsmall)) xlabel(#10) ytitle("Gap in black male prisoner prediction error", size(medsmall)) legend(off)
save synth_bmprate_48.dta, replace


* Placebo test
clear
scuse texas

#delimit;
set more off;

local statelist  1 2 4 5 6 8 9 10 11 12 13 15 16 17 18 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 45 46 47 48 49 51 53 55;

foreach i of local statelist {;

synth 	bmprison 
		bmprison(1990) bmprison(1992) bmprison(1991) bmprison(1988)
		alcohol(1990) aidscapita(1990) aidscapita(1991) 
		income ur poverty black(1990) black(1991) black(1992) 
		perc1519(1990)
		,		
			trunit(`i') trperiod(1993) unitnames(state) 
			mspeperiod(1985(1)1993) resultsperiod(1985(1)2000)
			keep(synth_bmprate_`i'.dta) replace;
			matrix state`i' = e(RMSPE); /* check the V matrix*/
			};


 foreach i of local statelist {;
 matrix rownames state`i'=`i';
 matlist state`i', names(rows);
 };

#delimit cr
 
 
local statelist  1 2 4 5 6 8 9 10 11 12 13 15 16 17 18 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 45 46 47 48 49 51 53 55

 foreach i of local statelist {
 	use synth_bmprate_`i' ,clear
 	keep _Y_treated _Y_synthetic _time
 	drop if _time==.
	rename _time year
 	rename _Y_treated  treat`i'
 	rename _Y_synthetic counterfact`i'
 	gen gap`i'=treat`i'-counterfact`i'
 	sort year 
 	save synth_gap_bmprate`i'.dta, replace
}

use synth_gap_bmprate48.dta, clear
sort year
save placebo_bmprate48.dta, replace

foreach i of local statelist {
		
		merge year using synth_gap_bmprate`i'
		drop _merge
		sort year
		
	save placebo_bmprate.dta, replace
}

* All the placeboes on the same picture
use placebo_bmprate.dta, replace

* Picture of the full sample, including outlier RSMPE
#delimit;	

twoway 
(line gap1 year ,lp(solid)lw(vthin)) 
(line gap2 year ,lp(solid)lw(vthin)) 
(line gap4 year ,lp(solid)lw(vthin)) 
(line gap5 year ,lp(solid)lw(vthin))
(line gap6 year ,lp(solid)lw(vthin)) 
(line gap8 year ,lp(solid)lw(vthin)) 
(line gap9 year ,lp(solid)lw(vthin)) 
(line gap10 year ,lp(solid)lw(vthin)) 
(line gap11 year ,lp(solid)lw(vthin)) 
(line gap12 year ,lp(solid)lw(vthin)) 
(line gap13 year ,lp(solid)lw(vthin)) 
(line gap15 year ,lp(solid)lw(vthin)) 
(line gap16 year ,lp(solid)lw(vthin)) 
(line gap17 year ,lp(solid)lw(vthin))
(line gap18 year ,lp(solid)lw(vthin)) 
(line gap20 year ,lp(solid)lw(vthin)) 
(line gap21 year ,lp(solid)lw(vthin)) 
(line gap22 year ,lp(solid)lw(vthin)) 
(line gap23 year ,lp(solid)lw(vthin)) 
(line gap24 year ,lp(solid)lw(vthin)) 
(line gap25 year ,lp(solid)lw(vthin)) 
(line gap26 year ,lp(solid)lw(vthin))
(line gap27 year ,lp(solid)lw(vthin))
(line gap28 year ,lp(solid)lw(vthin)) 
(line gap29 year ,lp(solid)lw(vthin)) 
(line gap30 year ,lp(solid)lw(vthin)) 
(line gap31 year ,lp(solid)lw(vthin)) 
(line gap32 year ,lp(solid)lw(vthin)) 
(line gap33 year ,lp(solid)lw(vthin)) 
(line gap34 year ,lp(solid)lw(vthin))
(line gap35 year ,lp(solid)lw(vthin))
(line gap36 year ,lp(solid)lw(vthin))
(line gap37 year ,lp(solid)lw(vthin)) 
(line gap38 year ,lp(solid)lw(vthin)) 
(line gap39 year ,lp(solid)lw(vthin))
(line gap40 year ,lp(solid)lw(vthin)) 
(line gap41 year ,lp(solid)lw(vthin)) 
(line gap42 year ,lp(solid)lw(vthin)) 
(line gap45 year ,lp(solid)lw(vthin)) 
(line gap46 year ,lp(solid)lw(vthin)) 
(line gap47 year ,lp(solid)lw(vthin))
(line gap49 year ,lp(solid)lw(vthin)) 
(line gap51 year ,lp(solid)lw(vthin)) 
(line gap53 year ,lp(solid)lw(vthin)) 
(line gap55 year ,lp(solid)lw(vthin)) 
(line gap48 year ,lp(solid)lw(thick)lcolor(black)), /*treatment unit, Texas*/
yline(0, lpattern(shortdash) lcolor(black)) xline(1993, lpattern(shortdash) lcolor(black))
xtitle("",si(small)) xlabel(#10) ytitle("Gap in black male prisoners per capita prediction error", size(small))
	legend(off);

#delimit cr
