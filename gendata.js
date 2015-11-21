var j = require('jalaali-js');
var tsv = require('tsv');
var fs = require('fs');

var raw_equinoxes = tsv.parse(fs.readFileSync('equinoxes.tsv', 'utf8'));
var equinoxes = {};
raw_equinoxes.forEach(function(eq) {
    equinoxes[eq.year] = eq.d + eq.h/24 + eq.m/24/60;
})

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

    console.log([jd.jy, relday + timeval].join("\t"));
}
