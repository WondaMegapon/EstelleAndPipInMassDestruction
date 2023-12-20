// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

game_score = 0;
game_high_score = 0;
game_timer = 120000;
game_timer_max = 120000;
game_combo = 1;
game_combo_max = 10;
game_combo_timer = 0;
game_combo_window = 2;

world_width = 2880;
world_width_scroll_speed = 20;
world_width_scroll_delta = 0;

director_balance = 0; // The amount of credits the director has.
director_spawn_timer = 0; // The time until the director can spawn again.
director_spawn_count = 0; // A tracker for the amount of loaded entities.
director_spawn_count_max = 32; // The maximum amount of entities that can be loaded.
director_pool = [
	{
		item: obj_breakable_pedestrian,
		cost: 0,
	},
	{
		item: obj_breakable_cyclist,
		cost: 3,
	},
	{
		item: obj_breakable_car,
		cost: 5,
	},
	{
		item: obj_breakable_plane,
		cost: 9,
	},
	{
		item: obj_breakable_missile_basic,
		cost: 15,
	},
	{
		item: obj_breakable_missile_advanced,
		cost: 60,
	}
]

screen_shake = 0;

function scr_global_step() {
	// Handling the camera logic.
	var _scroll_amount

	if(display_mouse_get_x() < window_get_width() / 3) {
		_scroll_amount = global.world_width_scroll_speed * ((display_mouse_get_x() - window_get_width() / 3) / (window_get_width() / 3));
	}

	if(display_mouse_get_x() > 2 * window_get_width() / 3) {
		_scroll_amount = global.world_width_scroll_speed * ((display_mouse_get_x() - 2 * window_get_width() / 3) / (2 * window_get_width() / 3));
	}

	// Messing with background details.
	global.world_width_scroll_delta = (_scroll_amount != undefined) ? -_scroll_amount : 0;
	layer_hspeed(layer_get_id("Background"), global.world_width_scroll_delta);

	// And the screenshake.
	var _fx_shake = fx_create("_filter_screenshake");
	fx_set_parameter(_fx_shake, "g_Magnitude", global.screen_shake)
	layer_set_fx("Instances", _fx_shake);
	global.screen_shake *= 0.8;	
	
	// Handling the combo system.
	if (global.game_combo_timer <= current_time)
		scr_reset_combo();
	
	if (global.director_spawn_timer <= current_time) scr_spawn_random_breakable();
}

function scr_add_score(_value) {
	// Incrementing the score.
	global.game_score += _value * global.game_combo;
	global.director_balance += _value * global.game_combo;
	if (global.game_combo < global.game_combo_max) global.game_combo += 1;
	// Setting the timer.
	global.game_combo_timer = current_time + global.game_combo_window * 1000;
	if (global.game_score % 100) global.game_timer += 15;
}

function scr_reset_combo() {
	global.game_combo = 1;
}

function damage_breakable(_instance) {
	global.screen_shake += 10;
	
	if(_instance.health_current <= 1) {
		scr_add_score(_instance.score_value_break);
		global.director_spawn_count--;
		instance_destroy(_instance);
	} else {
		scr_add_score(_instance.score_value_damage);
		_instance.health_current -= 1;
	}
}

function get_highest_cost_item() {
	var _gm_object = obj_breakable_pedestrian;
	var _lowest_cost = 0;
	
	for(var _i = 0; _i < array_length(global.director_pool); _i++) {
		if(global.director_pool[_i].cost < global.director_balance && global.director_pool[_i].cost >= _lowest_cost) {
			if(global.director_pool[_i].cost > _lowest_cost || (global.director_pool[_i].cost == _lowest_cost && round(random(1))))
				_gm_object = global.director_pool[_i].item;
			_lowest_cost = global.director_pool[_i].cost;
		}
	}
	
	global.director_balance -= _lowest_cost;
	return _gm_object;
}

function scr_spawn_random_breakable() {
	if(global.director_spawn_count < global.director_spawn_count_max) {		
		var _target_item = get_highest_cost_item();
		var _new_object = instance_create_layer(0, room_height - 64, "Instances", _target_item);
		
		_new_object.x = -abs(_target_item.sprite_width);	
		if(round(random(1)) == 0)
		{
			_new_object.x = display_get_width() + abs(_target_item.sprite_width);
			_new_object.image_xscale *= -1;
		}
		
		_new_object.y = room_height - 64 - (_new_object.starting_height_min + random(_new_object.starting_height_max - _new_object.starting_height_min));
		
		global.director_spawn_count++;
	}
	
	global.director_spawn_timer = current_time + random(2) * 1000 + 500;
}