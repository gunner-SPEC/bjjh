// scripts/obj_ramp.gml
// Ramp object - no complex physics. When bike overlaps ramp area while moving, reduce z target to simulate launch

// Collision Event with obj_bike (paste into obj_ramp Collision with obj_bike)
/*
// apply a boost to vertical velocity for launch
if (other.vz >= 0) {
    other.vz = -abs(config_jump_strength * 1.1);
    other.grounded = false;
}
*/

// Draw Event (shows ramp sprite or simple triangle placeholder)
if (sprite_exists(spr_ramp)) {
    draw_sprite(spr_ramp, 0, x, y);
} else {
    // draw a simple ramp triangle
    draw_set_color(make_color_rgb(120,100,60));
    draw_triangle(x-32, y+16, x+32, y+16, x+32, y-16, false);
    draw_set_color(c_white);
}
