// This is the basic shape of the outer shell
// it is a cylinder stacked ontop of a cube
module outerShell(innerDiameter,wallThickness,holderLength){ 
    union(){
        cylinder(r=innerDiameter/2 + wallThickness, h=holderLength);
        translate([-.001,-(innerDiameter+2*wallThickness)/2,0])
            cube([innerDiameter+holderLength,innerDiameter+2*wallThickness,holderLength]);
            }
}

// generates the basic shell shape
module cylinderShell(innerDiameter, wallThickness, holderLength, holderHeight, buttonWidth,overHangRatio=1){ 
    overHangRatio = overHangRatio > 1 || overHangRatio < 0 ? 1: 1- overHangRatio;
    innerCubeWidth = innerDiameter*overHangRatio;
    difference(){
        //outer cylinder
        outerShell(innerDiameter, wallThickness,holderLength);
        union(){
            //inner cylinder
            translate([0,0,wallThickness])
            union(){
                cylinder(r=innerDiameter/2,h=holderLength);
                translate([.01,-innerCubeWidth/2, 0])
                    cube([innerDiameter+holderLength,innerCubeWidth,holderLength+1]);
            }
        }
    }
}

// makes the area that will hold the button 
module powerDivotHole(holderHeight,innerDiameter,buttonWidth,buttonDepth){ 
    union(){
        // the cube the button sits in when on
        cube([buttonWidth,innerDiameter/2,buttonWidth]);
        // makes a cube that makes the overhang easier to print
        translate([0,innerDiameter/2-(buttonWidth*(tan(45))),0])
            rotate(45,[1,0,0])
                cube([buttonWidth,buttonWidth/(cos(45)),innerDiameter/2]);
    }
}

// makes a large cube that cuts off the top of the holder at a desired height
module cutoffCube(holderHeight,innerDiameter,wallThickness,holderLength){       //this makes a cube that cuts off at the desired height
    translate([holderHeight-(innerDiameter+wallThickness)/2,-(2*innerDiameter+2*wallThickness)/2-.5, -0.5])
        cube([innerDiameter+holderLength+1,2*innerDiameter+2*wallThickness+1,holderLength+1]);
}

// makes the exterior wall of the power button hole
module powerdivot(buttonWidth, innerDiameter, pressedButton,wallThickness, holderHeight){
   buttonDepth = pressedButton - innerDiameter;
   difference(){
        translate([0,0,0])
            cube([holderHeight,buttonDepth+wallThickness,buttonWidth+tan(45)*(buttonDepth+wallThickness)+(buttonDepth+wallThickness)/tan(45)]);
        translate([-.5,0,0])
            rotate(-45,[1,0,0])cube([holderHeight+1,buttonDepth+wallThickness,buttonWidth+2*wallThickness]);
   }
}

// makes a hole in the top of the pointer to hold the difractor cylinder
module difractor(difractorDiameter, innerDiameter,wallThickness, lengthToButton){ 
    translate([0,(innerDiameter+2*wallThickness)/2+5,difractorDiameter/2])
        rotate(90,[1,0,0])
            cylinder($fn=200,r=difractorDiameter/2,h=innerDiameter+2*wallThickness+10);
}

// this is the end piece that covers the botom of the holder
// it thins the beam to the beamWidth
module beamThinner(innerDiameter,beamWidth,holderHeight,wallThickness){ 
    translate([-innerDiameter/2-wallThickness,-beamWidth/2,-0.01])
        cube([innerDiameter+holderHeight+2*wallThickness,beamWidth,wallThickness+0.02]);
}

// Generates a cylindrical laser holder with a beam difractor at the end

//  Required Measurements
//innerDiameter     : measure the diameter of the laser
//buttonWidth       : measure the width of the button on the side of the laser
//pressedDiameter   : measure the diameter of the laser pointer with the button pressed         
//lengthToButton    : measure the distance from top of laser pointer to the bottom of the button 
//difractorDiameter : measure the diameter of the difractor rod

//  User Specified Measurements
//holderlength      : desired length of the holder 
                    // requirements:
                       // this length should be greater than the lengthToButton + buttonWidth
//holderHeight      : desired height of the holder
                    // requirements
                       // should be larger than innerDiameter/2 + difractorDiameter/2
//beamWidth         : desired max buttonWidth of the output beam, this is the slit on the bottom of the holder.
//wallThickness     : how thick you want the walls of the laser holder 1.5 is default
//overHangRatio     : how much overlap do you want the holder to have on the top 1.00 is full overlap, 0 is no overlap, if the holder height is less than the inner diameter there will be a gap on the top

// main module to create the holder case
module createHolder(innerDiameter, wallThickness=1.5, holderLength, holderHeight, buttonWidth, pressedDiameter, lengthToButton, difractorDiameter,beamWidth,overHangRatio, $fn=200){
    buttonDepth = pressedDiameter-innerDiameter;
    divotTranslation= wallThickness+lengthToButton-buttonWidth+difractorDiameter;
    difference(){
        union(){
            //housing for the button gap moved up the desired ammount
            translate([-buttonWidth/2,innerDiameter/2+0.001,divotTranslation-(buttonDepth+wallThickness)/tan(45)])
                powerdivot(buttonWidth,innerDiameter,pressedDiameter,wallThickness,holderHeight);
            //generate the cylinder shell
            cylinderShell(innerDiameter, wallThickness, holderLength, holderHeight,buttonWidth, overHangRatio);
        }
        union(){
        //create the power divot
        translate([-buttonWidth/2+wallThickness,pressedDiameter-innerDiameter,divotTranslation])
            powerDivotHole(holderHeight,innerDiameter,buttonWidth,buttonDepth);
        // create the cutoff cube
        cutoffCube(holderHeight,innerDiameter,wallThickness,holderLength);
        translate([0,0,wallThickness])
            difractor(difractorDiameter, innerDiameter,wallThickness, lengthToButton);
        }
        beamThinner(innerDiameter,beamWidth,holderHeight,wallThickness);
    }
}

createHolder(   innerDiameter=12.65, wallThickness=1.5, 
                holderLength=40, holderHeight=12.5, 
                buttonWidth=4.30, pressedDiameter=13.03,
                lengthToButton=28.7,difractorDiameter=3,
                beamWidth=.6, overHangRatio= 0);

