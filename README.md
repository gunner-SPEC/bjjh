# GameMaker Starter — 3rd-person bike prototype

This repository contains a small GameMaker Studio 2 (GMS2) starter to help you prototype a 3rd-person bike game in GameMaker (YoYo Games).

Important notes
- GameMaker is primarily a 2D engine with limited 3D support. The code here is a lightweight 2.5D / pseudo-3D third-person bike prototype that works well in GMS2 using sprites and camera offsets.
- This is a minimal starting point: import the scripts into a new GMS2 project, create the objects listed in ProjectSetup.md, and assign the code to the appropriate events.

What I added
- ProjectSetup.md — step-by-step import instructions and how to wire the objects.
- scripts/obj_bike.gml — Create / Step / Draw logic for a simple bike controller with acceleration, braking, steering, jump, and a basic wheelie mechanic.
- scripts/obj_camera.gml — simple camera follow code for a third-person view.
- README.md — this file.
- .gitignore — basic ignores for GameMaker projects.

Next steps I can take
- Add more polished physics and collision handling.
- Add multiple bike objects, upgrade/attachment data, color customization, and outfits.
- Integrate online multiplayer ideas (note: GameMaker has multiplayer functions but real-time authoritative multiplayer for physics is harder).

If you want me to push additional scripts (UI, upgrades, inventory) or create sprites and a simple room, tell me and I will add them to a new branch so you can review first.
