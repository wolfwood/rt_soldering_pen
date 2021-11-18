gap = [.1, .1, .1];

epsilon = .1;

screw_dia = 3.3;
washer_dia = 9;

total_z = 34;
block = [20, 60, 24]; //(washer_dia+2)*3];
shaft = [20, total_z-block.z];

chamfer_margin = 3;

module blank(chamfer=true) {
  flange = [block.x/2+1, block.y/2-shaft.x/2, /*5*/block.z/3];

  difference() {
    translate([gap.x, -block.y/2, 0]) if (!chamfer) {
      cube([block.x/2-gap.x, block.y, block.z]);
    } else {
      minkowski() {
	cube([block.x/2-gap.x-chamfer_margin, block.y-2*chamfer_margin, block.z-2*chamfer_margin]);
	translate([0,chamfer_margin,chamfer_margin]) difference() {
	  sphere(r=chamfer_margin);
	  translate([-2*chamfer_margin,0,0]) cube(4*[chamfer_margin,chamfer_margin,chamfer_margin], true);
	}
      }
    }

    translate([0, shaft.x/2, -epsilon]) cube(flange+[0, epsilon, gap.z+epsilon]);
    translate([0, -block.y/2-epsilon, block.z-flange.z-gap.z]) cube(flange+[0, epsilon, gap.z+epsilon]);
  }

  translate([-block.x/2, shaft.x/2+gap.y, block.z-flange.z+gap.z]) if (!chamfer) {
    cube(flange-[0, gap.y, gap.z]);
  } else {
    minkowski() {
      cube(flange-[chamfer_margin, gap.y+chamfer_margin, gap.z+chamfer_margin]);
      translate([chamfer_margin,0,0]) difference() {
	sphere(r=chamfer_margin);
	translate([2*chamfer_margin,0,0]) cube(4*[chamfer_margin,chamfer_margin,chamfer_margin], true);
	translate([0,-2*chamfer_margin,0]) cube(4*[chamfer_margin,chamfer_margin,chamfer_margin], true);
	translate([0,0,-2*chamfer_margin]) cube(4*[chamfer_margin,chamfer_margin,chamfer_margin], true);
      }
    }
  }

  translate([-block.x/2, -(block.y/2), 0])  if (!chamfer) {
    cube(flange-[0, gap.y, gap.z]);
  } else {
    minkowski() {
      cube(flange-[chamfer_margin, gap.y+chamfer_margin, gap.z+chamfer_margin]);
      translate([chamfer_margin,chamfer_margin,chamfer_margin]) difference() {
	sphere(r=chamfer_margin);
	translate([2*chamfer_margin,0,0]) cube(4*[chamfer_margin,chamfer_margin,chamfer_margin], true);
	translate([0,2*chamfer_margin,0]) cube(4*[chamfer_margin,chamfer_margin,chamfer_margin], true);
	translate([0,0,2*chamfer_margin]) cube(4*[chamfer_margin,chamfer_margin,chamfer_margin], true);
      }
    }
  }

  translate([0,0,-shaft.y/2+chamfer_margin/2]) difference() {
    cylinder($fn=120, d=shaft.x, h=shaft.y+chamfer_margin, center=true);
    translate([-shaft.x+gap.x,0,0]) cube([2*shaft.x,2*shaft.x,shaft.y*2], true);
  }
}

//blank($fn=60);
//rotate([0,0,180]) blank($fn=60);

module jack_holder(chamfer=true) {
  difference() {
    blank(chamfer=chamfer);

    // screw holes
    translate([0,(block.y/2 - shaft.x/2)/2 + shaft.x/2, block.z/2]) rotate([0,90,0]) {
      cylinder(d=screw_dia, h=2*block.x, center=true);
      translate([0,0,block.x/4]) cylinder(d=washer_dia, h=block.x);
      rotate([0,180,0]) translate([0,0,block.x/4]) cylinder(d=washer_dia, h=block.x);
    }
    translate([0,-(block.y/2 - shaft.x/2)/2 - shaft.x/2, block.z/2]) rotate([0,90,0]) {
      cylinder(d=screw_dia, h=2*block.x, center=true);
      translate([0,0,block.x/4]) cylinder(d=washer_dia, h=block.x);
      rotate([0,180,0]) translate([0,0,block.x/4]) cylinder(d=washer_dia, h=block.x);
    }

    // hollw for jack threaded cylinder + electrical connections
    threads = [11, 30];
    translate([0,0,block.z-threads.y]) cylinder(d=threads.x, h=threads.y+epsilon);

    // hex 'wrench' accomadating and tightening internal hex nut
    hex = [16.4, 3];
    thread_z = 8.5-2.5; // washer and rubber plug take up some space
    translate([0,0,block.z-thread_z]) cylinder($fn=6, d=hex.x, h=hex.y);

    // holes for 18 awg silicone wires
    wire_dia = 2.3;
    translate([0,0,-total_z]) linear_extrude(total_z*2) hull() {
      translate([0, 5-wire_dia, 0]) circle(d=wire_dia);
      translate([0, -(5-wire_dia), 0]) circle(d=wire_dia);
    }
      //cylinder(d=wire_dia, h=, center=true);
      //translate([0, 5-wire_dia, 0]) cylinder(d=wire_dia, h=total_z*2, center=true);
  }
}

jack_holder($fn=60);
//rotate([0,0,180])jack_holder($fn=60);
