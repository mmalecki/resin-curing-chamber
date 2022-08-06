use <led-mount.scad>;
use <toggle-switches/toggle-switches.scad>;
include <parameters.scad>;

module cover_led_mount () {
  translate([-base_d / 2 + cover_t, 0, 0]) {
    led_mount_cover_bolts();
  }
}
module led_mount_bolt_clearance () {
  translate([base_d / 2 - cover_t, -led_mount_rib_channel_d / 2, 0]) {
    square([cover_led_mount_bolt_clearance, led_mount_rib_channel_d]);
  }
}

module cover () {
  difference () {
    union () {
      linear_extrude (cover_h) {
        d = base_d;
        id = base_d - 2 * cover_t;
        difference () {
          square([d, d]);
          translate([cover_t, cover_t]) square([id, id]);

          translate([base_d / 2, base_d / 2]) {
            led_mount_bolt_clearance();
            rotate([0, 0, 90]) led_mount_bolt_clearance();
            rotate([0, 0, 180]) led_mount_bolt_clearance();
            rotate([0, 0, 270]) led_mount_bolt_clearance();
          }
        }
      }

      translate([base_d / 2, base_d / 2]) {
        cover_mounts() cylinder(d = standoff_d, h = cover_standoff_h);
      }
    }

    translate([base_d / 2, base_d / 2]) {
      cover_bolts();

      cover_led_mount();
      rotate([0, 0, 90]) cover_led_mount();
      rotate([0, 0, 180]) cover_led_mount();
      rotate([0, 0, 270]) cover_led_mount();
    }

    translate([0, base_d, cover_dc_input_bottom_offset]) {
      translate([cover_dc_input_side_offset, 0, 0])
        rotate([90, 0, 0]) cylinder(d = cover_dc_input_d, h = cover_t);

      translate([cover_switch_side_offset, -cover_t, 0])
        rotate([270, 90, 0]) {
          mts_toggle_switch();
        }
    }


    to_cover_endstop_mount() {
      endstop_mounts() nutcatch_parallel(endstop_bolt);
      endstop_bolts();
    }
  }
}

module endstop_mounts () {
  translate([-endstop_bolt_spacing / 2, 0]) children();
  translate([endstop_bolt_spacing / 2, 0]) children();
}

module endstop_bolts () {
  endstop_mounts() 
    bolt(endstop_bolt, cover_t + endstop_w, kind = "socket_head");
}

module cover_mounts () {
  translate([
    -(base_d - cover_t - standoff_d) / 2,
    -(base_d - cover_t - standoff_d) / 2,
  ]) children();

  translate([
    -(base_d - cover_t - standoff_d) / 2,
    (base_d - cover_t - standoff_d) / 2,
  ]) children();

  translate([
    (base_d - cover_t - standoff_d) / 2,
    (base_d - cover_t - standoff_d) / 2,
  ]) children();

  translate([
    (base_d - cover_t - standoff_d) / 2,
    -(base_d - cover_t - standoff_d) / 2,
  ]) children();
}

module cover_bolts () {
  translate([0, 0, -cover_bolt_offset]) {
    cover_mounts()
      bolt(bolt, length = cover_bolt_l, kind = "socket_head", head_top_clearance = cover_bolt_countersink);
  }
}

module to_cover_endstop() {
  translate([base_d / 4 - cover_t, base_d, endstop_cover_offset])
    rotate([0, 0, 180]) children();
}

module to_cover_endstop_mount () {
  to_cover_endstop () {
    rotate([90, 0, 180]) {
      children();
    }
  }
}

cover();
