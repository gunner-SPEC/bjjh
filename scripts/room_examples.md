# Sample Rooms and Placement

Create three sample rooms and a free-ride room using these guidelines. This file helps you set up playable demo rooms quickly.

1) rm_forest_trail
- Size: 2048 x 1024
- Place obj_ground covering the room
- Add a winding path of ramp objects (obj_ramp) and decorative objects (trees using spr_tree)
- Place obj_bike at start (x:100, y:500), obj_camera, obj_ui, obj_custom_ui, obj_upgrade_ui

2) rm_mountain_downhill
- Size: 1024 x 4096 (vertical track)
- Use obj_ground and place ramps and narrow paths to simulate downhill sections
- Place more obstacles (obj_rock) and rails
- Spawn obj_bike near top of track

3) rm_urban_rooftop
- Size: 2048 x 2048
- Place many small platform instances (objects or tiles) to form rooftops and train areas
- Use obj_ramp for launch points between roofs

4) rm_free_ride
- Size: 4096 x 4096
- Large open area made of obj_ground and scattered ramps, props
- Place obj_bike in center and ensure obj_camera covers player

Notes
- Use layer "Instances" for gameplay objects and dedicated layers for background/decoration.
- Keep object counts reasonable for performance; use backgrounds for distant details.
