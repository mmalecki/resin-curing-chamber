include <parameters.scad>;

module cover () {
  linear_extrude (chamber_h + chamber_add_h) {
    d = base_d;
    id = base_d - 2 * cover_t;
    difference () {
      square([d, d]);
      translate([cover_t, cover_t]) square([id, id]);
    }
  }

  translate([base_d / 2, base_d / 2]) {
    difference () {
      cover_mounts() cylinder(d = standoff_d, h = standoff_d);
      cover_bolts();
    }
  }
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
  cover_mounts()
    bolt(bolt, length = cover_bolt_l);
}

cover();
