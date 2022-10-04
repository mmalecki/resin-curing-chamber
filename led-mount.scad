use <catchnhole/catchnhole.scad>;
use <led-mount-pad.scad>;
use <led-mount-clamp.scad>;
include <parameters.scad>;

module rib_cutout(d, h) {
  hull () {
    translate([0, 0, led_mount_rib_channel_offset]) {
      rotate([0, 90, 0]) {
        cylinder(d = d, h = h);
      }
    }

    translate([0, 0, led_mount_rib_h - led_mount_rib_channel_offset]) {
      rotate([0, 90, 0]) {
        cylinder(d = d, h = h);
      }
    }
  }
}

module to_led_mount_cover_mount () {
  translate([led_mount_rib_t, 0, led_mount_rib_h - led_mount_rib_nutcatch_offset])
    rotate([0, 270, 0]) children();
}

module led_mount_cover_bolts () {
  to_led_mount_cover_mount () {
    bolt(led_mount_bolt, length = led_mount_rib_t + cover_t, kind = "socket_head");
  }
}

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
      rib_cutout(led_mount_pad_w + fit, h = led_mount_pad_t);
      rib_cutout(led_mount_rib_channel_d, h = led_mount_rib_t);

      to_led_mount_cover_mount()
        nutcatch_parallel(led_mount_bolt);
      led_mount_cover_bolts();
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

led_mount_rib();
