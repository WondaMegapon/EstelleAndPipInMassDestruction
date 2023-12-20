/// @description Insert description here
// You can write your code in this editor

draw_set_color(c_white);
var _squash_factor = 24;
draw_sprite_ext(sprite_index, -1, x, y, (exp(abs(momentum_x/_squash_factor)) + exp(-abs(momentum_x/_squash_factor))) / 2, (exp(-abs(momentum_y/_squash_factor)) + exp(abs(momentum_y/_squash_factor))) / 2, momentum_x * 2, c_white, 1);