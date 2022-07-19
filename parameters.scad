// Standard fits.
press_fit = 0.05;
tight_fit = 0.1;
fit = 0.25;
loose_fit = 0.5;

bolt = "M3";

gear_h = 4.2;

chamber_h = 100;
bed_d = 134;
bed_h = 4.2;
bed_gear_bolt_l = bed_h + gear_h;
bed_gear_teeth = 100;

bed_gear_spacer_d_top = 20;
bed_gear_spacer_d_bottom = 8.1;
bed_gear_spacer_h = 2;

// The bed motion system:
// The 608 bearing:
bed_bearing_od = 22;
bed_bearing_h = 7;

bed_shaft_bolt = "M8";
// M8 lock nut height:
bed_shaft_nut_h = 9.5;
bed_shaft_bolt_l = bed_h + gear_h + bed_bearing_h + bed_shaft_nut_h;

bed_gear_bolt_spacing = 30;
