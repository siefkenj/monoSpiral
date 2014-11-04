//generates the outer cylinder with a power divot hole and tapered upper edge
module cylinderShell(innerDiameter, wallThickness, holderLength, holderHeight, width, topGap){ 
    difference(){
        //outer cylinder
        union(){
            cylinder(r=innerDiameter/2 + wallThickness, h=holderLength);
            translate([0,-(innerDiameter+2*wallThickness)/2, -0.001])
                cube([innerDiameter+holderLength,innerDiameter+2*wallThickness,holderLength]);
        }
        union(){
            //inner cylinder
            translate([0,0,-.5])cylinder(r=innerDiameter/2,h=holderLength+1);
            translate([0,-(innerDiameter)/2, -0.01])
                cube([innerDiameter+holderLength,innerDiameter,holderLength+1]);
        }
    }
}

// makes the area that will hold the button 
module powerDivotHole(holderHeight,innerDiameter,width){ 
    union(){
        cube([holderHeight,innerDiameter/2,width]);
        translate([0,innerDiameter/2-(width*(tan(45))),0])rotate(45,[1,0,0])cube([holderHeight,width/(cos(45)),innerDiameter/2]);
    }
}

// makes a large cube that cuts off the top of the holder at a desired height
module cutoffCube(holderHeight,innerDiameter,wallThickness,holderLength){       //this makes a cube that cuts off at the desired height
    translate([holderHeight-(innerDiameter+wallThickness)/2,-(2*innerDiameter+2*wallThickness)/2-.5, -0.5])
        cube([innerDiameter+holderLength+1,2*innerDiameter+2*wallThickness+1,holderLength+1]);
}

// makes the exterior wall of the power button hole
module powerdivot(width, innerDiameter, pressedButton,wallThickness, holderHeight){
   buttonDepth = pressedButton - innerDiameter;
   difference(){
        cube([holderHeight,buttonDepth+wallThickness,width+2*wallThickness]);
        translate([-.5,0,0])rotate(-45,[1,0,0])cube([holderHeight+1,buttonDepth+wallThickness,width+2*wallThickness]);
       translate([wallThickness,-.001,width+wallThickness-width])cube([holderHeight+1, buttonDepth,width]);
   }
}

// makes a hole in the top of the pointer to hold the difractor cylinder
module difractor(difractorDiameter,topGap, innerDiameter,wallThickness, laserTop){ 
    translate([difractorDiameter/2,(innerDiameter+2*wallThickness)/2+.5,difractorDiameter/2])
        rotate(90,[1,0,0])
            cylinder($fn=200,r=difractorDiameter/2,h=innerDiameter+2*wallThickness+1);
}

//innerDiameter     : measure the diameter of the laser
//wallThickness     : how thick you want the walls of the laser holder 1.5 is default
//holderlength      : desired length of the holder
//holderHeight      : desired height of the holder
//divotWidth        : width of the button on the side of the holder
//pressedDiameter   : measure the diameter of the laser pointer with the button pressed         
//divotTranslation  : distance from top of laser pointer to the bottom of the button 
//topGap            : desired distance from the top of the difractor to the top of the holder

module createHolder(innerDiameter, wallThickness=1.5, holderLength, holderHeight, divotWidth, pressedDiameter, divotTranslation,topGap, difractorDiameter,laserTop,$fn=200){
    difference(){
        union(){
            //housing for the button gap moved up the desired ammount
            translate([-divotWidth/2,innerDiameter/2,holderLength-divotTranslation-topGap-wallThickness])
                powerdivot(divotWidth,innerDiameter,pressedDiameter,wallThickness,holderHeight);
            //generate the cylinder shell
            cylinderShell(innerDiameter, wallThickness, holderLength, holderHeight,divotWidth,topGap);
        }
        //create the power divot
        translate([-divotWidth/2+wallThickness,pressedDiameter-innerDiameter,holderLength-divotTranslation-topGap])
            powerDivotHole(holderHeight,innerDiameter,divotWidth);
        // create the cutoff cube
        cutoffCube(holderHeight,innerDiameter,wallThickness,holderLength);
        translate([0,0,holderLength-topGap])difractor(difractorDiameter,topGap, innerDiameter,wallThickness, laserTop);
    }
}


//powerdivot(4.25,12.68,13.57,1.5,10);
createHolder(12.68, 1.5, 40, 12.5, 4.25, 13.57,28.7,5,2.95,28.52);
