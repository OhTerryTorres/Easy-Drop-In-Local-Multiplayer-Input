///state_game_active()


if instance_exists(o_ball) {

    // Timer over if ball is idle
    if o_ball.idle_timer <= 0 {
        state = state_game_idle;
        scr_time_over();
    }
    
    // Ball is out of bounds
    if o_ball.x > room_width or o_ball.x < 0 or o_ball.y > room_height {
        state = state_game_idle;
        scr_time_over();
    }
    
    // Ball is out caught
    if o_ball.owner != noone {
        state = state_game_idle;
        scr_match_over();
    }
}

if room_get_name(room) == "room_start_menu" {
    state = state_game_menu;
}


