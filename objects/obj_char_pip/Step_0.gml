/// @description All of her movement physics.
// You can write your code in this editor

// Grabbing the target Estelle position.
var _estelle_x = obj_char_estelle.x + estelle_x_offset + (obj_char_estelle.x - mouse_x) / 2;
var _estelle_y = obj_char_estelle.y + estelle_y_offset;

// Dragging Pip towards Estelle when the tractor beam is active.
if (mouse_check_button(mb_left)) {
	momentum_x += (_estelle_x - x) * phys_estelle_grab_strength * (1 / (distance_to_point(_estelle_x, _estelle_y) + 4));
	momentum_y += (_estelle_y - y) * phys_estelle_grab_strength * (1 / (distance_to_point(_estelle_x, _estelle_y) + 2));
}

// Apply gravity.
momentum_y += phys_pip_gravity;

// Stopping her from leaving the room.
if (y > room_height + sprite_height) y = room_height + sprite_height;
if (y < -sprite_height) y = -sprite_height;
if (x > global.world_width / 2) x = -global.world_width / 2;
if (x < -global.world_width / 2) x = global.world_width / 2;

// Cancelling her momentum if she's slow enough.
if (abs(momentum_x) < 1 && !mouse_check_button(mb_left)) momentum_x = 0;
if (abs(momentum_y) < 1 && !mouse_check_button(mb_left)) momentum_y = 0;

// Bouncy Pip
if (!place_free(x + momentum_x, y)) {
	var _other = instance_place(x + momentum_x, y, all);
	if (abs(momentum_x) > 3 && _other != undefined && _other != noone && object_is_ancestor(_other.object_index, obj_base_breakable)) damage_breakable(_other);
	
	momentum_x = -momentum_x * phys_pip_bounce_factor_x;
}

if (!place_free(x, y + momentum_y)) {
	var _other = instance_place(x, y + momentum_y, all);
	if (abs(momentum_y) > 3 && _other != undefined && _other != noone && object_is_ancestor(_other.object_index, obj_base_breakable)) damage_breakable(_other);
	
	momentum_y = -momentum_y * phys_pip_bounce_factor_y;
}


if (y > room_height - 64 && !mouse_check_button(mb_left)) {
	momentum_x *= 0.5;
	momentum_y = (y - room_height - 64) * 0.1;
	scr_reset_combo();
}

if (y > room_height + sprite_height) {
	momentum_y = -10;
}

// Applying drag.
momentum_x *= phys_pip_drag_x;
momentum_y *= phys_pip_drag_y;

// Applying physics.
x += momentum_x;
y += momentum_y;

// Handling scrolling.
if(place_free(x + global.world_width_scroll_delta, y)) x += global.world_width_scroll_delta;



