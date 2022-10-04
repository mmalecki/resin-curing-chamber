use <bed.scad>;
use <bed-mount.scad>;
use <base.scad>;
use <floor.scad>;
use <cover.scad>;
use <cover-top.scad>;
use <led-mount.scad>;
use <led-mount-pad.scad>;
use <led-mount-clamp.scad>;
use <pcb-mount.scad>;
include <parameters.scad>;

// Whether to explode the design
explode = true;

// Slack between parts
slack = 0;

floor_ = true;
base = true;

// Whether to display the bed mount
bed_mount = true;
// Whether to display the bed
bed = true;

// Whether to display the PCB mount
pcb_mount = true;

led_mount_rib = true;
led_mount_pad = true;
led_mount_clamp = true;

// Whether to display the cover
cover = true;
// Whether to display the top cover
cover_top = true;

e = explode ? 40 : 0;
module endstop () {
  difference () {
    translate([-endstop_l / 2, 0, -endstop_bolt_offset]) {
      cube([endstop_l, endstop_w+1, endstop_h]);
      color("red") cube([endstop_l, endstop_w, endstop_deact_h]);
      color("green") cube([endstop_l, endstop_w, endstop_act_h]);
    }
    translate([0, -cover_t, 0]) rotate([270, 0, 0]) endstop_bolts();
  }
}


module mockup () {
  if (floor_) {
    floor_();
  }

  if (base) {
    translate([0, 0, floor_h + e + slack]) base();
  }

  translate([0, 0, floor_h + inset_base_h + 2 * e + 2 * slack]) {
    translate([base_d / 2, base_d / 2]) {
      if (bed_mount) {
        translate([-bed_mount_d / 2, -bed_mount_d / 2])
          bed_mount();
      }

      if (bed) translate([0, 0, bed_mount_h + e + slack]) bed_mockup();
    }

    translate([
      cover_base_offset,
      base_d / 2 - led_mount_rib_w / 2
    ]) {
      if (led_mount_rib) led_mount_rib();
      translate([0, 0, led_mount_rib_h / 2]) {
        if (led_mount_clamp) {
          translate([e + led_mount_rib_t, (led_mount_rib_w - led_mount_clamp_back_w - 2 * led_mount_clamp_t) / 2]) {
            led_mount_clamp();
          }
        }
        if (led_mount_pad) {
          translate([-e, (led_mount_rib_w - led_mount_pad_w) / 2, (led_mount_clamp_h - led_mount_pad_h) / 2]) {
            rotate([90, 0, 90])
              led_mount_pad();
          }
        }
      }
    }

    translate([
      cover_base_offset + fit / 2 + standoff_d,
      base_d - standoff_d - cover_base_offset - fit / 2,
    ]) {
      if (pcb_mount) pcb_mount();
    }

    if (cover) {
      translate([0, 0, slack + e]) cover_mockup();
    }

    if (cover_top) {
      translate([0, 0, cover_h + slack + 4 * e]) cover_top();
    }
  }
}

module cover_mockup () {
  cover();
  translate([0, -cover_t, 0]) to_cover_endstop() endstop();
}

module bed_mockup () {
  translate([0, 0, e + slack]) {
    if (bed) bed();
  }
}

mockup();
