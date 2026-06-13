// =================================================================
// OpenSCAD Modell: Kameramodul Gehäuse
// Basierend auf den korrigierten technischen Zeichnungen und Herstellerangaben
// =================================================================

$fn = 60; // Erhöht die Segmentanzahl für perfekt runde Kreise und Zylinder

// --- PARAMETER (Alle Maße in mm) ---

// Hauptabmessungen laut Hersteller & Skizzenabgleich
gesamt_breite      = 29.0;  // Herstellerangabe
gehaeuse_hoehe     = 40.5;  // Eigene Messung des Hauptkörpers
stufe_hoehe        = 5.7;   // Berechnet aus Herstellertotal (46.2mm) - Hauptkörper (40.5mm)
stufe_breite       = 12.4;  // Breite des unteren Kabelhalses
gehaeuse_dicke     = 12.35; // Gehäusedicke ohne Linse
gesamt_dicke       = 13.15; // Gesamtdicke inklusive Linse
linsen_ueberstand  = gesamt_dicke - gehaeuse_dicke; // 0.8 mm Überstand über Gehäusefront

// Positionierung der optischen Achse (Letzte Korrekturauflage)
linsen_y_von_oben  = 8.0;   // Abstand von Gehäuseoberkante bis Linsenmitte
linsen_y_pos       = gehaeuse_hoehe - linsen_y_von_oben; // Absolute Y-Position im Koordinatensystem

// Abmessungen der Aussparung (Kapselform / Frontglas)
recess_breite      = 24.0;  // Gesamte horizontale Ausdehnung der Aussparung
recess_hoehe       = 11.2;  // Vertikale Höhe der Aussparung
recess_tiefe       = 1.5;   // *HINWEIS: Angenommener Wert, da Tiefe nicht explizit bemaßt*

// Details der Kamera-Optik & LEDs
kamera_dm_aussen   = 9.0;   // Äußerer Ring der Kameralinse
kamera_dm_innen    = 5.0;   // Innerer Linsendurchmesser
led_abstand_x      = 7.5;   // Pitch von Gehäusemitte zu den LED-Mittelpunkten (links/rechts je 7.5mm)
led_durchmesser    = 3.5;   // *HINWEIS: Sinnvoller Richtwert für LEDs, da Durchmesser nicht explizit bemaßt*

// Geometrie-Optionen
eckradius_gehaeuse = 4.0;   // Rundung der vier Hauptgehäuseecken


// --- GEOMTRIE-MODULE ---

module gehaeuse_2d_profil() {
    // Hauptkörper des Gehäuses (wird im Ursprung auf Y=0 aufgesetzt)
    translate([-gesamt_breite/2 + eckradius_gehaeuse, eckradius_gehaeuse])
        minkowski() {
            square([gesamt_breite - 2*eckradius_gehaeuse, gehaeuse_hoehe - 2*eckradius_gehaeuse]);
            circle(r=eckradius_gehaeuse);
        }
    
    // Untere Stufe (Kabelhals)
    translate([-stufe_breite/2, -stufe_hoehe])
        square([stufe_breite, stufe_hoehe + 0.1]); // 0.1mm Überlappung verhindert Non-Manifold-Fehler
}

module linsen_aussparung_2d() {
    // Berechnet den Abstand der beiden Kreiselemente für die Kapselform
    recess_zentrum_abstand = (recess_breite - recess_hoehe) / 2;
    translate([0, linsen_y_pos]) {
        hull() {
            translate([-recess_zentrum_abstand, 0]) circle(d=recess_hoehe);
            translate([recess_zentrum_abstand, 0]) circle(d=recess_hoehe);
        }
    }
}


// --- 3D-AUFBAU (CSG-Operationen) ---

difference() {
    // 1. Hauptextrusion des Gehäusekörpers
    linear_extrude(height = gehaeuse_dicke) {
        gehaeuse_2d_profil();
    }
    
    // 2. Abzug der vorderen Kapsel-Aussparung für die Glasfront
    translate([0, 0, gehaeuse_dicke - recess_tiefe])
        linear_extrude(height = recess_tiefe + 0.1)
            linsen_aussparung_2d();
}

// 3. Aufbau der hervorstehenden Kameralinse
translate([0, linsen_y_pos, gehaeuse_dicke - recess_tiefe]) {
    // Äußerer Linsenzylinder
    cylinder(d = kamera_dm_aussen, h = recess_tiefe + linsen_ueberstand);
    
    // Innere optische Linse (wird minimal höher gesetzt zur visuellen Trennung)
    translate([0, 0, recess_tiefe + linsen_ueberstand])
        cylinder(d = kamera_dm_innen, h = 0.2);
}

// 4. Andeutung der LEDs innerhalb der Aussparung
translate([0, linsen_y_pos, gehaeuse_dicke - recess_tiefe]) {
    // Linke LED
    translate([-led_abstand_x, 0, 0])
        cylinder(d = led_durchmesser, h = 0.4);
    
    // Rechte LED
    translate([led_abstand_x, 0, 0])
        cylinder(d = led_durchmesser, h = 0.4);
}
