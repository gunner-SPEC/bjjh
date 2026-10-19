# ProjectSetup for gamemaker-full-sp

Target environment: GameMaker IDE v2026.0.0.16 / Runtime v2026.0.0.23

Overview
This branch contains a single-player prototype for a 3rd-person (2.5D) bike game in GameMaker. It includes core bike physics, camera follow, UI scripts, bike data, upgrade data, configuration, and documentation to run the prototype locally.

Files added in this commit
- README.md - short overview and run instructions
- ProjectSetup.md - step-by-step setup and how to import scripts into GMS v2026
- scripts/obj_bike.gml - improved bike controller (Create/Step/Draw)
- scripts/obj_camera.gml - smooth 3rd-person camera (GMS2.3+ camera API)
- scripts/obj_ui.gml - simple HUD drawing (speed, gear, jump)
- data/bikes.gml - three bike archetype definitions
- data/upgrades.gml - basic attachments/upgrades data
- config/game_config.gml - central tunable parameters
- ROADMAP.md - short roadmap with next milestones
- .gitignore - GameMaker ignores

Placeholders
- This commit does NOT include binary sprite assets. It includes clear placeholders and instructions (see ProjectSetup.md) so you can import your own sprites or I can add simple PNG placeholders in a follow-up commit if you want.

How to run
1. Switch to the gamemaker-full-sp branch.
2. Create a new GameMaker project (v2026 recommended).
3. Create the sprites: spr_bike, spr_ground, spr_ui_font (or use default font).
4. Create objects: obj_bike, obj_camera, obj_ui, obj_ground and copy the scripts into their respective events.
5. Create a room and place obj_ground tiles, one obj_bike instance, one obj_camera, and one obj_ui.
6. Run the project and tune parameters in config/game_config.gml.

