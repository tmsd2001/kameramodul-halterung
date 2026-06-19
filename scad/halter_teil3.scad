include <BOSL2/std.scad>;
include <BOSL2/screws.scad>;


//
// Parameters
//
base_width         = 29;
base_depth         = 45;
base_thickness     = 2;

mount_spacing      = 16;
mount_y_position   = 10;

mount_radius       = 3.5;
mount_height       = 4;
mount_z_position   = 1.8;

thread_spec        = "M3";
thread_length      = 15.5;
thread_z_position  = 2;

$fn = 100;                  // High resolution for smooth surfaces


//
// Mounting plate with threaded holes
//
difference() {

    //
    // Positive geometry
    //
    union() {

        // Base plate
        cube(
            [base_width, base_depth, base_thickness],
            center = true
        );

        // Mounting bosses
        for (x = [-mount_spacing / 2, mount_spacing / 2]) {

            translate([x, mount_y_position, mount_z_position]) {

                cylinder(
                    h = mount_height,
                    r = mount_radius,
                    center = true
                );
            }
        }
    }

    //
    // Threaded holes
    //
    for (x = [-mount_spacing / 2, mount_spacing / 2]) {

        translate([x, mount_y_position, thread_z_position]) {

            // BOSL2 uses 'spec' to define thread size.
            // thread=true generates a real threaded hole.
            // anchor=CENTER aligns the feature to the local origin.
            screw_hole(
                spec   = thread_spec,
                l      = thread_length,
                thread = true,
                anchor = CENTER
            );
        }
    }
}
