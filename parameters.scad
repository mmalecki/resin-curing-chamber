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

// Main sizing parameters:
// Chamber height:
chamber_h = 100;
// Bed diameter:
bed_d = 134;

// Height of the bed plater:
bed_h = 4.2;
// Height of the bed gear (`+ fit` to raise the bed platter above the reduction gear):
bed_gear_h = 4.2 + fit;
// Diameters of the bed gear spacers, picked arbirtrarily:
bed_gear_spacer_d_top = 20;
bed_gear_spacer_d_bottom = 8.1;
// How many teeth the bed gear should have.
bed_gear_teeth = 100;
assert(bed_gear_teeth < bed_d, "bed gear will not fit the chamber");

// Arbirtrary spacing between the bolts holding the bed and bed gear together:
bed_gear_bolt_spacing = 30; 

// Calculated length of the bolt holding the bed and bed gear together:
bed_gear_bolt_l = bed_h + bed_gear_h;

// Base:
// Height of the base plate:
base_h = 5;
// How much clearance the side clearance the bed should have from base:
base_bed_clearance = 5.75;
// How recessed the mounted parts should be within the base:
base_mounting_inset = 2.5;
assert(base_mounting_inset < base_h, "base mounting inset cannot be larger than base height");

// Calculated base edge:
base_d = bed_d + base_bed_clearance;

// Bed raiser:
base_bed_raiser_h = 20.5;
base_bed_raiser_d = 30;
// Calculated length of the bolts holding the bed raiser and base together:
base_bed_raiser_bolt_l = base_bed_raiser_h + base_h - base_mounting_inset;

// The bed motion system:
// The 608 bearing:
bed_bearing_od = 22;
bed_bearing_h = 7;

bed_shaft_bolt = "M8";

// Engine mount (engine + gearbox):
// Measured/speced details of the engine:
// Body length:
engine_h = 18.6;
// Mounting bolts:
engine_bolt = "M2";
// Bolt length you have around, engine mount thickness is calculated based on this.
engine_bolt_l = 4;
engine_bolt_head_l = bolt_head_length(engine_bolt, "socket_head");
engine_bolt_s = 10;
engine_bolt_angle = 30;
// How deep the bolts can go into the engine:
engine_bolt_inset = 1.5;
engine_nip_d = 4.7;
engine_nip_h = 1.5;
engine_shaft_l = 9.7;
engine_shaft_d = 1.5;

// Only used for engine mockup:
engine_od = 15.5;
engine_w = 12;

// The reduction gearbox for high-RPM DC motors:
engine_teeth = 10;
gearbox_gear_h = 4.2;
gearbox_n1 = 32;
gearbox_n2 = 13;

// How deep inside the engine mount the nutcatch for the n12 gear should be.
gearbox_n12_nutcatch_inset = 2.5;
// How deep down we allow the accompanying bolt to go (arbirtrary value, depending
// on what bolts you have laying around).
gearbox_n12_bolt_l_clearance = 10;

// The 603 bearing:
gearbox_bearing_od = 9;
gearbox_bearing_h = 5;

// The actual engine mount:
// Calculate the length base on the gearbox:
engine_mount_l = engine_teeth + gearbox_n1 / 2 + gearbox_n2 / 2;
// And thickness based on the M2 bolt for mounting the engine.
engine_mount_t = engine_bolt_l - engine_bolt_inset + engine_bolt_head_l;
engine_mount_w = 25;
// Vertical fit between the engine and base.
engine_h_fit = 3;
// Calculated total engine mount height.
engine_mount_h = engine_h +  engine_h_fit + engine_mount_t;
// And the bolt for mounting it to the base:
engine_mount_bolt_l = engine_mount_h + (base_h - base_mounting_inset) - bolt_head_l;

// Calculated height of the bed gear spacer (lines up the bed gear with the engine
// mount & gear).
bed_gear_spacer_h = (engine_mount_h - base_bed_raiser_h) + bed_gear_h;

// Calculated motion system bolt lengths:
bed_shaft_bolt_l = bed_h + bed_gear_h + base_bed_raiser_h + base_h - base_mounting_inset + bed_gear_spacer_h - bolt_head_length(bed_shaft_bolt, "socket_head");
gearbox_n12_bolt_l = 2 * gearbox_gear_h + engine_mount_t + gearbox_n12_nutcatch_inset - bolt_head_l + gearbox_n12_bolt_l_clearance;
