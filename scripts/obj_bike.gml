// obj_bike.gml
// --- Create Event ---
// Place this code into the Create event of obj_bike
speed = 0;
max_speed = 14;      // horizontal surface speed
accel = 0.6;
brake = 1.2;
turn_speed = 3;      // degrees per step
friction = 0.04;

// 2.5D vertical (z) variables
z = 0;               // height above ground
vz = 0;              // vertical velocity
gravity = 0.35;
jump_strength = 8;
grounded = true;

// wheelie
wheelie_hold = false;
wheelie_pitch = 0;   // visual tilt amount

// Sprite/orientation
image_angle = 0;

// --- Step Event ---
// Place this code into the Step event of obj_bike
// Inputs: up/down = accelerate/brake (keyboard or mapped buttons), left/right = steer, jump = SPACE, wheelie = X
var forward = keyboard_check(vk_up) - keyboard_check(vk_down);   // or custom keys
var steer = keyboard_check(vk_right) - keyboard_check(vk_left);

if (forward > 0) {
    speed = min(speed + accel * forward, max_speed);
} else if (forward < 0) {
    speed = max(speed - brake * -forward, -max_speed*0.6);
} else {
    // natural slowing
    speed *= (1 - friction);
    if (abs(speed) < 0.05) speed = 0;
}

// movement on x/y plane (bike faces image_angle)
x += lengthdir_x(speed, image_angle);
y += lengthdir_y(speed, image_angle);

// steering affects image_angle; sharper at lower speeds
var steer_effect = steer * turn_speed * (1 - clamp(abs(speed) / max_speed, 0, 0.9));
image_angle += steer_effect;

// jump
if (keyboard_check_pressed(vk_space) && grounded) {
    vz = -jump_strength;
    grounded = false;
}

// vertical physics
vz += gravity;
z += vz;
if (z >= 0) {
    z = 0;
    vz = 0;
    grounded = true;
}

// wheelie (hold X to wheelie while grounded)
wheelie_hold = keyboard_check(ord("X"));
if (wheelie_hold && grounded && speed > 3) {
    wheelie_pitch = lerp(wheelie_pitch, -12, 0.12); // tilt up visually
    // small speed boost while wheelie
    speed = min(speed + 0.05, max_speed + 2);
} else {
    wheelie_pitch = lerp(wheelie_pitch, 0, 0.08);
}

// limit position inside room bounds if desired
x = clamp(x, 0, room_width);
y = clamp(y, 0, room_height);

// --- Draw Event ---
// Place this code into the Draw event of obj_bike (or Draw GUI if preferred)
draw_sprite_ext(spr_bike, 0, x, y - z, 1, 1, image_angle + wheelie_pitch, c_white, 1);
