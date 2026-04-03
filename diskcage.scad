
disks=9;
x_interval=10;
diskwidth=70.2;
diskheight=100;
diskthickness=6.5;

// Fan size,	hole pitch,  Fan thickness
fan=[
   92, 82.5, 25
// 120, 105, 25
// 140, 124.5, 25
// 200, 154, 25
// 220, 170, 25
];

echo(fan[1]);
disk_z_offset=15;
wall=2;
flange=(fan[0]-diskwidth)/2;
flangewall=2*wall;
shelf=2*wall;
hole_d=4;
hole_d2=8;
z_interval=74;
height=diskheight+disk_z_offset;
flangeRadius=5;
$fn=50;

echo(XYZ=[disks*x_interval+wall, 2*flange+diskwidth, height]);
*#translate([0, -diskwidth-flange, 0]) cube([disks*x_interval+wall, 2*flange+diskwidth, height]);


module cage(){
for(n=[0, 1])
	translate([0, -diskwidth/2+(-fan[0]-1)*n, 0])
		for(y=[0, 1])
			mirror([0, y, 0])
				translate([0, diskwidth/2, 0])
					side();
}

// 120mm fan mockup
translate([(disks*x_interval+wall)/2, -diskwidth/2, -fan[2]/2])
%	cube([fan[0], fan[0], fan[2]], center=true);

// Disks mockup
for(x=[0:disks-1])
	translate([(x_interval-wall-diskthickness)/2+wall+x_interval*x, -diskwidth, disk_z_offset])
		%cube([diskthickness, diskwidth, diskheight]);

module side(){
	difference(){
		union(){
		
			// Main side wall
			cube([disks*x_interval+wall, wall, height]);
			
			// Disk dividers
			for(x=[0:disks])
				translate([x_interval*x, -shelf, 0])
					cube([wall, wall+shelf, height]);
			
			// End walls
			for(x=[0, disks*x_interval])
			translate([x, -diskwidth, 0])
				cube([wall, diskwidth, disk_z_offset+0*wall]);
			
			// Flange
			hull(){
				cube([disks*x_interval+wall, wall, flangewall]);
				intersection(){
					for(x=[flangeRadius,disks*x_interval+wall-flangeRadius])
						translate([x, flange-flangeRadius, 0])
							cylinder(r=flangeRadius, h=flangewall);
					cube([disks*x_interval+wall, flange, flangewall]);
				}
			}
			
			// Flange reinforcements
			for(x=[1:disks-2])
				translate([x_interval*(x+0.5)+wall, wall, flangewall])
					rotate([0, 270, 0])
						linear_extrude(h=wall)
							polygon([[0, 0], [0, flange-wall], [flange, 0]]);
			
			// Flange-Wall chamfer
			translate([disks*x_interval+wall, wall-0.01, flangewall-0.01])
				rotate([0, 270, 0])
					linear_extrude(h=disks*x_interval+wall)
						polygon([[0, 0], [0, 2], [2, 0]]);
		
			// Mounting eyes
			for(z=[26, 68])
				hull(){
					translate([0, 0, disk_z_offset+z-10])
						cube([2*wall, wall, 20]);
					translate([0, wall+4.5, disk_z_offset+z])
						rotate([0, 90, 0])
							cylinder(r=4.5, h=2*wall);
				}
		}
		
		// Oval mounting holes for disks
		for(x=[0:disks],z=[9, 86])
			translate([x_interval*x+5.6, -1, z+disk_z_offset])
//		translate([x_interval*x+5.6, -1, z+(height-z_interval)/2+disk_z_offset])
				rotate([-90, 0, 0])
					hull(){
						translate([0, (hole_d-hole_d2)/2, 0])
							cylinder(d=hole_d, h=wall+2);
						translate([0, -(hole_d-hole_d2)/2, 0])
							cylinder(d=hole_d, h=wall+2);
					}

		// Flange holes with clearance for fan mounts
		for(x=[-.5, .5])
		translate([(disks*x_interval+wall)/2+fan[1]*x, (fan[1]-diskwidth)/2, -1]) {
			cylinder(d=5, h=flangewall+2);
			translate([0, 0, 1+flangewall])
				cylinder(d=10, h=10);
		}
		
		// Mounting eye holes
#		for(z=[26, 68])
			translate([2*wall+1, wall+4.5, disk_z_offset+z])
				rotate([0, -90, 0])
					cylinder(d=3.3, h=20);
	}
}

// LRS-75 mount
// https://docs.rs-online.com/f3fc/0900766b814e41f9.pdf
translate([0, flange+1, 10])
rotate([0, -90, -90])
union(){
	cube([99, 97, 30]);
	// Bottom mounts
	*union(){
		translate([4.5, 85, 0])
			cylinder(h=30, d=3.5, center=true);
		translate([4.5+92.5, 6.5, 0])
			cylinder(h=30, d=3.5, center=true);
		translate([20.5, 45.5, 0])
			cylinder(h=30, d=3, center=true);
		translate([20.5+55, 45.5, 0])
			cylinder(h=30, d=3, center=true);
	}
	// Side mounts
	#union(){
	translate([6.5, 0, 26])
		rotate([90, 0, 0])
			cylinder(h=30, d=3.5, center=true);
	translate([6.5+90, 0, 14.5])
		rotate([90, 0, 0])
			cylinder(h=30, d=3.5, center=true);
	translate([10, 0, 15])
		rotate([90, 0, 0])
			cylinder(h=30, d=3, center=true);
	translate([10+74, 0, 15])
		rotate([90, 0, 0])
			cylinder(h=30, d=3, center=true);
	}
	for(y=[40:9.5:80])
	translate([0, y, 20])
		rotate([0, 90, 0])
			cylinder(d=8, h=30, center=true);
}

// HP t740 mount (VESA100)
%translate([0, -60, 70])
rotate([0, -90, 0]){
	difference(){
		// mounting plate
		translate([-209/2, -116, 1])
			cube([0*209+250, 220, 6]);
		for(x=[-50, 50], y=[-50, 50])
			translate([x, y, 0])
				cylinder(d=4, h=10);
	}
*	// t740 unit
	translate([0, 0, 35])
		cube([209, 209, 50], center=true);
}
cage();
