# GameMaker Project Setup

This file explains how to import and wire the provided scripts in GameMaker Studio (GMS2.3+ recommended).

1) Create a new GameMaker project (GMS2.3+ recommended).

2) Add sprites
   - spr_bike: single frame or simple 2-frame animation for the bike.
   - spr_ground: tile or texture for the track/ground.

3) Add objects
   - obj_bike: copy the code from scripts/obj_bike.gml into the object's Create / Step / Draw events as indicated.
   - obj_camera: copy the Step event code from scripts/obj_camera.gml.
   - obj_ground: set as solid or use collision in code as needed.

4) Create a room
   - Place obj_ground tiles to form a track.
   - Place one instance of obj_bike and one instance of obj_camera.

5) Player input
   - Default keys in the scripts use arrow keys for movement, SPACE for jump, X for wheelie.
   - Replace keyboard checks with gamepad or custom input mapping if desired.

6) Run the room. Adjust parameters in the Create event of obj_bike (max_speed, accel, gravity, jump_strength) to tune the feel.

Notes
- This is a 2.5D / pseudo-3D approach using x/y movement with a z variable for jumps. For fuller 3D, there are extensions but GameMaker is primarily 2D.
- If your GameMaker version is older than 2.3, camera API differs; let me know and I can provide a Views-based camera script.

Next steps I can take (pick one):
- Add placeholder sprites and a sample room layout.
- Add multiple bike configurations and a simple customization UI.
- Add a simple UDP position-sync multiplayer scaffold (proof-of-concept).
