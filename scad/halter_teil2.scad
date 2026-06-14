//
// Parameters
//
inner_radius      = 40;
outer_radius      = 44;

cylinder_height   = 40;
wall_thickness    = 3;
bottom_thickness  = 3;

missing_angle     = 30;   // Angular section to remove
start_angle       = 75;   // Starting angle of the opening

$fn = 100;                // High resolution for smooth circular surfaces


//
// Bottom plate with cutouts
//
difference() {

    // Solid bottom plate
    cylinder(
        h = bottom_thickness,
        r = inner_radius + wall_thickness + 1
    );

    // First rectangular cutout
    translate([8, -5, 0]) {
        cube([7, 30, 15], center = true);
    }

    // Second rectangular cutout
    translate([-8, -5, 0]) {
        cube([7, 30, 15], center = true);
    }
}


//
// Hollow cylinder with side opening
//
difference() {

    //
    // Main hollow cylinder
    //
    difference() {

        // Outer wall
        cylinder(
            h = cylinder_height,
            r = outer_radius
        );

        // Inner cavity
        translate([0, 0, -1]) {
            cylinder(
                h = cylinder_height + 2,
                r = inner_radius
            );
        }
    }

    //
    // Remove a pie-shaped section
    //
    translate([0, 0, -1]) {
        rotate([0, 0, start_angle]) {

            linear_extrude(height = cylinder_height + 2) {
                pie_slice_2d(
                    r = outer_radius + 5,
                    angle = missing_angle
                );
            }
        }
    }
}


//
// 2D pie-slice module
// Origin located at [0, 0]
//
module pie_slice_2d(r, angle) {

    intersection() {

        circle(r = r);

        polygon(
            points = concat(
                [[0, 0]],
                [
                    for (a = [0 : 5 : angle])
                        [r * 2 * cos(a), r * 2 * sin(a)]
                ],
                [[r * 2 * cos(angle), r * 2 * sin(angle)]]
            )
        );
    }
}