// scripts/obj_ui.gml
// Create event (empty placeholder if needed)
// Step event not required; draw HUD in Draw GUI event

// Draw GUI event code (place in obj_ui Draw GUI)
// Display speed and state
var ui_x = 16;
var ui_y = 16;
var speed_kmh = round(obj_bike.speed * 3.6); // approximate conversion

draw_set_color(c_black);
draw_rectangle(ui_x-6, ui_y-6, ui_x+150, ui_y+60, true);
draw_set_color(c_white);
var txt = "Speed: " + string(speed_kmh) + " km/h\nBike: " + obj_bike.active_bike.name + "\nAir: " + string(obj_bike.is_airborne);
draw_text(ui_x, ui_y, txt);
