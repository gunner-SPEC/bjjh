// data/bikes.gml
// Define 3 bike archetypes as scripts/definitions. Include in Create event or a manager to load.
// Each bike is a map of stats; simple GML arrays / ds maps can also be used. We'll use structs (GMS2.3+ supported syntax).

/// bike_light
bike_light = {
    id: 0,
    name: "Light/Agile",
    max_speed: config_max_speed * 1.12,
    accel: config_accel * 1.15,
    turn: config_turn_speed * 1.2,
    stability: 0.85, // less stable in air and on land
    mass: 0.9
};

/// bike_balanced
bike_balanced = {
    id: 1,
    name: "Balanced",
    max_speed: config_max_speed,
    accel: config_accel,
    turn: config_turn_speed,
    stability: 1.0,
    mass: 1.0
};

/// bike_heavy
bike_heavy = {
    id: 2,
    name: "Heavy/Stable",
    max_speed: config_max_speed * 0.92,
    accel: config_accel * 0.85,
    turn: config_turn_speed * 0.85,
    stability: 1.18,
    mass: 1.22
};

// Export a list for UI
bike_list = [bike_light, bike_balanced, bike_heavy];
