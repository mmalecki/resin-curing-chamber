use <PolyGear/PolyGear.scad>;
use <catchnhole/catchnhole.scad>;
include <parameters.scad>;

module bed_gear_bolts () {
  translate([bed_gear_bolt_spacing / 2, 0])
    bolt(bolt, length = bed_gear_bolt_l, kind = "socket_head", countersink = 1);

  translate([-bed_gear_bolt_spacing / 2, 0])
    bolt(bolt, length = bed_gear_bolt_l, kind = "socket_head", countersink = 1);
}

module bed_gear () {
  difference () {
    union () {
      translate([0, 0, bed_gear_h / 2]) {
        spur_gear(n = bed_gear_teeth, z = bed_gear_h);
      }

      rotate([180, 0, 0])
        cylinder(
          d1 = bed_gear_spacer_d_top,
          d2 = bed_gear_spacer_d_bottom,
          h = bed_gear_spacer_h
        );
    }

    bed_gear_bolts();

    translate([bed_gear_bolt_spacing / 2, 0])
      nutcatch_parallel(bolt);

    translate([-bed_gear_bolt_spacing / 2, 0])
      nutcatch_parallel(bolt);

    translate([0, 0, -bed_shaft_bolt_l + bed_gear_h + bed_h])
      bolt(bed_shaft_bolt, length = bed_shaft_bolt_l, kind = "socket_head", countersink = 1, head_diameter_clearance = bolt_shaft_head_clearance);

  }
}

module bed () {
  difference () {
    cylinder(d = bed_d, h = bed_h);
    translate([0, 0, -bed_gear_bolt_l+bed_h]) bed_gear_bolts();
    translate([0, 0, -bed_shaft_bolt_l + bed_h])
      bolt(bed_shaft_bolt, length = bed_shaft_bolt_l, kind = "socket_head", countersink = 1, head_diameter_clearance = bolt_shaft_head_clearance);
  }
}

module engine_gear () {
  spur_gear(n = engine_gear, z = bed_gear_h);
}

bed();
