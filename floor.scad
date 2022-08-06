use <bed.scad>;
use <base.scad>;
use <cover.scad>;
use <pcb-mount.scad>;
use <led-mount.scad>;
include <parameters.scad>;

module floor_led_mount () {
  translate([
    base_d / 2 - cover_base_offset,
    led_mount_rib_w / 2,
    0
  ]) {
    rotate([0, 0, 180]) {
      translate([
        (led_mount_rib_t + led_mount_rib_bracket_l) / 2,
        led_mount_rib_w / 2,
      ]) {
        translate([0, 0, -floor_bolt_inset]) led_mount_rib_bolts();
        translate([0, 0, -tight_fit]) led_mount_rib_mounts() nutcatch_parallel(led_mount_bolt);
      }
    }
  }
}
module floor_ () {
  difference () {
    cube([base_d, base_d, floor_h]);

    translate([base_d / 2, base_d / 2]) {
      translate([0, 0, cover_bolt_offset]) cover_bolts();
      cover_mounts() nutcatch_parallel(bolt);

      translate([0, 0, floor_h]) {
        floor_led_mount();
        rotate([0, 0, 90]) floor_led_mount();
        rotate([0, 0, 180]) floor_led_mount();
        rotate([0, 0, 270]) floor_led_mount();

        // Screw run-out only.
        translate([0, 0, -floor_bolt_inset]) {
          translate([0, 0, base_h - base_mounting_inset])
            bed_axle();

          translate([-base_bed_raiser_d / 2, -base_bed_raiser_d / 2])
            bed_raiser_bolts();

          rotate([0, 0, 45])
            translate([bed_gear_teeth / 2, -(engine_mount_w + standoff_d) / 2])
              engine_mount_bolts();

        }

        // Nuts get `fit` only:
        translate([0, 0, -tight_fit]) {
          translate([-base_bed_raiser_d / 2, -base_bed_raiser_d / 2])
            bed_raiser_mounts() nutcatch_parallel(bolt);

          rotate([0, 0, 45]) {
            translate([bed_gear_teeth / 2, -(engine_mount_w + standoff_d) / 2])
              engine_mount_mounts() nutcatch_parallel(bolt);
          }
        }
      }
    }

    translate([
      cover_base_offset + standoff_d, 0
    ]) {
      translate([pcb_mount_w / 2 + fit / 2, standoff_d / 2 - fit / 2, ]) {
        translate([0, 0, floor_h - floor_bolt_inset])
          pcb_mount_bolts();
        translate([0, 0, floor_h - tight_fit])
          pcb_mount_mounts() nutcatch_parallel(pcb_mount_bolt);
      }
    }
  }
}

floor_();
