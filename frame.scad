use <PolyGear/PolyGear.scad>;
use <catchnhole/catchnhole.scad>;
include <parameters.scad>;

module base () {
  difference () {
    cube([base_d, base_d, base_h]);

    translate([base_d / 2, base_d / 2]) {
      bed_axle();

      translate([-base_bed_raiser_d / 2, -base_bed_raiser_d / 2]) {
        bed_raiser_bolts();

        a = standoff_d / 2;
        b = base_bed_raiser_d - a;
        translate([a, a]) nutcatch_parallel(bolt);
        translate([b, a]) nutcatch_parallel(bolt);
        translate([a, b]) nutcatch_parallel(bolt);
        translate([b, b]) nutcatch_parallel(bolt);

        translate([-fit / 2, -fit / 2, base_h - base_mounting_inset]) {
          cube([base_bed_raiser_d + fit, base_bed_raiser_d + fit, base_mounting_inset]);
        }
      }

      rotate([0, 0, 45]) {
        translate([bed_gear_teeth / 2, -(engine_mount_w + standoff_d) / 2]) {
          c = standoff_d / 2;
          d = engine_mount_w - c;
          translate([c, c]) nutcatch_parallel(bolt);
          translate([c, d]) nutcatch_parallel(bolt);
          translate([engine_mount_l - c, c]) nutcatch_parallel(bolt);

          translate([-fit / 2, -fit / 2, base_h - base_mounting_inset]) {
            cube([engine_mount_l + fit, engine_mount_w + fit, base_mounting_inset]);
          }
        }
      }
    }
  }
}

module bed_raiser () {
  difference () {
    cube([base_bed_raiser_d, base_bed_raiser_d, base_bed_raiser_h]);

    translate([0, 0, -(base_h - base_mounting_inset)]) {
      bed_raiser_bolts();

      translate([base_bed_raiser_d / 2, base_bed_raiser_d / 2])
         bed_axle();
    }
  }
}

module bed_axle () {
  translate([0, 0, (base_h + base_bed_raiser_h) - bed_bearing_h - base_mounting_inset]) {
    cylinder(d = bed_bearing_od + press_fit, h = bed_bearing_h);
  }

  nutcatch_parallel(bed_shaft_bolt, kind = "hexagon_lock");
  bolt(bed_shaft_bolt, length = bed_shaft_bolt_l, kind = "socket_head");
}

module bed_raiser_bolts () {
  a = standoff_d / 2;
  b = base_bed_raiser_d - a;
  translate([a, a]) bolt(bolt, length = base_bed_raiser_bolt_l);
  translate([b, a]) bolt(bolt, length = base_bed_raiser_bolt_l);
  translate([a, b]) bolt(bolt, length = base_bed_raiser_bolt_l);
  translate([b, b]) bolt(bolt, length = base_bed_raiser_bolt_l);
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

module engine_mount_bolts () {
  a = standoff_d / 2;
  b = engine_mount_w - a;
  translate([a, a]) bolt(bolt, length = engine_mount_bolt_l, kind = "socket_head");
  translate([a, b]) bolt(bolt, length = engine_mount_bolt_l, kind = "socket_head");
  translate([engine_mount_l - a, a]) bolt(bolt, length = engine_mount_bolt_l, kind = "socket_head");
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
