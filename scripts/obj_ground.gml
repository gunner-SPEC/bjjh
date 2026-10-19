// scripts/obj_ground.gml
// Simple ground object that draws a repeating tile or solid ground area
// Draw event: draws a tiled ground or plain rectangle if spr_ground missing

// Draw event code (place in obj_ground Draw)
if (sprite_exists(spr_ground)) {
    // tile the sprite across the room using its width/height
    var sw = sprite_get_width(spr_ground);
    var sh = sprite_get_height(spr_ground);
    if (sw <= 0) sw = 128; if (sh <= 0) sh = 128;
    for (var gx = 0; gx < room_width; gx += sw) {
        for (var gy = 0; gy < room_height; gy += sh) {
            draw_sprite(spr_ground, 0, gx + sw/2, gy + sh/2);
        }
    }
} else {
    draw_set_color(make_color_rgb(102,153,51));
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_color(c_white);
}
