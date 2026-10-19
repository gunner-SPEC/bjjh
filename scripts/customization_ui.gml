// scripts/customization_ui.gml
// Simple customization UI: choose bike, paint color, and outfit
// Usage: place obj_custom_ui in the room. Add Draw GUI and Mouse Left Pressed events as described.

// Draw GUI event (place into Draw GUI of obj_custom_ui)
var base_x = 16;
var base_y = display_get_height() - 160;
var w = 260;
var h = 32;

draw_set_color(make_color_rgb(18,18,18));
draw_rectangle(base_x-8, base_y-8, base_x + w + 8, base_y + 200, true);
draw_set_color(c_white);
draw_text(base_x, base_y, "Customization: Bike / Color / Outfit");

// Bike list
var yy = base_y + 28;
for (var i = 0; i < array_length(bike_list); i++) {
    var b = bike_list[i];
    draw_set_color(make_color_rgb(40,40,40));
    draw_rectangle(base_x, yy + i*(h+6), base_x + w - 8, yy + i*(h+6) + h, true);
    draw_set_color(c_white);
    draw_text(base_x + 8, yy + i*(h+6) + 8, b.name);
}

// Color swatches
var colors = [c_red, c_orange, c_yellow, c_green, c_blue, c_purple, c_white];
var col_x = base_x + 8;
var col_y = yy + array_length(bike_list)*(h+6) + 12;
for (var i = 0; i < array_length(colors); i++) {
    draw_set_color(colors[i]);
    draw_rectangle(col_x + i*36, col_y, col_x + i*36 + 28, col_y + 28, true);
}

// Outfit placeholders
draw_set_color(c_white);
draw_text(base_x, col_y + 48, "Outfits: 0 (default), 1, 2");

// Mouse Left Pressed event (paste into obj_custom_ui Mouse Left Pressed event)
/*
var mx = mouse_x; var my = mouse_y;
// Bike selection
var bx = base_x; var by = yy; var bh = h; var bw = w - 8;
for (var i = 0; i < array_length(bike_list); i++) {
    var rect_y1 = by + i*(bh+6);
    var rect_y2 = rect_y1 + bh;
    if (mx > bx && mx < bx + bw && my > rect_y1 && my < rect_y2) {
        // select bike i
        obj_bike.active_bike = bike_list[i];
        obj_bike.apply_upgrades();
        break;
    }
}

// Color selection
var col_x = base_x + 8; var col_y = yy + array_length(bike_list)*(h+6) + 12;
for (var i = 0; i < array_length(colors); i++) {
    var rx1 = col_x + i*36; var ry1 = col_y; var rx2 = rx1 + 28; var ry2 = ry1 + 28;
    if (mx > rx1 && mx < rx2 && my > ry1 && my < ry2) {
        obj_bike.paint_color = colors[i];
        break;
    }
}

// Outfit selection (click text area to toggle outfits)
var outfit_area_x1 = base_x; var outfit_area_y1 = col_y + 48; var outfit_area_x2 = base_x + 200; var outfit_area_y2 = outfit_area_y1 + 24;
if (mx > outfit_area_x1 && mx < outfit_area_x2 && my > outfit_area_y1 && my < outfit_area_y2) {
    obj_bike.outfit_id = (obj_bike.outfit_id + 1) mod 3;
}
*/
