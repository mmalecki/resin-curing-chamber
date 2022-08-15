use <next-bolt/next-bolt.scad>;
use <bed.scad>;
use <base.scad>;
include <parameters.scad>;
// This is a shim for v1, in case you wind up building it and your shitty
// engine cannot pull through.
// 15 is the approximate height of the PCB.
bed_raiser_bed_mount_h = 15 + pcb_mount_standoff_h;
bed_raiser_bed_mount_bolt = lookup_kv(next_bolt(bolt, bed_h - bolt_head_l), "next");
echo(bed_raiser_bed_mount_bolt);
bed_raiser_bed_mount_bolt_length_clearance = lookup_kv(bed_raiser_bed_mount_bolt, "length_clearance");


bed_mount_z = bed_raiser_bed_mount_h - bed_raiser_bed_mount_bolt_length_clearance;

module bed_raiser_bed_mount_bolts () {
  bed_raiser_mounts()
    bolt(bolt, length = bed_raiser_bed_mount_h, countersink = 1, kind = "socket_head");
}

module bed_raiser_bed_mount () {
  difference () {
    union () {
      cube([base_bed_raiser_d, base_bed_raiser_d, bed_raiser_bed_mount_h]);
      translate([base_bed_raiser_d / 2, base_bed_raiser_d / 2, bed_mount_z]) {
        bed_gear_mounts() cylinder(d = nut_standoff_d, h = bed_raiser_bed_mount_bolt_length_clearance);
      }
    }

    bed_raiser_bed_mount_bolts();

    translate([base_bed_raiser_d / 2, base_bed_raiser_d / 2, bed_mount_z]) {
      rotate([0, 0, 0]) {
        bed_gear_mounts() nutcatch_parallel(bolt);
        bed_gear_bolts();
      }
    }
  }
}
bed_raiser_bed_mount();
