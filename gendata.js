var j = require('jalaali-js');
var tsv = require('tsv');
var fs = require('fs');

maketsv = function(arr) { return arr.join("\t") + "\n"; }

var raw_equinoxes = tsv.parse(fs.readFileSync('equinoxes.tsv', 'utf8'));
var equinoxes = {};
raw_equinoxes.forEach(function(eq) {
    equinoxes[eq.year] = eq.d + eq.h/24 + eq.m/24/60;
})

var fdiff = fs.openSync('leap_diff.tsv','w');
fs.writeSync(fdiff, maketsv(['year','diff']));

var consecutive_down = 0;
var last_diff = null;
var breaks = [];
for(var gy=1750;gy <= 2250; gy++) {
    gdate = Math.floor(equinoxes[gy]);
    timeval = equinoxes[gy] - gdate;

    jd = j.toJalaali(gy,3,gdate);
    isleap = j.isLeapJalaaliYear(jd.jy);

    if(jd.jm == 12) {
        esfand_days = isleap ? 30 : 29;
        relday = jd.jd - esfand_days
    } else {
        relday = jd.jd;
    }
    relday -= 1;

    var diff = relday + timeval;

    if(diff > last_diff) {
        consecutive_down++;
    } else {
        consecutive_down = 0;
    }

    if(consecutive_down == 4) { breaks.push(jd.jy); }

    fs.writeSync(fdiff, maketsv([jd.jy, diff]));
    last_diff = diff;
}
fs.close(fdiff);

var fcycles = fs.openSync('leap_cycles.tsv','w');
fs.writeSync(fcycles, maketsv(['start','end']));
console.log(breaks);
for(var i=0; i < (breaks.length - 1); i++) {
    fs.writeSync(fcycles, maketsv([breaks[i], breaks[i+1]]));
}
fs.close(fcycles);
