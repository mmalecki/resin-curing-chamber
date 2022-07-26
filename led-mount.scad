use <catchnhole/catchnhole.scad>;
include <parameters.scad>;

module led_mount_rib () {
  difference () {
    union () {
      cube([led_mount_rib_t, led_mount_rib_w, led_mount_rib_h]);
      cube([led_mount_rib_bracket_l, led_mount_rib_w, led_mount_rib_t]);
    }

    translate([
      (led_mount_rib_t + led_mount_rib_bracket_l) / 2,
      led_mount_rib_w / 2,
    ]) {
      led_mount_rib_bolts();
    }

    translate([0, led_mount_rib_w / 2]) {
      hull () {
        translate([0, 0, led_mount_rib_channel_offset]) {
          rotate([0, 90, 0]) {
            cylinder(d = led_mount_pad_w + fit, h = led_mount_rib_pad_channel_t);
          }
        }

        translate([0, 0, led_mount_rib_h - led_mount_rib_channel_offset]) {
          rotate([0, 90, 0]) {
            cylinder(d = led_mount_pad_w + fit, h = led_mount_rib_pad_channel_t);
          }
        }
      }
      hull () {
        translate([0, 0, led_mount_rib_channel_offset]) {
          rotate([0, 90, 0]) {
            cylinder(d = led_mount_rib_channel_d, h = led_mount_rib_t);
          }
        }

        translate([0, 0, led_mount_rib_h - led_mount_rib_channel_offset]) {
          rotate([0, 90, 0]) {
            cylinder(d = led_mount_rib_channel_d, h = led_mount_rib_t);
          }
        }
      }
    }
  }
}

module led_mount_clamp () {
  back_w = led_mount_clamp_back_w + 2 * led_mount_clamp_t;
  difference () {
    linear_extrude (led_mount_clamp_h) {
      union () {
        square([led_mount_clamp_back_t, back_w]);
        leg = led_strip_t + loose_fit;
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
      -(led_mount_rib_t - led_mount_rib_pad_channel_t) - led_mount_pad_t,
      (back_w) / 2,
      led_mount_clamp_h / 2
    ]) {
      rotate([0, 90, 0])
        bolt("M2", kind = "socket_head", led_mount_clamp_bolt_l, countersink = 0.25);
    }
  }
}

module led_mount_rib_bolts () {
  led_mount_rib_mounts()
    bolt(led_mount_bolt, length=base_h - base_mounting_inset + led_mount_rib_t);
}

module led_mount_rib_mounts () {
  translate([0, -led_mount_rib_w / 4, 0]) children();
  translate([0, led_mount_rib_w / 4, 0]) children();
}

module led_mount_pad () {
  difference () {
    cube([led_mount_pad_w, led_mount_pad_h, led_mount_pad_t]);
    translate([led_mount_pad_w / 2, led_mount_pad_h / 2]) {
      nutcatch_parallel(led_mount_bolt);
      bolt(led_mount_bolt, length = led_mount_pad_t);
    }
  }
}

led_mount_rib();
translate([0, 0 ,led_mount_rib_h / 2]) {
  translate([led_mount_rib_t, (led_mount_rib_w - led_mount_clamp_back_w - 2 * led_mount_clamp_t) / 2]) {
    led_mount_clamp();
  }
  translate([0, (led_mount_rib_w - led_mount_pad_w) / 2])
    rotate([90, 0, 90])
      led_mount_pad();
}
