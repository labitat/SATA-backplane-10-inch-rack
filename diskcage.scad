*translate([-8.4, 0, 0])
rotate([90, 0, 90])
import ("cooler-master-25-inch-hdd-bracket.3mf");

diskwidth=70;

disks=10;
x_interval=13;
wall=2;
flange=25;
shelf=5;
hole_d=4;
hole_d2=8;
z_interval=74;
height=100;
$fn=50;
mounting_holes=105;

for(y=[0, 1])
	mirror([0, y, 0])
		translate([0, diskwidth/2, 0])
			side();

*translate([13+105/2, 0, -16])
#	cube([120, 120, 30], center=true);

module side(){
	difference(){
		union(){
			cube([disks*x_interval+wall, wall, height]);
			for(x=[0:disks])
				translate([x_interval*x, -shelf, 0])
					cube([wall, wall+shelf, height]);
			cube([disks*x_interval+wall, flange, wall]);
		}
		for(x=[0:disks],z=[0, z_interval])
			translate([x_interval*x+5.6, -1, z+(height-z_interval)/2])
				rotate([-90, 0, 0])
					hull(){
						translate([0, (hole_d-hole_d2)/2, 0])
							cylinder(d=hole_d, h=wall+2);
						translate([0, -(hole_d-hole_d2)/2, 0])
							cylinder(d=hole_d, h=wall+2);
					}
		for(x=[-.5, .5])
			translate([(disks*x_interval+wall)/2+mounting_holes*x, (mounting_holes-diskwidth)/2, -1])
				cylinder(d=5, h=wall+2);
	}
}