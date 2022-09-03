use <catchnhole/catchnhole.scad>;
include <parameters.scad>;

module bed_mount_bed_bolts () {
  bed_mount_bed_mounts()
    bolt(bolt, length = bed_mount_bed_bolt_l, kind = "socket_head");
}
module bed_mount_bed_mounts () {
  translate([bed_mount_bed_bolt_s / 2, 0])
    children();

  translate([-bed_mount_bed_bolt_s / 2, 0])
    children();
}

module bed () {
  difference () {
    cylinder(d = bed_d, h = bed_h);
    translate([0, 0, -bed_mount_bed_bolt_standoff_h]) bed_mount_bed_bolts();
  }

  translate([0, 0, bed_h]) {
    linear_extrude(bed_rim_h) {
      difference () {
        circle(d = bed_d);
        circle(d = bed_d - 2 * bed_rim_t);
      }
    }
  }
}

bed();
