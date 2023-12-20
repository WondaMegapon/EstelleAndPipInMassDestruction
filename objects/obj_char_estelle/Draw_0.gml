draw_text(0, 0, "Score: " + string(global.game_score));
draw_text(0, 12, "Combo: x" + string(global.game_combo));
//draw_text(0, 24, "Time:  " + string(ceil((global.game_timer - current_time) / 1000)));
var _squash_factor = 512;
var _distance_from_mouse_x = mouse_x - x;
var _distance_from_mouse_y = mouse_y - y;
draw_sprite_ext(sprite_index, -1, x, y, exp(-abs(_distance_from_mouse_x/_squash_factor)), exp(abs(_distance_from_mouse_x/_squash_factor)), -_distance_from_mouse_x / 2, (inv_frames >= current_time && sign(sin(current_time/32))) ? c_gray : c_white, 1);