$fn=100;
n=2;h=15;

if($preview){
    translate([1,0,8])
    if("HDD Rack" && 1){
        hdd(n,h,5+h);
        for(j = [0:1:1]){
            mirror([0,j,0])translate([100/2-13,70/2,0])stack(n,h);
            mirror([0,j,0])translate([100/2-13-76,70/2,0])stack(n,h);
        }
    }
    translate([1,0,3])
    if("Rack Screws" && 0){
        stackScrews();
    }
    rotate([0,0,90])translate([0,70,43])
    if("Case Holder" && 1){
        caseHolder();
        caseToPlate();
    }
    d_il=20;
    rotate([0,0,-90])translate([d_il,105.5,-12])
    if("Interlock" && 1){
        interlock(8);//(sin($t*360)+1)*5
        interlockToPlate();
    }
    translate([12.5,0,0])
    if("Baseplate" && 1){
        basePlate(d_il=d_il);
    }
} else {
    w=25;
    h=4;
    l=50;
    main_dia=7.5;
    sec_dia=4;
    sec_length=9;
    mech_offset=8;
    PART = undef;
    if (PART == "stack") {
    stack(n,h);
    }
    if (PART == "case_holder") {
    caseHolder();
    }
    if (PART == "case_to_plate") {
    caseToPlate();
    }
    if (PART == "interlock_mech") {
    interlockBase(w=w,l=l,h=h,main_dia=main_dia,sec_dia=sec_dia,sec_length=sec_length,mech_offset=mech_offset);
    }
    if (PART == "interlock_base") {
    interlockLock(w=w,l=l,h=h,main_dia=main_dia,sec_dia=sec_dia,sec_length=sec_length,mech_offset=mech_offset);
    }
    if (PART == "interlock_to_plate") {
    interlockToPlate();
    }
    if (PART == "baseplate") {
    basePlate();
    }
}

module basePlate(d_il=0){
    h=2;
    l=155;
    w=107;
    il=50;
    face_hole_spacing=22.5;
    face_hole_n=2;
    color("lightgrey")
    difference(){
        union(){
            // Plate
            hull(){
                translate([-10,0,-h/2])cube([l-20,w,h-0.01],center=true);
                translate([0,-d_il,-h/2])cube([l,il,h-0.01],center=true);
            }
            // bottom screw extension
            for(i = [-face_hole_n:1:face_hole_n]){
                translate([-l/2+3,face_hole_spacing*i,-h])cylinder(d=9,h=h);
            }
        }union(){
            // Rack Screws
            translate([-12.5,0,1])stackScrews();
            // mech screws
            for(i = [-1:1:1]){
                translate([l/2-5,-d_il+20*i,-h/2-1])cylinder(d=4.05,h=h+2);
            }
            // case screws
            for(i = [-face_hole_n:1:face_hole_n]){
                translate([-l/2+3,face_hole_spacing*i,-h-1])cylinder(d=4.05,h=h+2);
            }
        }
    }
}

module interlockToPlate(){
    w=25;
    h=4;
    l=50;
    main_dia=7.5;
    sec_dia=4;
    sec_length=9;
    mech_offset=8;
    base_thickness=3;
    color("blue")
    difference(){
        union(){
            // base plate
            translate([0,0,-base_thickness/2])cube([l,w,base_thickness],center=true);
            // extender
            translate([0,-w/2-6/2,-base_thickness/2])cube([l,6,base_thickness],center=true);
            // helper
            hull(){
                // reach
                translate([0,-w/2-6/2-3/2,10/2-base_thickness/2])cube([l,3,10+base_thickness],center=true);
                // top plate
                translate([0,-w/2-6/2-10/2,10-base_thickness/2])cube([l,10,base_thickness],center=true);
            }
        }union(){
            // mechanism
            translate([0,0,-base_thickness])interlockMech(sec_length,mech_offset,0,main_dia,h,0);
            // screwholes bottom
            translate([0,0,-base_thickness])interlockHoles(d=4.05,h=h,w=w-10,l=l-10);
            // screwholes top
            for(i = [-1:1:1]){
                translate([20*i,-w/2-6/2-10/2,-4])cylinder(d=3.2,h=10+base_thickness+2);
            }
        }
    }
}

module interlock(anim=0){
    w=25;
    h=4;
    l=50;
    main_dia=7.5;
    sec_dia=4;
    sec_length=9;
    mech_offset=8;
    difference(){
        union(){
                                 interlockBase(w=w,l=l,h=h,main_dia=main_dia,sec_dia=sec_dia,sec_length=sec_length,mech_offset=mech_offset);
            translate([anim,0,0])interlockLock(w=w,l=l,h=h,main_dia=main_dia,sec_dia=sec_dia,sec_length=sec_length,mech_offset=mech_offset);
        }union(){
        }
    }
}

module interlockBase(w=10,l=10,h=10,main_dia=0,sec_dia=0,sec_length=0,mech_offset=0){
    color("cornflowerblue")
    difference(){
        union(){
            // body
            translate([0,0,h/2])cube([l,w,h],center=true);
        }union(){
            for(i = [0:1:1]){
                mirror([0,i,0])translate([0,w/2,-h/2])rotate([45,0,0])cube([l+2,w,h],center=true);
            }
            // mechanism
            interlockMech(sec_length,mech_offset,0,main_dia,h,0);
            // screwholes
            interlockHoles(h=h,w=w-10,l=l-10);
        }
    }
}

module interlockLock(w=10,l=10,h=10,main_dia=0,sec_dia=0,sec_length=0,mech_offset=0){
    color("lightskyblue")
    difference(){
        union(){
            // main slider
            translate([-sec_length/2,0,h/2+h])cube([l+sec_length,w,h],center=true);
            // sides
            translate([-sec_length/2,(w+3)/2,(h+h)/2])cube([l+sec_length,3,h+h],center=true);
            translate([-sec_length/2,-(w+3)/2,(h+h)/2])cube([l+sec_length,3,h+h],center=true);
            // backplate
            translate([-l/2-sec_length-3/2,0,(h+h)/2])cube([3,w+3+3,h+h],center=true);
            // notches
            for(i = [0:1:1]){
                mirror([0,i,0])translate([-sec_length/2,w/2,-h/2])rotate([45,0,0])cube([l+sec_length,5,h],center=true);
            }
        }union(){
            // notches
            translate([0,0,-20/2+0.1])cube([l*2,l*2,20],center=true);
            // mechanism
            interlockMech(sec_length,mech_offset,sec_dia,main_dia,h,h+h);
            // chamfer
            edge=7;
            for(i = [-1:2:1]){
                translate([-mech_offset-1.5,i*(w+3+edge)/2,h+h])rotate([-i*45,0,0])cube([l+mech_offset*2+3,w,h],center=true);
                translate([-mech_offset-1.5+(-i*(l+mech_offset*2+edge)/2),0,h+h])rotate([0,-1*i*45,0])cube([l,w+3+3,h],center=true);
            }
        }
    }
}

module interlockMech(sec_length,mech_offset,sec_dia,main_dia,h,th){
    union(){
        // main hole
        translate([sec_length/2+mech_offset,0,(th)/2-1])cylinder(d=main_dia,h=h+2);
        // sec hole
        hull(){
            translate([sec_length/2+mech_offset,0,(th)/2-1])cylinder(d=sec_dia,h=h+2);        
            translate([-sec_length/2+mech_offset,0,(th)/2-1])cylinder(d=sec_dia,h=h+2);        
        }
    }
}

module interlockHoles(d=3.2,h=10,w=10,l=10){
    for(i = [-1:1:1]){
        for(j = [-1:2:1]){
            translate([l/2*i,w/2*j,-1])cylinder(d=d,h=h+2);
        }
    }
}

module caseToPlate(){
    plate_height=43;
    plate_thickness=3;
    l=107;
    traverse_height=3; // lid facing height
    traverse_depth=8.5; // depth of lid facing side
    face_height=10; // real face height = face_height + traverse_height
    face_thickness=5;
    face_hole_spacing=22.5; // screw hole spacing
    face_hole_n=2; // n = n*2+1
    face_hole_d=3.2; // m4
    color("lightpink")
    difference(){
        union(){
            // main plate
            translate([0,-face_thickness-3/2,-plate_height/2+traverse_height/2])cube([l,3,plate_height+traverse_height],center=true);
            // bottom reinforcement
            hull(){
                translate([0,-face_thickness-3/2-plate_thickness/2,plate_thickness/2-plate_height])cube([l,plate_thickness*2,plate_thickness],center=true);
                translate([0,-face_thickness-3/2,plate_thickness*2-plate_height])cube([l,plate_thickness,plate_thickness*2],center=true);
            }
        }union(){
            // top screws
            for(i = [-face_hole_n:1:face_hole_n]){
                rotate([90,0,0])translate([face_hole_spacing*i,-face_height/2+traverse_height/2,-1+face_thickness])cylinder(d=4.05,h=plate_thickness+2);
            }
            // bottom screws
            for(i = [-face_hole_n:1:face_hole_n]){
                translate([face_hole_spacing*i,-face_thickness-3/2-plate_thickness/2,-plate_height-1])cylinder(d=3.2,h=10);
            }
        }
    }
}

module caseHolder(){
    nibble_diam=3.05; // diameter of nibble
    nibble_dist=96; // distance of nibbles
    nibble_disp=4; // nibble displacement of zero
    l=107;
    traverse_height=3; // lid facing height
    traverse_depth=8.5; // depth of lid facing side
    face_height=10; // real face height = face_height + traverse_height
    face_thickness=5;
    face_hole_spacing=22.5; // screw hole spacing
    face_hole_n=2; // n = n*2+1
    face_hole_d=3.2; // m4
    color("pink")
    difference(){
        union(){
            // traverse
            translate([0,traverse_depth/2,traverse_height/2])cube([l,traverse_depth,traverse_height],center=true);
            // holder
            translate([0,-face_thickness/2,-face_height/2+traverse_height/2])cube([l,face_thickness,face_height+traverse_height],center=true);
        }union(){
            // nibbles
            for(i = [-1:2:1]){
                translate([nibble_dist/2*i,nibble_disp,-1])cylinder(d=nibble_diam,h=traverse_height+2);
            }
            //screws
            for(i = [-face_hole_n:1:face_hole_n]){
                rotate([90,0,0])translate([face_hole_spacing*i,-face_height/2+traverse_height/2,-1])cylinder(d=3.2,h=face_thickness+2);
            }
        }
    }
}

module stackScrews(h=10,d=4){
    union(){
        if($preview){
            // boundary box
            for(i = [-1:2:1]){
                #translate([0,80/2*i,0.5])cube([106,1,1],center=true);
                #translate([105/2*i,0,0.5])cube([1,81,1],center=true);
            }        
        }
        // screwholes
        for(i = [-1:2:1]){
            for(j = [-1:2:1]){
                translate([i*76/2,j*(70-9)/2,-h-0.1])cylinder(h=h+0.2,d=d);
            }
        }
    }
}

module stack(n=2, h=15){
    color("pink")
    difference(){
        union(){
            // //stacked holders
            for(i = [0:1:n-1]){
                translate([0,0,(h/2)+((h+5)*i)])cube([15,8,h+5],center=true);
            }
            // foot
            translate([0,-15/2+4,-(8/2)])cube([15,15,8],center=true);
        } union(){
            // HDD screwholes and stacked cutouts
            for(i = [0:1:n-1]){
                translate([0,-2,(h/2)+((h+5)*i)])cube([16,4.2,h+0.2],center=true);
                hull(){
                    translate([0,-5,((h+5)*i)+3.3])rotate([-90,0,0])cylinder(d=3.1,h=10);
                    translate([0,-5,((h+5)*i)+2.7])rotate([-90,0,0])cylinder(d=3.1,h=10);
                }
                hull(){
                    translate([0,2,((h+5)*i)+3.3])rotate([-90,0,0])cylinder(d=6.5,h=10);
                    translate([0,2,((h+5)*i)+2.7])rotate([-90,0,0])cylinder(d=6.5,h=10);
                }
            }
            // Bottom screwholes
            translate([0,-15/2+3,-11])cylinder(d=3.4,h=12);
            // chamfer
            translate([0,7,-20/2-8])rotate([45,0,0])cube([20,20,20],center=true);
            translate([0,7,h*n+5*n+5+2.5])rotate([-45,0,0])cube([20,20,20],center=true);
            translate([0,0,(n*h+h)/2-5])rotate([0,0,45])translate([17.3,0,0])cube([20,20,n*h*h],center=true);
            translate([0,0,(n*h+h)/2-5])rotate([0,0,90+45])translate([17.3,0,0])cube([20,20,n*h*h],center=true);
        }
    }
}

module hdd(n=1,h=15,d=25){
    for(i = [0:1:n-1]){
        translate([0,0,d*i])
        difference(){
            union(){
                color("silver")translate([0,0,h/2])cube([100.01,69.9,h],center=true);
                color("black")translate([100/2,0,h/2])cube([1,70,h],center=true);
                color("black")translate([0,0,(h-1)/2])cube([100,70,h-1],center=true);
                color("hotpink")translate([0-5,0,h])cube([40,8,0.01],center=true);
                color("hotpink")translate([20-5,0,h])cylinder($fn=3, d=30, h=0.01);
            } union(){
                rotate([90,0,0])translate([100/2-13,3,(70/2)-9])cylinder(d=3,h=10);
                rotate([90,0,0])translate([100/2-13,3,-(70/2)-1])cylinder(d=3,h=10);
                rotate([90,0,0])translate([100/2-13-76,3,(70/2)-9])cylinder(d=3,h=10);
                rotate([90,0,0])translate([100/2-13-76,3,-(70/2)-1])cylinder(d=3,h=10);
            }
        }
    }
}

