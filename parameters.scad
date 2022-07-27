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
// Additional clearance for heads of bolts serving as shafts:
bolt_shaft_head_clearance = 1;

// Main sizing parameters:
// Chamber height (maximum height of a fitting object):
chamber_h = 100;
// Bed diameter:
bed_d = 134;
// Cover thickness:
cover_t = 2;
// How much side clearance the bed should have from cover:
cover_bed_clearance = 8;

// Height of the bed plater:
bed_h = 4.2;
// Height of the bed gear (`+ fit` to raise the bed platter above the reduction gear):
bed_gear_h = 4.2 + fit;
// How many teeth the bed gear should have.
bed_gear_teeth = 100;
assert(bed_gear_teeth < bed_d, "bed gear will not fit the chamber");

// Arbirtrary spacing between the bolts holding the bed and bed gear together:
bed_gear_bolt_s = 30; 

// Calculated length of the bolt holding the bed and bed gear together:
bed_gear_bolt_l = bed_h + bed_gear_h;

// Base:
// Height of the base plate:
base_h = 5;
// How recessed the mounted parts should be within the base:
base_mounting_inset = 2;
assert(base_mounting_inset < base_h, "base mounting inset cannot be larger than base height");


// Calculated base edge:
base_d = bed_d + cover_bed_clearance + cover_t * 2;

// Cover:
cover_fit = fit;
cover_base_offset = cover_t + cover_fit / 2;
cover_standoff_h = 7.5;
// Height of the cover:
cover_h = chamber_h + base_mounting_inset;
cover_bolt_l = cover_standoff_h + (2 * base_h - base_mounting_inset);

// Bed raiser:
base_bed_raiser_h = 20.5;
base_bed_raiser_d = 30;
// Calculated length of the bolts holding the bed raiser and base together:
base_bed_raiser_bolt_l = base_bed_raiser_h + base_h - base_mounting_inset;

// Diameters of the bed gear spacers, picked arbirtrarily:
base_bed_raiser_spacer_d_top = 20;
base_bed_raiser_spacer_d_bottom = 8.1;

// The bed motion system:
// The 608 bearing:
bed_bearing_od = 22;
bed_bearing_h = 7;

bed_shaft_bolt = "M8";

bed_gear_bearing_housing_d = 26;
assert(bed_gear_bearing_housing_d > bed_bearing_od, "bed bearing housing must be larger than bearing");
assert(bed_gear_bearing_housing_d < bed_gear_bolt_s, "bed bearing housing must be smaller than bed gear bolt spacing");

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
base_bed_raiser_spacer_h = (engine_mount_h - base_bed_raiser_h - bed_bearing_h) + bed_gear_h;

// Calculated motion system bolt lengths:
bed_shaft_bolt_l = bed_h + bed_gear_h + base_bed_raiser_h + base_bed_raiser_spacer_h + bed_bearing_h - bolt_head_length(bed_shaft_bolt, "socket_head");
gearbox_n12_bolt_l = 2 * gearbox_gear_h + engine_mount_t + gearbox_n12_nutcatch_inset - bolt_head_l + gearbox_n12_bolt_l_clearance;

// How much distance is there between base top and beginning of the chamber
// (height of the under-bed machinery):
chamber_add_h = base_bed_raiser_h - base_mounting_inset + base_bed_raiser_spacer_h + bed_bearing_h;

led_strip_w = 8;
led_strip_t = 1.6;
led_mount_bolt = "M2";
led_mount_clamp_t = 1.2;
led_mount_clamp_h = 8;
led_mount_clamp_back_t = 2;
led_mount_clamp_back_w = led_strip_w + fit;
led_mount_clamp_front_w = 0.625 * (led_mount_clamp_back_w + 2 * led_mount_clamp_t);
led_mount_clamp_bolt_l = 4;

led_mount_pad_w = 8;
led_mount_pad_h = 6;
led_mount_pad_t = 2;
led_mount_rib_pad_channel_t = led_mount_pad_t;

// LED mount rib (the vertical piece holding LED clamps):
led_mount_rib_w = 14;
led_mount_rib_t = 3;
led_mount_rib_channel_offset = 10;
led_mount_rib_channel_d = 2.5;
led_mount_rib_h = chamber_h + chamber_add_h;
led_mount_rib_bracket_l = 10;

// PCB mount:
// Measured:
pcb_t = 1.75;
pcb_w = 48;
pcb_l = 35;
pcb_mount_bolt_s = 40.6;

pcb_mount_bolt = "M2";
pcb_mount_standoff_h = 7.5;
pcb_mount_w = pcb_mount_bolt_s + standoff_d;
pcb_mount_bolt_l = (base_h - base_mounting_inset) + pcb_mount_standoff_h + pcb_t;
