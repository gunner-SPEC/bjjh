// data/upgrades.gml
// Simple upgrade definitions (attachments) with stat modifiers
// Example attachments: fork, tires, frame

upgrade_fork_basic = {id:0, name:"Stock Fork", mod_accel:0, mod_stability:0, mod_mass:0};
upgrade_fork_suspension = {id:1, name:"Suspension Fork", mod_accel:0.02, mod_stability:0.12, mod_mass:0.05};
upgrade_tires_road = {id:10, name:"Road Tires", mod_accel:0.03, mod_stability:-0.05, mod_mass:0};
upgrade_tires_offroad = {id:11, name:"Offroad Tires", mod_accel:-0.02, mod_stability:0.18, mod_mass:0.03};

upgrade_frame_light = {id:20, name:"Light Frame", mod_accel:0.07, mod_stability:-0.06, mod_mass:-0.08};
upgrade_frame_armor = {id:21, name:"Reinforced Frame", mod_accel:-0.03, mod_stability:0.22, mod_mass:0.15};

upgrade_list = [upgrade_fork_basic, upgrade_fork_suspension, upgrade_tires_road, upgrade_tires_offroad, upgrade_frame_light, upgrade_frame_armor];
