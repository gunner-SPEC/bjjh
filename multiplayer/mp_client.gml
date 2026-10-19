// multiplayer/mp_client.gml
// UDP client implementation (prototype) for GameMaker Runtime v2026
// Usage: Place the Create/Step/Asynchronous Networking handlers into a persistent client object (e.g., obj_mp_client)

/// Create/connect
function mp_client_connect(host_ip, host_port) {
    // Create local UDP socket (some runtimes require creating a socket before connecting)
    // client_socket = network_create_socket("UDP"); // optional
    // Connect to the host
    // client_socket_handle = network_connect(host_ip, host_port);
    client_socket_handle = network_create_socket("UDP", 0); // placeholder; adapt to runtime
    global.mp_client_socket = client_socket_handle;
    global.mp_host_ip = host_ip;
    global.mp_host_port = host_port;

    global.mp_remote_players = ds_map_create(); // id -> map of interpolation samples
    global.mp_send_rate = 0.12; // seconds between sending our state (~8Hz)
    global.mp_last_send = current_time - global.mp_send_rate;

    show_debug_message("MP Client connecting to " + host_ip + ":" + string(host_port));
}

// --- Step event ---
function mp_client_step() {
    // Send our state periodically
    if (current_time - global.mp_last_send > global.mp_send_rate) {
        mp_client_send_state();
        global.mp_last_send = current_time;
    }
    // Interpolation for remote players (rendering should use interpolated positions)
    var keys = ds_map_keys(global.mp_remote_players);
    for (var i = 0; i < array_length(keys); i++) {
        var k = keys[i];
        var entry = ds_map_find_value(global.mp_remote_players, k);
        // entry contains samples array; interpolate in your Draw step
    }
}

// --- Send local state to host ---
function mp_client_send_state() {
    if (!variable_global_exists("mp_client_socket") || !variable_global_exists("mp_host_ip")) return;
    // Build a compact JSON for prototype: {tempId: localId, x,y,angle,speed,z,flags}
    var msg = { x: obj_bike.x, y: obj_bike.y, angle: obj_bike.image_angle, speed: obj_bike.speed, z: obj_bike.z, flags: {air: obj_bike.is_airborne} };
    var body = json_stringify(msg);
    // send via UDP
    network_send_packet(global.mp_client_socket, body, global.mp_host_ip, global.mp_host_port);
}

// --- Asynchronous Networking event (client) ---
/*
Place this in the client's Asynchronous Networking event. It will receive server broadcasts.
Example pseudocode:
var evt_type = async_load[? "type"];
if (evt_type == network_event_type_data) {
    var buffer = async_load[? "buffer"];
    var raw = buffer_read(buffer, buffer_string);
    var msg = json_parse(raw);
    // msg.players is array of player states. For each state, update remote_players map.
    var players = msg[? "players"];
    for (var i = 0; i < array_length(players); i++) {
        var p = players[i];
        var id = p[? "id"];
        // store sample: {t: msg.ts, x: p.x, y: p.y, angle: p.angle, z: p.z}
        if (!ds_map_exists(global.mp_remote_players, id)) ds_map_replace(global.mp_remote_players, id, {samples: []});
        var entry = ds_map_find_value(global.mp_remote_players, id);
        array_push(entry.samples, {t: current_time, x: p[? "x"], y: p[? "y"], angle: p[? "angle"], z: p[? "z"]});
        ds_map_replace(global.mp_remote_players, id, entry);
    }
}
*/

// --- Helper send (same as server send) ---
function network_send_packet(socket, data_string, ip, port) {
    var buf = buffer_create(string_length(data_string) + 4, buffer_grow, 1);
    buffer_write(buf, buffer_string, data_string);
    buffer_seek(buf, buffer_seek_start, 0);
    // network_send_raw(socket, buf, buffer_tell(buf), ip, port); // adapt to your runtime
    buffer_delete(buf);
}
