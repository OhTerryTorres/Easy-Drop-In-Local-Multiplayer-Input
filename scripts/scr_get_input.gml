/// scr_get_input{port)

if argument0 == 0 {
    key_right = keyboard_check(vk_right);
    key_left = keyboard_check(vk_left);
    key_up = keyboard_check(vk_up);
    key_down = keyboard_check(vk_down);
    key_jump = keyboard_check_pressed(vk_space);
    key_jump_released = keyboard_check_released(vk_space);
    xaxis = (key_right - key_left);
    yaxis = (key_down - key_up);
}


if (gamepad_is_connected(0)) {
    if argument0 == 1 {
        gamepad_set_axis_deadzone(0, .4);
        key_left = gamepad_button_check(0, gp_padl);
        key_right = gamepad_button_check(0, gp_padr);
        key_up = gamepad_button_check(0, gp_padu);
        key_down = gamepad_button_check(0, gp_padd);
        key_jump = gamepad_button_check_pressed(0,gp_face1);
        key_jump_released = gamepad_button_check_released(0, gp_face1);
        xaxis = (key_right - key_left);
        yaxis = (key_down - key_up);
    } 
}
