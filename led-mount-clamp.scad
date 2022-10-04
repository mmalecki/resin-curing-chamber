use <catchnhole/catchnhole.scad>;
include <parameters.scad>;

module led_mount_clamp () {
  back_w = led_mount_clamp_back_w + 2 * led_mount_clamp_t;
  leg = led_strip_t + loose_fit;

  difference () {
    linear_extrude (led_mount_clamp_h) {
      union () {
        square([led_mount_clamp_back_t, back_w]);
        translate([led_mount_clamp_back_t, 0]) {
          square([leg, led_mount_clamp_t]);
          translate([0, led_mount_clamp_back_w + led_mount_clamp_t])
            square([leg, led_mount_clamp_t]);

          translate([leg, 0]) {
            square([led_mount_clamp_t, led_mount_clamp_front_w / 2]);
            translate([0, back_w - led_mount_clamp_front_w / 2])
              square([led_mount_clamp_t, led_mount_clamp_front_w / 2]);
          }
        }

      }
    }

    // This bolt starts behind us, in the led clamp pad.
    translate([
      -led_mount_rib_t,
      (back_w) / 2,
      led_mount_clamp_h / 2
    ]) {
      rotate([0, 90, 0])
        bolt("M2", kind = "socket_head", led_mount_clamp_bolt_l, countersink = 0.25);
    }
  }
}

led_mount_clamp();
