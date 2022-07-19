use <bed.scad>;
include <parameters.scad>;

$fn = 50;
explode = false;

e = explode ? 20 : 0;

bed_gear = true;
bed = true;

echo(str("bed gear bolt: ", bed_gear_bolt_l));
echo(str("bed shaft bolt ", bed_shaft_bolt_l));

module bed_mockup () {
  if (bed_gear) bed_gear();
  translate([0, 0, gear_h + e]) {
    if (bed) bed();
  }
}

bed_mockup();
