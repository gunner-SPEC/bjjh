// firebase_lobby.gml
// GameMaker GML helper for Firebase Realtime Database lobby using HTTP REST API
// Target: GameMaker Runtime v2026.0.0.23
// IMPORTANT: Place the async HTTP response handling code into the Asynchronous HTTP Event

// CONFIG: use your Firebase Realtime Database URL exactly as provided
global.firebase_db_url = "https://inlob-19ea9-default-rtdb.asia-southeast1.firebasedatabase.app";
// Note: we will operate on the /sessions node

// Utility: build sessions endpoint
function firebase_sessions_url() {
    return string(global.firebase_db_url) + "/sessions";
}

// Create a session. Calls POST /sessions.json and returns async request id
// hostIp: string, port: int, hostId: string, map: string, maxPlayers: int
function firebase_create_session(hostIp, port, hostId, map, maxPlayers) {
    var url = firebase_sessions_url() + ".json";
    var payload = {
        hostIp: hostIp,
        port: port,
        hostId: hostId,
        map: map,
        maxPlayers: maxPlayers,
        players: [hostId],
        open: true,
        createdAt: current_time
    };
    var body = json_stringify(payload);
    // http_post_string is asynchronous; the response comes to the Asynchronous HTTP event
    var request_id = http_post_string(url, body);
    // Store some context mapping request id -> purpose
    if (!variable_global_exists("firebase_pending")) global.firebase_pending = ds_map_create();
    ds_map_replace(global.firebase_pending, request_id, {action: "create_session", hostId: hostId});
    return request_id;
}

// List sessions. Calls GET /sessions.json
function firebase_list_sessions() {
    var url = firebase_sessions_url() + ".json";
    var request_id = http_get(url);
    if (!variable_global_exists("firebase_pending")) global.firebase_pending = ds_map_create();
    ds_map_replace(global.firebase_pending, request_id, {action: "list_sessions"});
    return request_id;
}

// Join a session: read session, add playerId to players array, then PUT back updated object
// sessionKey: the Firebase key for the session (returned on create)
function firebase_join_session(sessionKey, playerId) {
    // First GET the session
    var url = firebase_sessions_url() + "/" + string(sessionKey) + ".json";
    var get_id = http_get(url);
    if (!variable_global_exists("firebase_pending")) global.firebase_pending = ds_map_create();
    // store context so when GET returns we will PATCH/PUT updated players
    ds_map_replace(global.firebase_pending, get_id, {action: "join_session_get", sessionKey: sessionKey, playerId: playerId});
    return get_id;
}

// Close session (host): set open=false
function firebase_close_session(sessionKey) {
    var url = firebase_sessions_url() + "/" + string(sessionKey) + ".json";
    var body = json_stringify({open: false});
    // Firebase supports PATCH by sending to the session endpoint with method PATCH; GameMaker doesn't have a built-in http_patch_string in all runtimes
    // We will use http_request with method "PATCH" if available. If not, use PUT with full object replacement (caller can GET first, then PUT entire object).
    // Try to use http_request if runtime supports it:
    if (function_exists(http_request)) {
        // http_request(url, "PATCH", 0, body) // some runtimes accept this signature; comment shown for clarity
        var req = http_request(url, "PATCH", body);
        if (!variable_global_exists("firebase_pending")) global.firebase_pending = ds_map_create();
        ds_map_replace(global.firebase_pending, req, {action: "close_session", sessionKey: sessionKey});
        return req;
    } else {
        // Fallback: GET-and-PUT pattern (caller may need to adapt). For now we just send a POST to the session node which will replace or merge depending on DB.
        var req2 = http_post_string(url, body);
        if (!variable_global_exists("firebase_pending")) global.firebase_pending = ds_map_create();
        ds_map_replace(global.firebase_pending, req2, {action: "close_session", sessionKey: sessionKey});
        return req2;
    }
}

// Helper: called from Asynchronous HTTP event to handle responses
// Place the following code in the Asynchronous HTTP Event of a persistent controller object (e.g., obj_network_manager)
/*
// Asynchronous HTTP Event code (copy-paste into the event):
var id = async_load[? "id"]; // request id
var status = async_load[? "status"]; // HTTP status code
var result = async_load[? "result"]; // response text
// Parse result safely
var parsed = undefined;
if (is_string(result) && string_length(result) > 0) {
    parsed = json_parse(result);
}
if (variable_global_exists("firebase_pending") && ds_map_exists(global.firebase_pending, id)) {
    var ctx = ds_map_find_value(global.firebase_pending, id);
    var action = ctx[? "action"];
    switch (action) {
        case "create_session": {
            // Firebase returns {"name":"-Mxyz..."} when you POST to a collection
            if (is_struct(parsed) && parsed[? "name"]) {
                var sessionKey = parsed[? "name"];
                // Store sessionKey locally for host
                global.my_session_key = sessionKey;
                show_message("Session created: " + sessionKey);
            } else {
                show_message("Failed to create session. HTTP status: " + string(status));
            }
            break;
        }
        case "list_sessions": {
            // parsed is an object where keys are session keys
            // Convert it to a list for UI
            if (is_struct(parsed)) {
                global.firebase_sessions = parsed; // store full map: sessionKey -> sessionObject
                // You can iterate: var keys = ds_map_keys(parsed) etc.
            } else {
                global.firebase_sessions = undefined;
            }
            break;
        }
        case "join_session_get": {
            var sessionKey = ctx[? "sessionKey"];
            var playerId = ctx[? "playerId"];
            // parsed contains session object
            if (is_struct(parsed)) {
                var players = undefined;
                if (ds_map_exists(parsed, "players")) players = parsed[? "players"];
                // Ensure players is an array; if missing create one
                if (!is_array(players)) players = [];
                // Add player if not present
                var already = false;
                for (var i = 0; i < array_length(players); i++) if (players[i] == playerId) { already = true; break; }
                if (!already) array_push(players, playerId);
                // Build updated object for PUT/PATCH
                var updated = parsed;
                updated[? "players"] = players;
                // Send updated object back using PUT (replace) or PATCH
                var url = firebase_sessions_url() + "/" + string(sessionKey) + ".json";
                var body = json_stringify({players: players});
                // Use http_request PATCH if supported
                if (function_exists(http_request)) {
                    var r = http_request(url, "PATCH", body);
                    ds_map_replace(global.firebase_pending, r, {action: "join_session_patch", sessionKey: sessionKey, playerId: playerId});
                } else {
                    var r2 = http_post_string(url, body); // fallback may need adjustment
                    ds_map_replace(global.firebase_pending, r2, {action: "join_session_patch", sessionKey: sessionKey, playerId: playerId});
                }
            } else {
                show_message("Session not found: " + sessionKey);
            }
            break;
        }
        case "join_session_patch": {
            // PATCH response arrived; join succeeded
            show_message("Joined session: " + ctx[? "sessionKey"]);
            // Optionally store the session key and proceed to network connect to hostIp+port
            break;
        }
        default: {
            // Handle other actions like close_session
            break;
        }
    }
    // Clean up
    ds_map_delete(global.firebase_pending, id);
}
*/

// Notes & usage
// - Call firebase_create_session(hostIp, port, hostId, map, maxPlayers) on the host device when creating a session.
// - Call firebase_list_sessions() on clients to populate a lobby UI and show available free-play sessions.
// - Call firebase_join_session(sessionKey, playerId) to request to join; the helper will GET the session and then PATCH the players array.
// - After joining, the client should read the session object (or from global.firebase_sessions) to get hostIp and port and then connect to the host's UDP socket.

