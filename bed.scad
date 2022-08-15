use <PolyGear/PolyGear.scad>;
use <catchnhole/catchnhole.scad>;
include <parameters.scad>;

module bed_gear_bolts () {
  bed_gear_mounts() bolt(bolt, length = bed_gear_bolt_l, kind = "socket_head", countersink = 1);
}
module bed_gear_mounts () {
  translate([bed_gear_bolt_s / 2, 0])
    children();

  translate([-bed_gear_bolt_s / 2, 0])
    children();
}

module bed_gear () {
  difference () {
    union () {
      cylinder(d = bed_gear_bearing_housing_d, h = bed_bearing_h);

      translate([0, 0, bed_gear_h / 2 + bed_bearing_h]) {
        spur_gear(n = bed_gear_teeth, z = bed_gear_h);
      }

    }

    translate([0, 0, -base_bed_raiser_h - base_bed_raiser_spacer_h])
      bed_axle();

    translate([0, 0,  bed_bearing_h]) {
      bed_gear_bolts();

      translate([bed_gear_bolt_s / 2, 0, nut_height(bolt)])
        rotate([0, 180]) nutcatch_parallel(bolt, height_clearance = bed_bearing_h);

      translate([-bed_gear_bolt_s / 2, 0, nut_height(bolt)])
        rotate([0, 180]) nutcatch_parallel(bolt, height_clearance = bed_bearing_h);

    }
  }
}

module bed () {
  difference () {
    cylinder(d = bed_d, h = bed_h);
    translate([0, 0, -bed_gear_bolt_l+bed_h]) bed_gear_bolts();
    translate([0, 0, -base_bed_raiser_h - base_bed_raiser_spacer_h - bed_gear_h - bed_bearing_h])
      bed_axle();
  }
}

module bed_axle () {
  translate([0, 0, base_bed_raiser_h + base_bed_raiser_spacer_h]) {
    cylinder(d = bed_bearing_od + press_fit, h = bed_bearing_h);
  }

  nutcatch_parallel(bed_shaft_bolt, kind = "hexagon_lock");
  bolt(
    bed_shaft_bolt,
    length = bed_shaft_bolt_l,
    kind = "socket_head",
    length_clearance = base_h - base_mounting_inset,
    head_diameter_clearance = bolt_shaft_head_clearance
  );
}

bed_gear();
