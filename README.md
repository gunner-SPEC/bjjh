# gamemaker-mp-poc README

This branch contains a multiplayer proof-of-concept for the GameMaker bike prototype. It integrates a Firebase Realtime Database-based lobby (REST) for session listing and a host-as-server UDP model for in-game syncing.

Files added
- firebase_lobby.gml  — GML helper functions to create/list/join sessions via Firebase REST API
- firebase_setup.md   — instructions to configure Firebase and quick rules

How it works
- Lobby: clients call ListSessions() to obtain open sessions. The host creates a session record using CreateSession() which publishes hostIp and port.
- Connect: after joining, clients read hostIp+port and connect via UDP to the host for real-time updates.
- Sync: host receives periodic compact state updates from clients and relays authoritative states to everyone. Clients interpolate to render other players smoothly.

Next steps
- Implement UDP host/client scripts (mp_server.gml and mp_client.gml) to perform actual websocket/UDP send/receive using GameMaker socket APIs.
- Add in-game UI for Create/Join using firebase_lobby.gml functions.

