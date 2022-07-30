use <bed.scad>;
use <base.scad>;
use <floor.scad>;
use <cover.scad>;
use <led-mount.scad>;
use <pcb-mount.scad>;
use <PolyGear/PolyGear.scad>;
include <parameters.scad>;

explode = false;

e = explode ? 40 : 0;
slack = 0;

floor_ = true;
base = true;
cover = true;
bed = false;
bed_gear = true;
bed_raiser = true;
engine_mount = true;
engine_mockup = true;
gearbox = true;
pcb_mount = true;

echo(str("bed gear bolt: ", bed_gear_bolt_l));
echo(str("bed shaft bolt ", bed_shaft_bolt_l));
echo(str("base bed raiser bolt ", base_bed_raiser_bolt_l));
echo(str("gearbox n12 bolt: ", gearbox_n12_bolt_l));
echo(str("engine mount bolt: ", engine_mount_bolt_l));

module engine_mockup () {
  linear_extrude (engine_h) {
    engine_front_mockup();
  }
  translate([0, 0, engine_h]) {
    cylinder(d = engine_nip_d, engine_nip_h);
    translate([0, 0, engine_nip_h]) cylinder(d = engine_shaft_d, h = engine_shaft_l);
  }
}

module engine_front_mockup () {
  difference () {
    intersection () {
      translate([-engine_od / 2, -engine_w / 2])
        square([engine_od, engine_w]);
      circle(d = engine_od);
    }

    rotate([0, 0, engine_bolt_angle]) {
      translate([engine_bolt_s / 2, 0]) circle(d = 2);
      translate([-engine_bolt_s / 2, 0]) circle(d = 2);
    }
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
      if (bed_raiser) {
        translate([-base_bed_raiser_d / 2, -base_bed_raiser_d / 2])
          bed_raiser();
      }

      translate([0, 0, base_bed_raiser_h + base_bed_raiser_spacer_h + e + slack]) bed_mockup();
    }


    rotate([0, 0, 45]) {
      translate([(bed_gear_teeth) / 2, -engine_mount_w / 2 - standoff_d / 2, -base_mounting_inset + slack]) {
        if (engine_mount) {
          engine_mount();

          if (engine_mockup) {
            translate([
              (engine_teeth + gearbox_n1 + gearbox_n2) / 2,
              (engine_mount_w + standoff_d) / 2,
              engine_mount_h - engine_mount_t - engine_h - slack
            ]) {
              rotate([0, 0, 90]) engine_mockup();
            }
          }
        }

        if (gearbox) {
          translate([gearbox_n2 / 2, engine_mount_w / 2, engine_mount_h + e + slack])
            gearbox_mockup();
        }
      }
    }
  }

  translate([
    cover_base_offset,
    base_d / 2 - led_mount_rib_w / 2,
    base_h - base_mounting_inset + slack + e
  ]) {
    led_mount_rib();
  }

  translate([
    cover_base_offset + fit / 2 + standoff_d,
    base_d - standoff_d - cover_base_offset - fit / 2,
    base_h - base_mounting_inset
  ]) {
    if (pcb_mount) pcb_mount();
  }

  if (cover) {
    translate([0, 0, base_h - base_mounting_inset + slack + 5 * e]) cover();
  }
}

module bed_mockup () {
  if (bed_gear) bed_gear();
  translate([0, 0, bed_gear_h + bed_bearing_h +  e + slack]) {
    if (bed) bed();
  }
}

module gearbox_mockup () {
  translate([0, standoff_d / 2]) {
    gear1();

    translate([(engine_teeth + gearbox_n1) / 2, 0]) {
      engine_gear();
    }
  }
}

mockup();
