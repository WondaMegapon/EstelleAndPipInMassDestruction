/// @description Insert description here
// You can write your code in this editor

var _estelle_angle = point_direction(x, y, obj_char_estelle.x, obj_char_estelle.y);
image_angle = lerp(image_angle, _estelle_angle, 0.02);

x += lengthdir_x(9, image_angle);
y += lengthdir_y(9, image_angle);

// Inherit the parent event
event_inherited();

