///scr_getInputFromType()

var deadzone = 0.8;

switch type {
    case INPUT_ARROWS:
        up = keyboard_check(vk_up);
        down = keyboard_check(vk_down);
        left = keyboard_check(vk_left);
        right = keyboard_check(vk_right);
        
        upPressed = keyboard_check_pressed(vk_up);
        downPressed = keyboard_check_pressed(vk_down);
        leftPressed = keyboard_check_pressed(vk_left);
        rightPressed = keyboard_check_pressed(vk_right);
        
        upReleased = keyboard_check_released(vk_up);
        downReleased = keyboard_check_released(vk_down);
        leftReleased = keyboard_check_released(vk_left);
        rightReleased = keyboard_check_released(vk_right);
        
        name = "KEYS"
        break;
    case INPUT_WASD:
        up = keyboard_check(ord('W'));
        down = keyboard_check(ord('S'));
        left = keyboard_check(ord('A'));
        right = keyboard_check(ord('D'));
        
        upPressed = keyboard_check_pressed(ord('W'));
        downPressed = keyboard_check_pressed(ord('S'));
        leftPressed = keyboard_check_pressed(ord('A'));
        rightPressed = keyboard_check_pressed(ord('D'));
        
        upReleased = keyboard_check_released(ord('W'));
        downReleased = keyboard_check_released(ord('S'));
        leftReleased = keyboard_check_released(ord('A'));
        rightReleased = keyboard_check_released(ord('D'));
        
        name = "WASD"
        break;
    case INPUT_GAMEPAD:
        if gamepad_is_connected(port) {
            gamepad_set_axis_deadzone(port, deadzone);
            
            upPressed = ( gamepad_axis_value(port, gp_axislv) < 0 && lastyaxis == 0 )
            || gamepad_button_check_pressed(port, gp_padu);
            downPressed = ( gamepad_axis_value(port, gp_axislv) > 0 && lastyaxis == 0 )
            || gamepad_button_check_pressed(port, gp_padd);
            leftPressed = ( gamepad_axis_value(port, gp_axislh) < 0 && lastxaxis == 0 )
            || gamepad_button_check_pressed(port, gp_padl);
            rightPressed = ( gamepad_axis_value(port, gp_axislh) > 0 && lastxaxis == 0 )
            || gamepad_button_check_pressed(port, gp_padr);
            
            up = gamepad_axis_value(port, gp_axislv) < 0 && lastyaxis < 0 || gamepad_button_check(port, gp_padu);
            down = gamepad_axis_value(port, gp_axislv) > 0 && lastyaxis > 0 || gamepad_button_check(port, gp_padd);
            left = gamepad_axis_value(port, gp_axislh) < 0 && lastxaxis < 0 || gamepad_button_check(port, gp_padl);
            right = gamepad_axis_value(port, gp_axislh) > 0 && lastxaxis > 0 || gamepad_button_check(port, gp_padr);
           
            upReleased = ( gamepad_axis_value(port, gp_axislv) == 0 && lastyaxis < 0 ) 
            || gamepad_button_check_released(port, gp_padu);
            downReleased = ( gamepad_axis_value(port, gp_axislv) == 0 && lastyaxis > 0 ) 
            || gamepad_button_check_released(port, gp_padd);
            leftReleased = ( gamepad_axis_value(port, gp_axislh) == 0 && lastxaxis < 0 )
            || gamepad_button_check_released(port, gp_padl);
            rightReleased = ( gamepad_axis_value(port, gp_axislh) == 0 && lastxaxis > 0 ) 
            ||  gamepad_button_check_released(port, gp_padr);
            
            lastxaxis = gamepad_axis_value(port, gp_axislh)
            lastyaxis = gamepad_axis_value(port, gp_axislv)
            
            name = "PAD" + string(port);
        } else {
            instance_destroy();
        }
        break;
    default:
        break;
}


