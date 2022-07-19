use <PolyGear/PolyGear.scad>;
use <catchnhole/catchnhole.scad>;
include <parameters.scad>;

module bed_gear_bolts () {
  translate([bed_gear_bolt_spacing / 2, 0])
    bolt(bolt, length = bed_h + gear_t, kind = "socket_head", countersink = 1);

  translate([-bed_gear_bolt_spacing / 2, 0])
    bolt(bolt, length = bed_h + gear_t, kind = "socket_head", countersink = 1);
}

module bed_gear () {
  difference () {
    spur_gear(n = bed_gear_teeth, z = gear_t);
    translate([0, 0, -gear_t / 2]) {
      bed_gear_bolts();

      translate([bed_gear_bolt_spacing / 2, 0])
        nutcatch_parallel(bolt);

      translate([-bed_gear_bolt_spacing / 2, 0])
        nutcatch_parallel(bolt);
    }
  }
}

module bed () {
  difference () {
    cylinder(d = bed_d, h = bed_h);
    translate([0, 0, -bed_h]) bed_gear_bolts();
  }
}

module engine_gear () {
  spur_gear(n = engine_gear, z = gear_t);
}
