use <cover.scad>;
include <parameters.scad>;

module led_mount_rib_clearance () {
  t =led_mount_rib_t + fit;
  w_fit = led_mount_rib_w + fit;
  translate([base_d / 2- cover_t - t, -w_fit / 2]) {
    square([t, w_fit]);
  }
}

module cover_top () {
  cube([base_d, base_d, cover_top_h]);
  cover_t_fit = cover_t + tight_fit;
  translate([cover_t_fit, cover_t_fit, cover_top_h]) {
    linear_extrude (endstop_activator_h) {
      od = base_d - 2 * cover_t - tight_fit;
      id = od - 2 * endstop_w;
      difference () {
        square([od, od]);
        translate([endstop_w, endstop_w]) square([id, id]);

        translate([od / 2, od / 2]) {
          led_mount_rib_clearance();
          rotate([0, 0, 90]) led_mount_rib_clearance();
          rotate([0, 0, 180]) led_mount_rib_clearance();
          rotate([0, 0, 270]) led_mount_rib_clearance();
        }
     }
    }
  }
}

cover_top();
