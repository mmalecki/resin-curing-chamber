use <catchnhole/catchnhole.scad>;
include <parameters.scad>;

module pcb_mount_bolts () {
  pcb_mount_mounts()
    bolt(pcb_mount_bolt, length = pcb_mount_bolt_l, kind = "socket_head");
}

module pcb_mount_mounts () {
  translate([-pcb_mount_bolt_s / 2, 0]) children();
  translate([pcb_mount_bolt_s / 2, 0]) children();
}

module pcb_mount () {
  difference () {
    cube([pcb_mount_w, standoff_d, pcb_mount_standoff_h]);
    translate([pcb_mount_w / 2, standoff_d / 2]) pcb_mount_bolts();
  }
}

pcb_mount();
