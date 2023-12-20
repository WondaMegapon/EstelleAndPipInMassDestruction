/// @description Handling scrollable movement
// You can write your code in this editor

// Changing the position with the world delta.
x += global.world_width_scroll_delta;

// Wrapping the item around.
if (x > global.world_width / 2) x = -global.world_width / 2;
if (x < -global.world_width / 2) x = global.world_width / 2;

if (y > room_height + sprite_height) y = room_height + sprite_height;
if (y < -sprite_height) y = -sprite_height;