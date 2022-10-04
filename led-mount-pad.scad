use <catchnhole/catchnhole.scad>;
include <parameters.scad>;
module led_mount_pad () {
  difference () {
    cube([led_mount_pad_w, led_mount_pad_h, led_mount_pad_t]);
    translate([led_mount_pad_w / 2, led_mount_pad_h / 2]) {
      nutcatch_parallel(led_mount_bolt);
      bolt(led_mount_bolt, length = led_mount_pad_t);
    }
  }
}

led_mount_pad();
