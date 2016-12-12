# Easy-Local-Multiplayer-Input
This small game makes use of a Smash Bros-esque character select screen, allowing players to push a button on any controller (or keyboard) currently connected to the PC to join the game.

This is done by relying on a series of objects working together.
<ul>
<li>a ubiquitous <b>game</b> object to act as listener and controller (which is Persistent)
<li>a <b>slot</b> object use by the game object to receive and store information for each player (also Persistent)
<li>an <b>input</b> object that assigns key/button presses based on the type of controller
<li>a <b>menu</b> object that reads every possible input
<li>a <b>selector</b> object whose instances correspond to each player
<li>finally, your <b>player</b> object, which your players actually control
</ul>

We'll look at the input and slot objects first. In <b>o_input</b>'s Create event is this code:

```  
/// Intialize input

// by default we'll have the arrow keys as a placeholder
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

// Assigned a new value when handed over to a player's character selector
slot = -1;

// For gamepads
port = -1;
lastxaxis = noone;
lastyaxis = noone;


type = INPUT_ARROWS; // 0
assigned = false; // keeps splitting one input between multiple players
```  

By default, <b>o_input</b> is assigned the keyboar arrows. However, the Step event changes this layout depending on how the object's <b>type</b> is set:

``` 
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


``` 

The <b>o_slot</b> object will solely be used as an organized method of storing the correct information for the appropriate player in the main game object. Its Create event is as so:

``` 
/// Intialize player slot

inputIndex = -1;
inputType = -1;
characterIndex = -1;

// Gameplay-centric information
roundWins = 0;
matchWins = 0;
``` 

Now let get down to the actual order of events.

The first room of this project is the character selection screen. There are only two objects in the room to begin with. The first is <b>o_game</b>, whose Create event includes this code:

```    
if (instance_number(o_game) > 1)
    instance_destroy();
slots[0] = noone;
slots[1] = noone;
slots[2] = noone;
slots[3] = noone;
```

The event that does most of the work on this screen, however, is <b>o_menuCharacterSelect</b> (or <b>o_menu</b> for short). Its Create event prepare a potential character selector object for each player. It also stores every possible input.

```
/// Initialize menu and all available inputs

characterSelectors[0] = noone;
characterSelectors[1] = noone;
characterSelectors[2] = noone;
characterSelectors[3] = noone;

inputs[0] = noone;
inputs[1] = noone;
inputs[2] = noone;
inputs[3] = noone;
inputs[4] = noone;
inputs[5] = noone;

inputArrows = instance_create(0,0,o_input);
inputArrows.type = INPUT_ARROWS
inputArrows.inputIndex = 0;
inputs[0] = inputArrows;

inputWASD = instance_create(0,0,o_input);
inputWASD.type = INPUT_WASD
inputWASD.inputIndex = 1;
inputs[1] = inputWASD;

if gamepad_is_connected(0) {
    inputGamepad0 = instance_create(0,0,o_input);
    inputGamepad0.type = INPUT_GAMEPAD
    inputGamepad0.lastxaxis = gamepad_axis_value(0, gp_axislh)
    inputGamepad0.lastyaxis = gamepad_axis_value(0, gp_axislv)
    inputGamepad0.port = 0;
    inputGamepad0.inputIndex = 2;
    inputs[2] = inputGamepad0;
}

if gamepad_is_connected(1) {
    inputGamepad1 = instance_create(0,0,o_input);
    inputGamepad1.type = INPUT_GAMEPAD
    inputGamepad1.lastxaxis = gamepad_axis_value(1, gp_axislh)
    inputGamepad1.lastyaxis = gamepad_axis_value(1, gp_axislv)
    inputGamepad1.port = 1;
    inputGamepad1.inputIndex = 3;
    inputs[3] = inputGamepad1;
}

if gamepad_is_connected(2) {
    inputGamepad2 = instance_create(0,0,o_input);
    inputGamepad2.type = INPUT_GAMEPAD
    inputGamepad2.lastxaxis = gamepad_axis_value(2, gp_axislh)
    inputGamepad2.lastyaxis = gamepad_axis_value(2, gp_axislv)
    inputGamepad2.port = 2;
    inputGamepad2.inputIndex = 4;
    inputs[4] = inputGamepad2;
}

if gamepad_is_connected(3) {
    inputGamepad3 = instance_create(0,0,o_input);
    inputGamepad3.type = INPUT_GAMEPAD
    inputGamepad3.lastxaxis = gamepad_axis_value(3, gp_axislh)
    inputGamepad3.lastyaxis = gamepad_axis_value(3, gp_axislv)
    inputGamepad3.port = 3;
    inputGamepad3.inputIndex = 5;
    inputs[5] = inputGamepad3;
}
```

In order to add new gamepads when they are connected, the <i>gamepad_is_connected</i> conditionals are repeated in a code action in the Step event.

In an additional code action in the Step event, we do the important work of listening to every potential input and create a selector object corresponding to it. (We also set up conditions that will allow the game to begin once all characters are chosen)

```
/// Control character selector appearance and round begin

var activeSelectors = 0;
var confirmations = 0;

// Tally confirmations
var i;
for (i = 0; i < array_length_1d(characterSelectors); i += 1) {
     if characterSelectors[i] != noone {
         activeSelectors += 1;
         //show_debug_message("activeSelectors is " + string(activeSelectors));
         if instance_exists(characterSelectors[i]) {
            if characterSelectors[i].confirmed = true {
                //show_debug_message("confirmations is " + string(confirmations));
                confirmations += 1;
            }
         } 
     }
}


// Create confirm indicator
if confirmations == activeSelectors && activeSelectors > 0 {
    if !instance_exists(o_confirmIndicator) {
        instance_create(0,0,o_confirmIndicator);
    }
} else {
    if instance_exists(o_confirmIndicator) {
        with o_confirmIndicator {
            instance_destroy();
        }
    }
}

// Add Character Selectors
var ii;
for (ii = 0; ii < array_length_1d(inputs); ii += 1) { // for every input
    // if any button is pressed
    if inputs[ii] != noone {
        if (inputs[ii].upPressed || inputs[ii].downPressed || inputs[ii].leftPressed || inputs[ii].rightPressed ) {
            // check to see if the corresponding input can be assigned to a slot
            var iii;
           for (iii = 0; iii < array_length_1d(characterSelectors); iii += 1) {
                if characterSelectors[iii] == noone && inputs[ii].assigned == false {
                
                    show_debug_message("assigning " + string(inputs[ii].name) + " to slot " + string(ii));
                    // Create Character Selector
                    characterSelectors[iii] = instance_create(0,0,o_characterSelector);
                    characterSelectors[iii].slot = iii;
                    characterSelectors[iii].input = inputs[ii];
                    characterSelectors[iii].input.slot = iii;
                    inputs[ii].assigned = true;
                    characterSelectors[iii].inputIndex = ii;
                    break;
                }
                if characterSelectors[iii] == noone {
                    show_debug_message("Slot " + string(iii) + " is empty");
                } else {
                    show_debug_message("Slot " + string(iii) + " has input " + string(characterSelectors[iii].input.name) + " Port: " + string(characterSelectors[iii].input.port) + " InputIndex: " + string(ii));
                }
            }
        }
    }  
}
```

That brings us to the object that any player will actually be controlling on this screen: <b>o_characterSelector</b>. Its Create event:

```
/// Initialize character selector

show_debug_message("Character Selector created!");

slot = -1;
input = noone;
inputIndex = -1; // used to access the right index in o_menuCharacterSelect.inputs
characterIndex = 0
confirmed = false;

matchWins = 0; // gameplay variable
```

Its Step and Draw GUI events together control the display and selection of playable characters. Step:

```
/// Control character selector input

var keyPressed = "";

if input != noone {

    if input.leftPressed && !confirmed {
        characterIndex -= 1;
    }
    if input.rightPressed && !confirmed {
        characterIndex += 1;
    }
    
    if input.upPressed {
       confirmed = true;
    }
    
    if input.downPressed {
       if confirmed {
        confirmed = false;
       } else {
        instance_destroy();
       }
    }
    
}

if characterIndex < 0 {
    characterIndex = NUM_CHARACTERS - 1;
}
if characterIndex > NUM_CHARACTERS - 1 {
    characterIndex = 0;
}
```

Draw GUI:

```
/// Draw the character selector

switch slot {
    case 0:
        draw_set_colour(c_red);
        break;
    case 1:
        draw_set_colour(c_blue);
        break;
    case 2:
        draw_set_colour(c_yellow);
        break;
    case 3:
        draw_set_colour(c_green);
        break;
    default:
        break;
}

// Selectors will take up a quarter of the screen
// and be positioned based on their slot
var xx = display_get_gui_width()*.12 + (slot * display_get_gui_width()/4 );
var yy = display_get_gui_height()*.5;

// Draw name
draw_set_halign(fa_center);
draw_text(xx, yy-64, scr_nameForIndex(characterIndex));

// Draw sprite
draw_sprite(scr_spriteForIndex(characterIndex), image_index, xx, yy);

// Draw info
var info =""
switch input.type {
    case INPUT_WASD:
        info = 
        "A and D to choose
W to confirm
S to drop out";
        break;
    default:
        info = 
        "LEFT and RIGHT to choose
UP to confirm
DOWN to drop out";
        break;
}
draw_text(xx, yy+64, info);

// Draw CONFIRM

if confirmed {
    draw_text(xx, yy-128, "READY!");
}

if matchWins > 0 {
    draw_text(xx, yy+128, "WINS: " + string(matchWins));
}


draw_set_colour(c_white);
draw_set_halign(fa_left);
```

You'll see executions for scripts <b>nameForIndex</b> and <b>spriteForIndex</b>. The content of these will depend on your game, but this is the idea for each:

```
///scr_nameForIndex(index)

switch(argument0) {
    case 0:
        return "BROTHER"
        break;
    case 1:
        return "SUNNY"
        break;
    case 2:
        return "MAESTRO"
        break;
    case 3:
        return "NINA"
        break;
    default:
        break;
}
```
```
///scr_spriteForIndex(index)

switch(argument0) {
    case 0:
        return s_brother_right
        break;
    case 1:
        return s_sunny_right
        break;
    case 2:
        return s_maestro_right
        break;
    case 3:
        return s_nina_right
        break;
    default:
        break;
}
```

In <b>o_characterSelector</b>, pressing Down cancels your selection and destroys the object instance. In this case, its important to let <b>o_menu</b> know that the appropriate input is not free to assign to a new player. That's why this is in the Destroy event:

```
/// Anull inputs and slots

show_debug_message("dropping " + string(input.name) + " from slot " + string(slot));
if instance_exists(o_menuCharacterSelect) {
    o_menuCharacterSelect.inputs[inputIndex].assigned = false;
    o_menuCharacterSelect.characterSelectors[slot] = noone;
}
```

In the case that every player confirms their choice, <b>o_menu</b> will create <b>o_confirmIndicator</b> which is used to start the match. It's possible to simply have this code executed in <b>o_menu</b>, but the division of labor seemed cleaner. <b>o_confirmIndicator</b>'s Create event is merely used to make sure that a player's button press to choose a character is not also used to start the game, which can be jarring:

```
alarm[0] = room_speed / 10;
```

The Step event checks to see if any player hits the confirmation button (Up, in this case) before starting your game:

```
/// Begin match on UP button press
if alarm[0] <= 0 {
    
    if instance_exists(o_menuCharacterSelect) {
        var i;
        for (i = 0; i < array_length_1d(o_menuCharacterSelect.characterSelectors); i += 1) {
            if instance_exists(o_menuCharacterSelect.characterSelectors[i]) && o_menuCharacterSelect.characterSelectors[i] != noone {
                if o_menuCharacterSelect.characterSelectors[i].input.upPressed {
                    // BEGIN MATCH!
                    room_goto_next();
                }
            }
        }
    }
}
```

And now for the dismount! Here is <b>o_game</b>'s Room End event, using a condition for the character select screen.

/// Character Select Room: Create player slots

```
if room == room_start {
    if instance_exists(o_menuCharacterSelect) {
        var i;
        for ( i = 0; i < array_length_1d(slots); i += 1 ) {
            if o_menuCharacterSelect.characterSelectors[i] != noone {
                var oldMatchWins = 0;
                if slots[i] != noone {
                    oldMatchWins = slots[i].matchWins;
                }
                slots[i] = instance_create(0,0,o_slot);
                slots[i].inputIndex = o_menuCharacterSelect.characterSelectors[i].inputIndex;
                slots[i].inputType = o_menuCharacterSelect.characterSelectors[i].input.type;
                slots[i].characterIndex = o_menuCharacterSelect.characterSelectors[i].characterIndex;
                slots[i].matchWins = oldMatchWins;
                show_debug_message("slots[" + string(i) + "].inputType is " + string(slots[i].inputType));
                show_debug_message("slots[" + string(i) + "].characterIndex is " + string(slots[i].characterIndex));
            } else {
                slots[i] = noone;
            }   
        }   
    }
}
```

And <b>o_game</b>'s Room Start event creates every player instance based on the information in its slots array.

```
/// Game Room: Set up round

if room != room_start && room != room_results {
  // Assign character to player based on characterIndex passed from menu to game
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

              player = instance_create(xx, yy, scr_characterForIndex(slots[i].characterIndex));
              player.input = instance_create(0, 0, o_input);
              player.slotIndex = i;
              player.input.type = slots[i].inputType;
              show_debug_message("player.input.name is " + string(player.input.name))
          }

      }
}
```

In this case, <b>characterForIndex</b> returns an object corresponding to each playable character in your game.

```
///scr_characterForIndex(index)

switch(argument0) {
    case 0:
        return o_brother
        break;
    case 1:
        return o_sunny
        break;
    case 2:
        return o_maestro
        break;
    case 3:
        return o_nina
        break;
    default:
        break;
}
```


<u>Known Issues</u><br>
Currently, if a gamepad is disconnected, the game is unable to tell. So, uh... don't let that happen.
