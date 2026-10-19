// multiplayer/mp_server.gml
// Authoritative UDP host implementation (concept + GML scaffold) for GameMaker Runtime v2026
// NOTE: GameMaker's networking API signatures may differ across runtimes.
// This file provides concrete logic and clear markers where to adapt to your runtime's functions.

/// How to use
// 1) Place the Create/Step/Asynchronous Networking code into a persistent host object (e.g., obj_mp_server)
// 2) Call mp_server_create(port, max_players) in the Create event or from UI when starting a host
// 3) Clients will send position updates; the server will broadcast authoritative states back

// --- Create (or script) ---
function mp_server_create(port, max_players) {
    // Create UDP server socket
    // Replace this with your runtime's exact call. Typical signature:
    // server_socket = network_create_server("UDP", port, max_players);
    server_socket = network_create_server("UDP", port, max_players);
    global.mp_server_socket = server_socket;

    // Data structures
    global.mp_clients = ds_map_create(); // key: client_id -> map {addr, port, last_seen, x,y,angle,speed,z,ts}
    global.mp_next_id = 1;
    global.mp_broadcast_rate = 0.12; // seconds between authoritative broadcasts (~8Hz)
    global.mp_last_broadcast = current_time;

    show_debug_message("MP Server started on port " + string(port));
}

// --- Step event ---
function mp_server_step() {
    // Periodically broadcast authoritative state to clients
    if (current_time - global.mp_last_broadcast > global.mp_broadcast_rate) {
        mp_server_broadcast_states();
        global.mp_last_broadcast = current_time;
    }
    // Optionally perform timeout cleanup
    var to_remove = [];
    var keys = ds_map_keys(global.mp_clients);
    for (var i = 0; i < array_length(keys); i++) {
        var k = keys[i];
        var c = ds_map_find_value(global.mp_clients, k);
        if (current_time - c.last_seen > 7.0) {
            array_push(to_remove, k);
        }
    }
    for (var i = 0; i < array_length(to_remove); i++) {
        ds_map_delete(global.mp_clients, to_remove[i]);
    }
}

// --- Asynchronous Networking event ---
/*
Place this code in the Asynchronous Networking event (Network event) of the host object.
The exact event variables depend on runtime; GameMaker provides an async_load map with keys like "id"/"type"/"buffer".
This scaffold assumes you can inspect incoming UDP packets and find the sender address/port.
*/
// Example handler pseudocode:
/*
var evt_type = async_load[? "type"]; // e.g. network_event_type
if (evt_type == network_event_type_data) {
    var buffer = async_load[? "buffer"]; // a buffer with received data
    var addr = async_load[? "ip"]; // sender ip
    var port = async_load[? "port"]; // sender port
    // Convert buffer to string if sender uses JSON: var msg = buffer_read(buffer, buffer_string);
    var raw = buffer_read(buffer, buffer_string);
    // Parse JSON message (client->server): {clientTempId, x,y,angle,speed,z,flags}
    var msg = json_parse(raw);

    // Identify or assign a client id for this addr:port
    var client_key = string(addr) + ":" + string(port);
    var client_id = undefined;
    if (ds_map_exists(global.mp_clients, client_key)) {
        client_id = client_key;
    } else {
        // Register new client
        var info = ds_map_create();
        info[? "addr"] = addr;
        info[? "port"] = port;
        info[? "last_seen"] = current_time;
        info[? "x"] = msg[? "x"];
        info[? "y"] = msg[? "y"];
        info[? "angle"] = msg[? "angle"];
        info[? "speed"] = msg[? "speed"];
        info[? "z"] = msg[? "z"];
        info[? "flags"] = msg[? "flags"];
        ds_map_replace(global.mp_clients, client_key, info);
        client_id = client_key;
    }

    // Update client state
    var cinfo = ds_map_find_value(global.mp_clients, client_key);
    cinfo[? "last_seen"] = current_time;
    cinfo[? "x"] = msg[? "x"];
    cinfo[? "y"] = msg[? "y"];
    cinfo[? "angle"] = msg[? "angle"];
    cinfo[? "speed"] = msg[? "speed"];
    cinfo[? "z"] = msg[? "z"];
    cinfo[? "flags"] = msg[? "flags"];
    ds_map_replace(global.mp_clients, client_key, cinfo);
}
*/

// --- Broadcast authoritative states to all clients ---
function mp_server_broadcast_states() {
    // Build a compact states object: we will send a JSON string for simplicity in prototype
    var payload = {};
    payload[? "ts"] = current_time;
    var players = [];

    var keys = ds_map_keys(global.mp_clients);
    for (var i = 0; i < array_length(keys); i++) {
        var k = keys[i];
        var p = ds_map_find_value(global.mp_clients, k);
        var pt = { x: p[? "x"], y: p[? "y"], angle: p[? "angle"], speed: p[? "speed"], z: p[? "z"], flags: p[? "flags"], id: k };
        array_push(players, pt);
    }
    payload[? "players"] = players;
    var body = json_stringify(payload);

    // Send body to each client's addr/port via UDP socket
    var keys2 = ds_map_keys(global.mp_clients);
    for (var i = 0; i < array_length(keys2); i++) {
        var k = keys2[i];
        var c = ds_map_find_value(global.mp_clients, k);
        // send UDP packet
        // network_send_packet(server_socket, body, string(c[?"addr"]), c[?"port"]);
        network_send_packet(global.mp_server_socket, body, string(c[? "addr"]), c[? "port"]);
    }
}

// --- Utility send (use your runtime's packet send) ---
function network_send_packet(socket, data_string, ip, port) {
    // In many runtimes you must create a buffer and then send via network_send_raw or network_send_packet.
    var buf = buffer_create(string_length(data_string) + 4, buffer_grow, 1);
    buffer_write(buf, buffer_string, data_string);
    buffer_seek(buf, buffer_seek_start, 0);
    // network_send_raw(socket, buf, buffer_tell(buf), ip, port); // pseudocode
    // Some runtimes provide network_send_packet(socket, buf, buffer_tell(buf), ip, port)
    // Adapt to your exact runtime API here.
    buffer_delete(buf);
}

// --- Shutdown ---
function mp_server_shutdown() {
    if (variable_global_exists("mp_server_socket") && global.mp_server_socket != -1) {
        network_destroy(global.mp_server_socket);
        global.mp_server_socket = -1;
    }
    if (variable_global_exists("mp_clients")) {
        ds_map_destroy(global.mp_clients);
    }
}
