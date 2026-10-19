# Firebase setup for GameMaker lobby (inlob-19ea9 project)

This file documents steps to set up the Firebase Realtime Database and minimal security rules, and how to use the provided REST-based lobby from GameMaker.

Database URL used in code:
https://inlob-19ea9-default-rtdb.asia-southeast1.firebasedatabase.app

1) Console setup
- Open Firebase Console: https://console.firebase.google.com/
- Select project: inlob-19ea9
- Go to Realtime Database → Create Database (choose region Asia Southeast 1 if asked)

2) Quick rules for development (insecure, DO NOT use in production)
In the Realtime Database > Rules tab, for quick testing set:

{
  "rules": {
    ".read": true,
    ".write": true
  }
}

This allows anyone to create/list/join sessions. For production, enable Authentication and restrict rules properly.

3) CLI deployment (optional)
- Install Firebase CLI: npm install -g firebase-tools
- Login: firebase login
- Initialize (if you want to deploy rules from a file): firebase init database
- Edit database.rules.json, then deploy with: firebase deploy --only database

4) Data structure (sessions)
Sessions are stored under /sessions
Example session object (host POST to /sessions.json returns auto-generated key):

{
  "hostIp": "203.0.113.12",
  "port": 9000,
  "hostId": "player123",
  "map": "free_ride",
  "maxPlayers": 8,
  "players": ["player123"],
  "open": true,
  "createdAt": 1690000000
}

5) GameMaker usage notes
- Use firebase_lobby.gml helper functions to create/list/join sessions via the REST API.
- Place the asynchronous response handling code (commented block in the GML file) into the Asynchronous HTTP Event of a persistent controller object (e.g., obj_network_manager) and adapt the event variable parsing if your runtime differs.
- After joining a session, read the session object to obtain hostIp and port and then connect to the host via UDP socket for real-time position sync.

6) NAT / connectivity caveat
- For internet play, hosts behind NAT will likely require port forwarding or a relay server. For simple testing use LAN or run a VPS to act as authoritative host (recommended for public play).

7) Security improvements (next steps)
- Enable Firebase Authentication (e.g., anonymous sign-in) and require auth in rules.
- Use server-side Cloud Functions to validate session creation and reduce tampering.

