use <catchnhole/catchnhole.scad>;
use <bed.scad>;
use <bed-mount.scad>;
use <cover.scad>;
use <led-mount.scad>;
use <pcb-mount.scad>;
include <parameters.scad>;

module base_led_mount () {
  translate([
    base_d / 2 - cover_base_offset,
    led_mount_rib_w / 2,
    0
  ]) {
    rotate([0, 0, 180]) {
      translate([0, 0, base_h - base_mounting_inset])
        translate([-fit / 2, -fit / 2])
          cube([led_mount_rib_bracket_l + fit, led_mount_rib_w + fit, base_mounting_inset]);

      translate([
        (led_mount_rib_t + led_mount_rib_bracket_l) / 2,
        led_mount_rib_w / 2,
      ]) {
        led_mount_rib_bolts();
        led_mount_rib_mounts() nutcatch_parallel(led_mount_bolt);
      }
    }
  }
}

module base () {
  difference () {
    union () {
      cube([base_d, base_d, base_h - base_mounting_inset]);
      translate([cover_t + cover_fit / 2, cover_t + cover_fit / 2, base_mounting_inset]) {
        d = base_d - 2 * cover_t - fit;
        cube([d, d, base_h - base_mounting_inset]);
      }
    }


    translate([base_d / 2, base_d / 2]) {
      translate([-bed_mount_d / 2, -bed_mount_d / 2]) {
        bed_mount_base_bolts();
        bed_mount_base_mounts() nutcatch_parallel(bolt);

        translate([-fit / 2, -fit / 2, base_h - base_mounting_inset]) {
          cube([bed_mount_d + fit, bed_mount_d + fit, base_mounting_inset]);
        }
      }

      base_led_mount();
      rotate([0, 0, 90]) base_led_mount();
      rotate([0, 0, 180]) base_led_mount();
      rotate([0, 0, 270]) base_led_mount();

      translate([0, 0, floor_h]) cover_bolts();
      translate([0, 0, base_h - base_mounting_inset])
        cover_mounts() cylinder(d = standoff_d + fit, h = base_mounting_inset);
    }

    translate([
      cover_base_offset + standoff_d,
      base_d - cover_base_offset - standoff_d - fit,
    ]) {
      translate([0, 0, base_h - base_mounting_inset])
        cube([pcb_mount_w + fit, standoff_d + fit, base_mounting_inset]);

      translate([pcb_mount_w / 2 + fit / 2, standoff_d / 2 - fit / 2]) {
        pcb_mount_mounts() nutcatch_parallel(pcb_mount_bolt);
        pcb_mount_bolts();
      }
    }
  }

}

base();
