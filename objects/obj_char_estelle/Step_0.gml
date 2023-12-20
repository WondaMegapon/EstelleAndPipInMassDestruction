/// @description All of her movement logic.

// Adjusting for the last frame's delta.
x += global.world_width_scroll_delta;

// Slowing Estelle when she's carrying an object.
move_speed = mouse_check_button(mb_left) ? move_speed_carry : move_speed_normal;

// Setting the target position for Estelle to be.
var _target_x = lerp(mouse_x, x, move_speed);
var _target_y = lerp(mouse_y, y, move_speed);

// Moving only when there's a valid path to move.
if (place_free(_target_x, _target_y)) {
	x = _target_x;
	y = _target_y;
} else if (inv_frames < current_time) {
	global.game_score = floor(global.game_score / 2);
	scr_reset_combo();
	inv_frames = current_time + inv_frames_max;
	global.screen_shake += 20;
}


// Estelle is running all of our global functions. :>
scr_global_step();