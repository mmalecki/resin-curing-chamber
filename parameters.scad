use <catchnhole/catchnhole.scad>;
use <lookup-kv/lookup-kv.scad>;
use <next-bolt/next-bolt.scad>;

$fn = 50;

// Standard fits.
press_fit = 0.05;
tight_fit = 0.1;
fit = 0.25;
loose_fit = 0.5;

// The bolt we use by default.
bolt = "M3";
bolt_head_l = bolt_head_length(bolt, kind = "socket_head");

// Design rules:

// Minimal diameter of a standoff ended with a nut. The goal of this design rule
// is to provide adequate material around the nut.
nut_standoff_d = 8.8;

// Minimal height of a standoff ended with a nut. The goal of this design rule
// is to provide adequate material over the nut to provide holding power.
nut_standoff_h = nut_height(bolt) + 0.6;

// Minimal diameter of a bolt conduit standoff.
standoff_d = 7;

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

// Arbirtrary height of the bed rim:
bed_rim_h = 2;
bed_rim_t = 2;

// Base:
// Height of the base plate:
base_h = 5;
// How recessed the mounted parts should be within the base:
base_mounting_inset = 2;
inset_base_h = base_h - base_mounting_inset;
assert(base_mounting_inset < base_h, "base mounting inset cannot be larger than base height");


// Calculated base edge:
base_d = bed_d + cover_bed_clearance + cover_t * 2;

// PCB mount:
// Measured:
pcb_t = 1.75;
pcb_w = 48;
pcb_l = 35;
pcb_h = 15;
pcb_mount_bolt_s = 40.6;

pcb_mount_bolt = "M2";
pcb_mount_standoff_h = 7.5;
pcb_mount_w = pcb_mount_bolt_s + standoff_d;
pcb_mount_bolt_l = (base_h - base_mounting_inset) + pcb_mount_standoff_h + pcb_t;

bed_mount_d = 30;
bed_mount_h = pcb_h + pcb_mount_standoff_h;

// Arbirtrary spacing between the bolts connecting the bed and bed mount.
bed_mount_bed_bolt_s = 30;

bed_mount_bed_bolt = lookup_kv(next_bolt(bolt, bed_h + nut_standoff_h - bolt_head_l), "next");
bed_mount_bed_bolt_l = lookup_kv(bed_mount_bed_bolt, "length");
echo(str("BOM (bed-mount bed bolt): ", bolt, "x", bed_mount_bed_bolt_l));
bed_mount_bed_bolt_length_clearance = lookup_kv(bed_mount_bed_bolt, "length_clearance");
bed_mount_bed_bolt_standoff_h = nut_standoff_h + bed_mount_bed_bolt_length_clearance;

bed_mount_base_bolt = lookup_kv(next_bolt(bolt, bed_mount_h + inset_base_h - bolt_head_l), "previous");
bed_mount_base_bolt_l = lookup_kv(bed_mount_base_bolt, "length");
echo(str("BOM (bed-mount base bolt): ", bolt, "x", bed_mount_base_bolt_l));
bed_mount_base_bolt_countersink = lookup_kv(bed_mount_base_bolt, "countersink");

// How much distance is there between base top and beginning of the chamber
// (height of the under-bed machinery):
chamber_add_h = bed_mount_h + bed_h;

// The width of the LED strip you have:
led_strip_w = 8;
// And its thickness:
led_strip_t = 1.6;
// The bolt we're using for mounting the LED mounts.
led_mount_bolt = "M2";

// The LED clamp is a U-shaped bracket with additional holders at the top.
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
led_mount_rib_nutcatch_offset = 3;
led_mount_rib_channel_offset = 10;
led_mount_rib_channel_d = 2.5;
led_mount_rib_h = chamber_h + chamber_add_h;
led_mount_rib_bracket_l = 10;

// Floor:
floor_h = 5;
floor_bolt_inset = 2.5;

// Cover:
cover_fit = fit;
cover_base_offset = cover_t + cover_fit / 2;
cover_standoff_h = 10;
// Height of the cover:
cover_h = chamber_h + chamber_add_h;
cover_bolt_offset = (base_h - base_mounting_inset) + floor_h;

cover_bolt = lookup_kv(next_bolt(bolt, cover_standoff_h + cover_bolt_offset), "previous");
cover_bolt_l = lookup_kv(cover_bolt, "length");
cover_bolt_countersink = lookup_kv(cover_bolt, "countersink");

echo(str("BOM (cover bolt): ", bolt, "x", cover_bolt_l));

// Dimensions of the endstop:
endstop_bolt_spacing = 7;
endstop_bolt = "M2";
// When the endstop is activated, its total height (including the depressed lever) is this:
endstop_act_h = 11.9; 
// When the endstop is deactivated, its total height (including the returning lever) is this:
endstop_deact_h = 12.7;
endstop_pressed_h = 11.1;
endstop_h = 10.1;
endstop_l = 18.5;
endstop_w = 7.3;
endstop_bolt_offset = 2.1;

endstop_cover_offset_add = 4;
endstop_cover_offset = cover_h + endstop_bolt_offset - endstop_deact_h - endstop_cover_offset_add;
endstop_activator_h = (endstop_deact_h - endstop_pressed_h) * 3/4 + endstop_cover_offset_add;

cover_dc_input_d = 7.6 + fit;
cover_switch_d = 5.85 + fit;
cover_dc_input_bottom_offset = pcb_mount_standoff_h + 25;
cover_dc_input_side_offset = cover_dc_input_d / 2 + cover_t + standoff_d;
cover_switch_side_offset = cover_dc_input_side_offset + cover_dc_input_d + cover_dc_input_d;
cover_led_mount_bolt_clearance = 0.2;

cover_top_h = 5;
