// obj_camera.gml
// Step event for obj_camera (GMS2.3+ camera API)
// Place this in the Step event of obj_camera
if (instance_exists(obj_bike)) {
    var cam = camera_get_active();
    var view_w = camera_get_view_width(cam);
    var view_h = camera_get_view_height(cam);
    var target_x = obj_bike.x - view_w/2;
    var target_y = obj_bike.y - view_h/2 - obj_bike.z*0.6; // shift up slightly when bike is airborne
    var cur_x = camera_get_view_x(cam);
    var cur_y = camera_get_view_y(cam);

    // smooth follow
    var nx = lerp(cur_x, target_x, 0.12);
    var ny = lerp(cur_y, target_y, 0.12);
    camera_set_view_pos(cam, nx, ny);
}
