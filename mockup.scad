use <bed.scad>;
include <parameters.scad>;

$fn = 50;
explode = true;

e = explode ? 10 : 0;

module bed_mockup () {
  bed_gear();
  translate([0, 0, gear_t / 2 + e]) {
    bed();
  }
}

bed_mockup();
