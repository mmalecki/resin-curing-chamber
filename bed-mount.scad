use <next-bolt/next-bolt.scad>;
use <bed.scad>;
use <base.scad>;
include <parameters.scad>;

module bed_mount_base_mounts () {
  a = bed_mount_d - standoff_d;
  translate([-a / 2, -a / 2]) children();
  translate([-a / 2, a / 2]) children();
  translate([a  / 2, a / 2]) children();
  translate([a / 2, -a / 2]) children();
}

module bed_mount_base_bolts () {
  bed_mount_base_mounts() 
    bolt(
      bolt, length = bed_mount_base_bolt_l, kind = "socket_head",
      head_top_clearance = bed_mount_base_bolt_countersink);
}

module bed_mount () {
  bed_mount_z = bed_mount_h - bed_mount_bed_bolt_standoff_h;
  difference () {
    union () {
      cube([bed_mount_d, bed_mount_d, bed_mount_h]);
      translate([bed_mount_d / 2, bed_mount_d / 2, bed_mount_z]) {
        bed_mount_bed_mounts()
          cylinder(d = nut_standoff_d, h = bed_mount_bed_bolt_standoff_h);
      }
    }

    translate([bed_mount_d / 2, bed_mount_d / 2, -inset_base_h])
      bed_mount_base_bolts();

    translate([bed_mount_d / 2, bed_mount_d / 2, bed_mount_z]) {
      rotate([0, 0, 0]) {
        bed_mount_bed_mounts() nutcatch_parallel(bolt);
        bed_mount_bed_bolts();
      }
    }
  }
}

bed_mount();
