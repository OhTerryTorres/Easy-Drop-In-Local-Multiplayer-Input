///scr_match_over()

instance_create(room_width/2, room_height/2, o_title);
o_title.text = "GOOD BOY, " + string(o_ball.owner.player.dog_name) + "!";
o_ball.owner.player.roundWins += 1;

show_debug_message("o_ball.owner.player.wins is " + string(o_ball.owner.player.roundWins));
show_debug_message("players[o_ball.owner.player.player_id].wins is " + string(players[o_ball.owner.player.player_id].roundWins));

alarm[3] = room_speed*3;
