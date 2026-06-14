//
// Parameters
//

// Tapered adapter section
bottom_inner_radius = 65;
top_inner_radius    = 36;
cone_height         = 3;

// Cylindrical section
inner_radius        = 36;
outer_radius        = 39.7;
cylinder_height     = 40;

// Wall thickness
wall_thickness      = 2;

// Opening
missing_angle       = 30;   // Angular section to remove

$fn = 100;                  // High resolution for smooth curves


//
// Hollow tapered section
//
difference() {

    // Outer cone
    cylinder(
        h = cone_height,
        r = bottom_inner_radius + wall_thickness
    );

    // Inner cavity
    translate([0, 0, -1]) {
        cylinder(
            h = cone_height + 2,
            r = top_inner_radius
        );
    }
}


//
// Hollow cylinder with opening
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
    // Remove pie-shaped section
    //
    translate([0, 0, -1]) {

        linear_extrude(height = cylinder_height + 2) {

            pie_slice_2d(
                r = outer_radius + 5,
                angle = missing_angle
            );
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
