$fn=100;

barrelLength = 80;

module shell(rad=8) { 
    cylinder(barrelLength,r=rad);
    translate([-rad,0,0]) cube([2*rad,2*rad,30]);
}

module outer_shell(){ 
    difference(){ 
        union(){
            shell(9);
            translate([-4,-18,0])holder();
            translate([-10.5,-5,19]) extrapowersupport();
        }
        union(){
            translate([0,0,-1])scale([1,1,2])shell(6.92);
            translate([-50,3,-1])cube([100,100,100]);
            translate([-8.1,-3.5,27])rotate(45,[0,1,0])cube([10,10,10]);
        }
    }
}

module powerdivot(){ 
   translate([-(8.1),-3.5,0])cube([6.2, 20,6.2]); 
}
module holder(){ 
    cube([8,12,8]);
}
module extrapowersupport(){ 
    difference(){
        cube([9,20,9]);
        translate([4,-1,-1.5])rotate(-45,[0,1,0])translate([-20,0,0])cube([20,20,20]);
    }
}

module diffractorMount(rodThickness = 6.35) {
	beamHole = 6;
	translate([0,rodThickness/2+1,0]) rotate(90, [1,0,0]) difference() {
		translate([-9,0,0]) cube([2*9,rodThickness+2,rodThickness+2]);
		union() {
			translate([-10,rodThickness/2+1,rodThickness/2+1]) rotate(90, [0,1,0]) cylinder(20,r=rodThickness/2);
			translate([0,10,rodThickness/2+1]) rotate(90, [1,0,0]) cylinder(20,r=rodThickness/2);
		}
	}
}

translate([0,0,barrelLength]) diffractorMount();
difference(){ 
    outer_shell();
    translate([0,0,21])powerdivot();
}

