/*
 * A set of pegs and holes printed at slightly varying thicknesses
 * so one can print them and see what sizes are needed for a good 
 * friction fit.
 */

include <../libraries/spiff.scad>

pegSize = 8;


// make a peg and a hole of size (peg + variation/10)
module pegAndHole(peg = pegSize, wall = 1, variation = 1) {
	pegAdjusted = peg + variation/10;

	module sizeText(t){
		linear_extrude(2) scale(.5) write(str(t));
	}
	bottomThickness = 4;
	translate ([-2*pegAdjusted,0,0]) difference () {
		cube([pegAdjusted,pegAdjusted,pegAdjusted]);
		color("blue") translate([2,1,pegAdjusted-1]) sizeText(variation);
	}
	translate ([pegAdjusted,0,0]) difference() {
		cube([pegAdjusted+2*wall,pegAdjusted+2*wall,pegAdjusted+bottomThickness]);
		union() {
			translate([wall, wall, bottomThickness]) cube([pegAdjusted,pegAdjusted,pegAdjusted+1]);
			color("blue") translate([3,2,bottomThickness-1]) sizeText(variation);

		}
	}
}

for (i = [0:5]) {
	translate([0, i*(pegSize+5), 0]) pegAndHole(variation = i);
}
