///scr_createPlayers
// Assign dog to player based on dog_index passed from menu to game. Phew!

var i;
    var xx = 0;
    var yy = 0;
    
    for (i = 0; i < array_length_1d(slots); i += 1) {
        if slots[i] != noone {
            switch i {
                case 0:
                    xx = o_placeholder_0.x;
                    yy = o_placeholder_0.y;
                    break;
                case 1:
                    xx = o_placeholder_1.x;
                    yy = o_placeholder_1.y;
                    break;
                case 2:
                    xx = o_placeholder_2.x;
                    yy = o_placeholder_2.y;
                    break;
                case 3:
                    xx = o_placeholder_3.x;
                    yy = o_placeholder_3.y;
                    break;
                default:
                    break;
            }
            
            player = instance_create(xx, yy, scr_dogForIndex(slots[i].dogIndex));
            player.input = instance_create(0, 0, o_input);
            player.slotIndex = i;
            player.input.type = slots[i].inputType;
            show_debug_message("player.input.name is " + string(player.input.name))
        }
        
    }
