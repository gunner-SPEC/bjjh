// scripts/obj_lobby_ui.gml
// Simple in-game lobby UI which uses firebase_lobby.gml helper functions
// Usage: place obj_lobby_ui in a room. Add Draw GUI and Mouse Left Pressed events as noted.

// Draw GUI event
/*
var base_x = 16; var base_y = 16;
draw_set_color(make_color_rgb(18,18,18));
draw_rectangle(base_x-8, base_y-8, base_x + 360, base_y + 260, true);
draw_set_color(c_white);
draw_text(base_x, base_y, "Multiplayer Lobby (Firebase)");

// Create session button
if (button(base_x, base_y+24, 140, 28, "Host Free Play")) {
    // Start host UDP server on port 9000 and create session in Firebase
    mp_server_create(9000, 8);
    // Get local IP - GameMaker doesn't always provide a simple call; you may prefer to enter IP manually or use a discovery service
    var hostIp = "<HOST_IP_HERE>"; // replace with actual host public IP
    firebase_create_session(hostIp, 9000, "player_" + string(irandom(9999)), "free_ride", 8);
}

// List sessions button
if (button(base_x+160, base_y+24, 140, 28, "Refresh Sessions")) {
    firebase_list_sessions();
}

// Show sessions from global.firebase_sessions
var yy = base_y + 64;
if (variable_global_exists("firebase_sessions") && is_struct(global.firebase_sessions)) {
    var keys = ds_map_keys(global.firebase_sessions);
    for (var i = 0; i < array_length(keys); i++) {
        var k = keys[i];
        var s = ds_map_find_value(global.firebase_sessions, k);
        var label = "[" + string(s[? "players"].length) + "/" + string(s[? "maxPlayers"]) + "] " + s[? "map"] + " (host:" + s[? "hostId"] + ")";
        draw_text(base_x, yy + i*24, label);
        // Click to join: handle in Mouse Left Pressed event
    }
}
*/

// Mouse Left Pressed event (paste code into that event)
/*
var base_x = 16; var base_y = 16; var yy = base_y + 64;
var keys = ds_map_keys(global.firebase_sessions);
for (var i = 0; i < array_length(keys); i++) {
    var k = keys[i];
    var s = ds_map_find_value(global.firebase_sessions, k);
    var rect_x1 = base_x; var rect_y1 = yy + i*24; var rect_x2 = rect_x1 + 320; var rect_y2 = rect_y1 + 20;
    if (mouse_x > rect_x1 && mouse_x < rect_x2 && mouse_y > rect_y1 && mouse_y < rect_y2) {
        // Join session
        var playerId = "player_" + string(irandom(99999));
        firebase_join_session(k, playerId);
        // After firebase JOIN completes (in the async handler) you should read the session object to get hostIp and port and then call mp_client_connect(hostIp, port)
        break;
    }
}
*/
