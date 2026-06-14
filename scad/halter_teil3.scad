include <BOSL2/std.scad>
include <BOSL2/screws.scad>;

$fn = 100;    // High resolution for smooth surfaces


//
// Parameters
//
base_width         = 26;
base_depth         = 26;
base_thickness     = 2;

mount_spacing      = 16;
mount_radius       = 3.5;
mount_height       = 4;
mount_z_position   = 1.8;

thread_spec        = "M3";
thread_depth       = 15.5;
thread_z_position  = 2;


//
// Complete part
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

        // Right mounting boss
        translate([mount_spacing / 2, 0, mount_z_position]) {
            cylinder(
                h = mount_height,
                r = mount_radius,
                center = true
            );
        }

        // Left mounting boss
        translate([-mount_spacing / 2, 0, mount_z_position]) {
            cylinder(
                h = mount_height,
                r = mount_radius,
                center = true
            );
        }
    }

    //
    // Right threaded hole
    //
    translate([mount_spacing / 2, 0, thread_z_position]) {

        // BOSL2 uses 'spec' to define thread size.
        // thread=true generates a real threaded hole.
        // anchor=CENTER aligns the feature to the local origin.
        screw_hole(
            spec   = thread_spec,
            l      = thread_depth,
            thread = true,
            anchor = CENTER
        );
    }

    //
    // Left threaded hole
    //
    translate([-mount_spacing / 2, 0, thread_z_position]) {

        screw_hole(
            spec   = thread_spec,
            l      = thread_depth,
            thread = true,
            anchor = CENTER
        );
    }
}