// Parameter
r_in_unten = 65;
r_in_oben = 36;
h_kegel = 3;
h_zyl = 40;
wand = 2;
winkel = 15;
anzahl = 4;

r_innen = 36;
r_aussen = 39.7;
h_zylinder = 40;
fehlender_winkel = 30; // Das Stück, das weggeschnitten wird

$fn = 100;

// 1. Kegelstumpf (Hohl, Innenmaße bleiben frei)
difference() {
    cylinder(h = h_kegel, r = r_in_unten + wand);
    translate([0, 0, -1])
       cylinder(h = h_kegel + 2, r = r_in_oben);
}

difference() {
    // 1. Der hohle Hauptzylinder
    difference() {
        cylinder(h = h_zylinder, r = r_aussen);
        translate([0, 0, -1]) 
            cylinder(h = h_zylinder + 2, r = r_innen);
    }

    // 2. Das 30°-Tortenstück zum Wegschneiden
    translate([0, 0, -1]) {
        linear_extrude(height = h_zylinder + 2) {
            tortenstueck_2d(r = r_aussen + 5, winkel = fehlender_winkel);
        }
    }
}

module tortenstueck_2d(r, winkel) {
    intersection() {
        circle(r = r);
        polygon(points = concat(
            [[0, 0]],
            [for (a = [0 : 5 : winkel]) [r * 2 * cos(a), r * 2 * sin(a)]], 
            [[r * 2 * cos(winkel), r * 2 * sin(winkel)]]
        ));
    }
}
