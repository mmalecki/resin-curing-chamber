use <PolyGear/PolyGear.scad>;
use <catchnhole/catchnhole.scad>;
use <bed.scad>;
use <cover.scad>;
use <led-mount.scad>;
include <parameters.scad>;

module base_led_mount () {
  translate([0, 0, base_h - base_mounting_inset])
    translate([-fit / 2, -fit / 2])
      cube([led_mount_rib_bracket_l + fit, led_mount_rib_w + fit, base_mounting_inset]);

  translate([
    (led_mount_rib_t + led_mount_rib_bracket_l) / 2,
    led_mount_rib_w / 2,
  ]) {
    led_mount_rib_bolts();
  }
}
module base () {
  difference () {
    union () {
      cube([base_d, base_d, base_h - base_cover_inset]);
      translate([cover_t + cover_fit / 2, cover_t + cover_fit / 2, base_cover_inset]) {
        d = base_d - 2 * cover_t - fit;
        cube([d, d, base_h - base_cover_inset]);
      }
    }


    translate([base_d / 2, base_d / 2]) {
      translate([-base_bed_raiser_d / 2, -base_bed_raiser_d / 2]) {
        bed_raiser_bolts();
        bed_raiser_mounts() nutcatch_parallel(bolt);

        translate([-fit / 2, -fit / 2, base_h - base_mounting_inset]) {
          cube([base_bed_raiser_d + fit, base_bed_raiser_d + fit, base_mounting_inset]);
        }
      }

      // Screw run-out only.
      translate([0, 0, base_h - base_mounting_inset]) bed_axle();

      rotate([0, 0, 45]) {
        translate([bed_gear_teeth / 2, -(engine_mount_w + standoff_d) / 2]) {
          engine_mount_bolts();
          engine_mount_mounts() nutcatch_parallel(bolt);

          translate([-fit / 2, -fit / 2, base_h - base_mounting_inset]) {
            cube([engine_mount_l + fit, engine_mount_w + fit, base_mounting_inset]);
          }
        }
      }
    }

    a = cover_base_offset + fit / 2;
    b = base_d / 2 - (led_mount_rib_w + fit) / 2;
    translate([
      base_d / 2 + (led_mount_rib_w + fit) / 2,
      a,
    ]) {
      rotate([0, 0, 90]) base_led_mount();
    }

    translate([
      b,
      base_d - a,
    ]) {
      rotate([0, 0, 270]) base_led_mount();
    }

    translate([
      a,
      b,
    ]) {
      base_led_mount();
    }

    translate([
      base_d - a,
      b + led_mount_rib_w - fit / 2,
    ]) {
      rotate([0, 0, 180]) base_led_mount();
    }

  }

}

module bed_raiser () {
  difference () {
    union () {
      cube([base_bed_raiser_d, base_bed_raiser_d, base_bed_raiser_h]);
      translate([base_bed_raiser_d / 2, base_bed_raiser_d / 2, base_bed_raiser_h]) {
        cylinder(
          d1 = base_bed_raiser_spacer_d_top,
          d2 = base_bed_raiser_spacer_d_bottom,
          h = base_bed_raiser_spacer_h
        );
      }
    }

    translate([base_bed_raiser_d / 2, base_bed_raiser_d / 2])
       bed_axle();

    translate([0, 0, -(base_h - base_mounting_inset)])
      bed_raiser_bolts();
  }
}

module bed_raiser_mounts () {
  a = standoff_d / 2;
  b = base_bed_raiser_d - a;
  translate([a, a]) children();
  translate([b, a]) children();
  translate([a, b]) children();
  translate([b, b]) children();
}

module bed_raiser_bolts () {
  bed_raiser_mounts()
    bolt(bolt, length = base_bed_raiser_bolt_l, kind = "socket_head");
}

module engine_mount () {
  difference () {
    cube([engine_mount_l, engine_mount_w, engine_mount_h]);

    translate([standoff_d + gearbox_n2 / 2, standoff_d, 0])
      cube([engine_mount_l, engine_mount_w, engine_mount_h - engine_mount_t]);

    translate([
      gearbox_n2 / 2,
      standoff_d + (engine_mount_w - standoff_d) / 2,
      engine_mount_h - engine_mount_t - gearbox_n12_nutcatch_inset
    ])
      rotate([0, 0, 180]) {
        nutcatch_sidecut(bolt, kind = "hexagon_lock");
        translate([0, 0, -gearbox_n12_bolt_l_clearance])
          bolt(bolt, length = gearbox_n12_bolt_l, kind = "socket_head");
      }

    translate([
      (engine_teeth + gearbox_n1 + gearbox_n2) / 2,
      standoff_d + (engine_mount_w - standoff_d) / 2,
    ]) {
      translate([0, 0, engine_mount_h - engine_mount_t]) {
        translate([0, 0, -engine_bolt_inset]) {
          // These bolts start somewhere inside the engine:
          rotate([0, 0, engine_bolt_angle]) engine_bolts();
        }

        // The input shaft:
        cylinder(d = engine_nip_d + loose_fit, h = engine_mount_t);
      }
    }

    translate([0, 0, -(base_h - base_mounting_inset)])
      engine_mount_bolts();
  }
}

module engine_mount_mounts () {
  a = standoff_d / 2;
  b = engine_mount_w - a;
  translate([a, a]) children();
  translate([a, b]) children();
  translate([engine_mount_l - a, a]) children();
}

module engine_mount_bolts () {
  engine_mount_mounts()
    bolt(bolt, length = engine_mount_bolt_l, kind = "socket_head");
}

module engine_bolts () {
  translate([0, -engine_bolt_s / 2]) {
    bolt(engine_bolt, length = engine_bolt_l, kind = "socket_head");
  }

  translate([0, engine_bolt_s / 2]) {
    bolt(engine_bolt, length = engine_bolt_l, kind = "socket_head");
  }
}

module engine_gear () {
  difference () {
    translate([0, 0, gearbox_gear_h / 2]) {
      spur_gear(engine_teeth, z = gearbox_gear_h);
    }

    cylinder(d = engine_shaft_d + press_fit, h = gearbox_gear_h);
  }
}

module gear1 () {
  n1_h = (gearbox_gear_h -fit);
  difference () {
    translate([0, 0, n1_h / 2]) {
      union () {
        spur_gear(gearbox_n1, z = n1_h);
        translate([0, 0, gearbox_gear_h])
          spur_gear(gearbox_n2, z = gearbox_gear_h + fit);
      }
    }

    cylinder(d = gearbox_bearing_od + press_fit, h = gearbox_bearing_h);
    bolt(bolt, length = gearbox_gear_h * 2, kind = "socket_head", countersink = 1, head_diameter_clearance = bolt_shaft_head_clearance);
  }
}
