use <catchnhole/catchnhole.scad>;

$fn = 50;

// Standard fits.
press_fit = 0.05;
tight_fit = 0.1;
fit = 0.25;
loose_fit = 0.5;

// The bolt we use by default.
bolt = "M3";
bolt_head_l = bolt_head_length(bolt, kind = "socket_head");
standoff_d = 7;

chamber_h = 100;
bed_d = 134;
bed_h = 4.2;
bed_gear_h = 4.2 + fit;
bed_gear_bolt_l = bed_h + bed_gear_h;
bed_gear_teeth = 100;

bed_gear_bolt_spacing = 30;

// Base
base_h = 5;
base_bed_clearance = 5.75;
base_d = bed_d + base_bed_clearance;
base_bed_raiser_h = 20.5;
base_bed_raiser_d = 30;
base_mounting_inset = 2.5;
base_bed_raiser_bolt_l = base_bed_raiser_h + base_h - base_mounting_inset;

// The bed motion system:
// The 608 bearing:
bed_bearing_od = 22;
bed_bearing_h = 7;

bed_shaft_bolt = "M8";
// M8 lock nut height:
bed_shaft_nut_h = nut_data()[bed_shaft_bolt]["hexagon_lock"].thickness;


// Engine mount
engine_h = 18.6;
engine_bolt = "M2";
engine_bolt_s = 10;
engine_bolt_angle = 30;
engine_bolt_inset = 1.5;
engine_nip_d = 4.7;
engine_nip_h = 1.5;
engine_shaft_l = 9.7;
engine_shaft_d = 1.5;

engine_od = 15.5;
engine_w = 12;


engine_teeth = 10;
gearbox_gear_h = 4.2;
gearbox_n1 = 32;
gearbox_n2 = 13;

gearbox_bearing_od = 9;
gearbox_bearing_h = 5;

engine_bolt_l = 4;
engine_bolt_head_l = bolt_head_length(engine_bolt, "socket_head");
engine_mount_l = engine_teeth + gearbox_n1 / 2 + gearbox_n2 / 2;
engine_mount_t = engine_bolt_l - engine_bolt_inset + engine_bolt_head_l;
engine_mount_w = 25;
engine_h_fit = 3;
engine_mount_h = engine_h +  engine_h_fit + engine_mount_t;
engine_mount_bolt_l = engine_mount_h + (base_h - base_mounting_inset) - bolt_head_l;

bed_gear_spacer_d_top = 20;
bed_gear_spacer_d_bottom = 8.1;
bed_gear_spacer_h = (engine_mount_h - base_bed_raiser_h) + bed_gear_h;

bed_shaft_bolt_l = bed_h + bed_gear_h + base_bed_raiser_h + base_h - base_mounting_inset + bed_gear_spacer_h - bolt_head_length(bed_shaft_bolt, "socket_head");
gearbox_n12_nutcatch_inset = 2.5;
gearbox_n12_bolt_l_clearance = 10;
gearbox_n12_bolt_l = 2 * gearbox_gear_h + engine_mount_t + gearbox_n12_nutcatch_inset - bolt_head_l + gearbox_n12_bolt_l_clearance;
