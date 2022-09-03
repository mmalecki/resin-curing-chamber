use <bed.scad>;
use <bed-mount.scad>;
use <base.scad>;
use <floor.scad>;
use <cover.scad>;
use <cover-top.scad>;
use <led-mount.scad>;
use <pcb-mount.scad>;
include <parameters.scad>;

explode = true;

e = explode ? 40 : 0;
slack = 0;

floor_ = true;
base = true;
cover = true;
cover_top = true;
bed = true;
pcb_mount = true;
led_mount = true;
bed_mount = true;

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
    translate([0, 0, -e]) floor_();
  }

  if (base) {
    base();
  }

  translate([base_d / 2, base_d / 2, base_h + e + slack]) {
    translate([0, 0, -base_mounting_inset + slack]) {
      if (bed_mount) {
        translate([-bed_mount_d / 2, -bed_mount_d / 2])
          bed_mount();
      }

      translate([0, 0, bed_mount_h + e + slack]) bed_mockup();
    }
  }

  translate([
    cover_base_offset,
    base_d / 2 - led_mount_rib_w / 2,
    base_h - base_mounting_inset + slack + e
  ]) {
    if (led_mount) led_mount_rib();
  }

  translate([
    cover_base_offset + fit / 2 + standoff_d,
    base_d - standoff_d - cover_base_offset - fit / 2,
    base_h - base_mounting_inset
  ]) {
    if (pcb_mount) pcb_mount();
  }

  if (cover) {
    translate([0, 0, base_h - base_mounting_inset + slack + 5 * e]) cover_mockup();
  }

  if (cover_top) {
    translate([0, 0, base_h - base_mounting_inset + cover_h + slack + 6 * e]) cover_top();
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
