// config/game_config.gml
// Central config values you can tune for feel
config_max_speed = 16;      // base max horizontal speed
config_accel = 0.9;         // acceleration per step
config_brake = 1.6;         // braking deceleration
config_turn_speed = 3.4;    // steering responsiveness
config_friction = 0.045;    // ground friction

// vertical / jump
config_gravity = 0.42;
config_jump_strength = 9.3;

// suspension-like feel (pseudo-spring on 'z')
config_suspension_stiffness = 0.18; // spring strength
config_suspension_damping = 0.12;   // damping

// wheelie
config_wheelie_tilt = -14;
config_wheelie_speed_bonus = 0.06;

// misc
config_ground_clearance = 6; // how visually high the bike sits above ground
