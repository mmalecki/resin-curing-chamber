# Build manual

## What you need

This is as hand-wavy as it gets, because nearly every single part of this
project is configurable to fit whatever parts you have on hand, and the quantities
of some parts depend on the build size.
Unless you've changed some internal parameters (in `parameters.scad` instead
of `parameters-sizing.scad`), the bolt lengths should stay the same.


| **Item**                                             | **Quantity**     |
|:---------------------------------------------------|---------------:|
| UV LED strip                                       | As desired     |
| Reflective tape                                    | As needed      |
| DC power supply (compatible with the UV LED strip) |          1     |
| Panel mount DC power jack                          |          1     |
| Panel mount toggle switch                          |          1     |
| Prototyping PCB                                    |          1     |
| Mechanical endstop switch                          |          1     |
| Heat shrink sleeve                                 | As needed      |
| M3 nuts                                            |         12     |
| M2 nuts                                            | 10 + as needed |
| M3x6 bolt                                          |          2     |
| M3x16 bolt                                         |          4     |
| M3x22 bolt                                         |          4     |
| **Printed parts**                                      |                |
| Base                                               |          1     |
| Bed                                                |          1     |
| Bed mount                                          |          1     |
| Cover                                              |          1     |
| Cover top                                          |          1     |
| Floor                                              |          1     |
| PCB mount                                          |          1     |
| LED mount                                          |          4     |
| LED mount clamp & pad                              | As needed      |


## Configuring the build
First, you need pick the sizing parameters for your build: chamber height and
bed diameter, as well as LED strip width and thickness.
Open [`parameters-sizing.scad`](../parameters-sizing.scad) and edit the relevant variables.

## Building the STLs
After you've edited `parameters-sizing.scad`, you can build the STL files by running
`./scripts/build`. This will create STL files in the `output` directory.

If you've changed any internal parameters, here's where to look for new bolt
lengths. These will be output by OpenSCAD, albeit repeated a couple times as
the output renders.

## Printing
* **Material**: Any material for everything but the cover and LED mount parts.
  Use PETG for those - the chamber may get toasty inside.
* **Layer height**: At most 0.2 mm layer height (recommend using [variable layer height](https://help.prusa3d.com/article/variable-layer-height-function_1750)
  with adaptive layer height, which will use different layer height for the
  base and the hinges).
* **Infill**: 15%
* **Perimeters**: 3

## Putting it together

### Electronics
You'll need to connect the toggle switch and the mechanical endstop switch
in series with the LED strip.

### Case
1. Insert the 4 M3 nuts into the nutcaches in the bottom of the floor.
2. Insert the 10 M2 and 4 M3 nuts into the nutcatches in the base.
3. Mount the PCB on the PCB mount, to the base. Leave the switches and LED strip
unmounted for the time being.
4. Mount the LED mounts to the base.
5. Insert the 2 M3 nuts into the nutcatches in the bed mount.
6. Mount the bed mount to the base. Don't mount the bed yet, it's going to get
in the way of mounting the LED strips.
7. Insert nuts into nutcatches on the LED clamp pads. Insert the pads into the 
channel on the back of the LED mount, and the clamps on the front. Join them
together through the hole in the LED mount with a M2 bolt. As you tighten the
bolt, the pad should rotate in place.
8. Start wrapping the LED strip around the chamber by inserting the strip into
the clamps.
9. Mount the cover with the 4 M3 bolts, mount the toggle swich (through panel)
and endstop (with M2 bolts) to it.
10. Put the cover top on top, and you're done.
