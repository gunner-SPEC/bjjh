# Multiplayer testing guide (mp_poc)

This guide explains how to test the multiplayer free-play POC locally (LAN) using the code in gamemaker-mp-poc.

1) Prepare GameMaker project
- Use GameMaker Runtime v2026.0.0.23 and open the scripts in multiplayer/ and scripts/ folder of the branch.
- Create persistent objects: obj_mp_server (host), obj_mp_client (client), obj_network_manager (for Async HTTP handling), obj_lobby_ui (for lobby UI).
- Copy the Asynchronous HTTP event code from firebase_lobby.gml into obj_network_manager's Asynchronous HTTP event.

2) Host flow
- In the running game on the host PC, click "Host Free Play" in obj_lobby_ui (or call in code):
  - This starts the UDP server socket (mp_server_create) and posts a session to Firebase (firebase_create_session).
  - Note: you must enter the host's public IP in the Host UI for clients to connect across the internet, or use LAN testing by using host's local IP.

3) Client flow
- On another PC on same LAN (or another instance), open the game and click "Refresh Sessions" in lobby.
- Select a session from the list and click it to join (this triggers firebase_join_session). When join completes, the async handler will show success.
- After join succeeds, read session's hostIp and port and call mp_client_connect(hostIp, port) to start sending/receiving state.

4) Debugging tips
- Use show_debug_message to print incoming packets, remote player counts, and last seen times.
- If clients never receive server broadcasts, check firewall/port blocking and ensure host IP/port are reachable.
- For internet testing, consider running the host on a VPS to avoid NAT issues.

5) Next steps
- Optimize packet format (binary buffers) to reduce bandwidth.
- Implement client prediction and server reconciliation to hide latency.
- Add NAT traversal or a relay server for public internet play.

