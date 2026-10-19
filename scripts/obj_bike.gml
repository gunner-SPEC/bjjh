// scripts/obj_bike.gml
// --- Create Event ---
// Paste into obj_bike Create event
include("config/game_config.gml");
include("data/bikes.gml");
include("data/upgrades.gml");

// active bike selection (start with balanced)
active_bike = bike_balanced;

// visual customization
paint_color = c_white; // default color - can be changed by customization UI
outfit_id = 0; // placeholder for outfit selection

// Apply active bike base stats
speed = 0;
max_speed = active_bike.max_speed;
accel = active_bike.accel;
turn_speed = active_bike.turn;
stability = active_bike.stability;
mass = active_bike.mass;

// upgrade slots (ids from upgrade_list)
equipped_upgrades = {
    fork: upgrade_fork_basic,
    tires: upgrade_tires_offroad,
    frame: upgrade_frame_armor
};

// Apply upgrade modifiers (simple additive)
function apply_upgrades() {
    var u = equipped_upgrades;
    max_speed = active_bike.max_speed * (1 + (u.frame.mod_accel + u.fork.mod_accel + u.tires.mod_accel));
    accel = active_bike.accel * (1 + (u.frame.mod_accel + u.fork.mod_accel + u.tires.mod_accel));
    stability = active_bike.stability + (u.frame.mod_stability + u.fork.mod_stability + u.tires.mod_stability);
    mass = active_bike.mass + (u.frame.mod_mass + u.fork.mod_mass + u.tires.mod_mass);
}
apply_upgrades();

// physics variables
friction = config_friction;

// vertical physics (2.5D)
z = config_ground_clearance; // visual height above floor when grounded
vz = 0;
grounded = true;

gravity = config_gravity;
jump_strength = config_jump_strength;

// wheelie
wheelie_hold = false;
wheelie_pitch = 0;

// animation and state
is_airborne = false;

// tuning
suspension_stiffness = config_suspension_stiffness;
suspension_damping = config_suspension_damping;

// input smoothing
steer_input = 0;
throttle_input = 0;

// --- Step Event ---
// Paste into obj_bike Step event
if (!instance_exists(obj_ui)) {
    // Ensure UI exists in room
    instance_create_layer(16,16,"Instances", obj_ui);
}

// Read inputs (customize to your mapping)
var forward = keyboard_check(vk_up) - keyboard_check(vk_down);
var steer = keyboard_check(vk_right) - keyboard_check(vk_left);
var jump_pressed = keyboard_check_pressed(vk_space);
wheelie_hold = keyboard_check(ord("X"));

// Smooth inputs
steer_input = lerp(steer_input, steer, 0.2);
throttle_input = lerp(throttle_input, forward, 0.22);

// Acceleration and braking with mass influence
if (throttle_input > 0) {
    speed = min(speed + accel * throttle_input * (1.0 / mass), max_speed);
} else if (throttle_input < 0) {
    speed = max(speed - (config_brake * -throttle_input) * (1.0 / mass), -max_speed*0.6);
} else {
    // friction slows bike
    speed *= (1 - friction);
    if (abs(speed) < 0.03) speed = 0;
}

// Movement in x/y according to image_angle (facing angle)
x += lengthdir_x(speed, image_angle);
y += lengthdir_y(speed, image_angle);

// Steering scaled by speed and bike turn stat
var speed_factor = clamp(abs(speed) / max_speed, 0, 1);
var steer_effect = steer_input * turn_speed * (1 - speed_factor*0.7);
image_angle += steer_effect;

// Jumping
if (jump_pressed && grounded) {
    vz = -jump_strength * (1.0 / mass);
    grounded = false;
}

// Vertical physics & pseudo-suspension
var target_z = config_ground_clearance; // if you'd like terrain height sampling, replace this
// spring-damper towards target_z
var spring = suspension_stiffness * (target_z - z);
var damp = -suspension_damping * vz;
var accel_z = spring + damp + gravity;
vz += accel_z;
z += vz;

if (z >= target_z - 0.01) {
    z = target_z;
    vz = 0;
    grounded = true;
    is_airborne = false;
} else {
    is_airborne = true;
}

// Wheelie behavior
if (wheelie_hold && grounded && abs(speed) > 3) {
    wheelie_pitch = lerp(wheelie_pitch, config_wheelie_tilt, 0.12);
    speed = min(speed + config_wheelie_speed_bonus, max_speed + 2);
} else {
    wheelie_pitch = lerp(wheelie_pitch, 0, 0.08);
}

// Keep bike inside room bounds
x = clamp(x, 8, room_width - 8);
y = clamp(y, 8, room_height - 8);

// --- Draw Event ---
// Draw ground shadow (optional)
var shadow_y = y; // offset shadow at ground position
draw_set_alpha(0.35);
draw_set_color(c_black);
draw_circle(x, shadow_y, 8, false);
draw_set_alpha(1);

// Draw bike sprite at x,y - z to simulate vertical lift
// Use paint_color tint if present
var tint = (is_undefined(paint_color) ? c_white : paint_color);
if (sprite_exists(spr_bike)) {
    draw_sprite_ext(spr_bike, 0, x, y - z, 1, 1, image_angle + wheelie_pitch, tint, 1);
} else {
    // fallback: simple rectangle for placeholder
    draw_set_color(tint);
    draw_rectangle(x-12, y-8 - z, x+12, y+8 - z, false);
    draw_set_color(c_white);
}
