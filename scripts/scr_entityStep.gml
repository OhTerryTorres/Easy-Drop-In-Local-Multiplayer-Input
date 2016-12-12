/// scr_entityStep()


jumped = false;
landed = false;

if (vy < 1 && vy > -1) // Entity has stopped or nearly stopped
    scr_platformCheck(); // Get the id of the platform the entity has landed on,
                         // and make sure that the entity has come to a full stop.
                         // The script also returns a BOOL, but it looks like
                         // it can be ignored if desired. Pretty clever.
else // Entity is rising or falling
    repeat(abs(vy)) { // Repeat for the absolute value of vertical speed.
                      // (That means negative value will run as positive)
                      // That means this code will not run if the entity is STILL.
        if (!scr_platformCheck()) // Entity has not collided with a platform.
            y += sign(vy); // Move the entity one step in the direction it's travelling.
                           // It seems the point of repeating this code is to
                           // allow for tighter control on platforming.
        else // End the repeat loop once a platform is hit.
            break; 
    }

    
// Still trying to figure this next one out.
// First we check to see if the Entity is traveling in the direction of a platform
// Then we check to see if the Entity has "landed"
// Whether or not they have, the platform stops the movement of whatever
// just collided with it.
// This basically seems to be end the process of "landing".
// 1) Identify platform on entity's route, 2) confirm the entity landed.

if (platformTarget) {
    if (!onGround) 
        landed = true;
    
    if (landed)
        with (platformTarget) other.vy = 0;
    else
        with (platformTarget) other.vy = 0;
}

// Finally, we move on to horizontal movement.


repeat(abs(vx)) {
    
    // These two conditions seem to deal with  ramps?
    // Going up, if there is something solid directly in your path, but not above it.
    if (place_meeting(x + sign(vx), y, o_solid) && !place_meeting(x + sign(vx), y - 1, o_solid))
        y -= 1;
         
    // Going down, if there is something solid under you, but not immediatel under you?
    if (place_meeting(x + sign(vx), y + 2, o_solid) && !place_meeting(x + sign(vx), y + 1, o_solid))
        y += 1;
    
    // If there is nothing solid in the way, move in that direction.
    if (!place_meeting(x + sign(vx), y, o_solid))
        x += sign(vx);
        
    // *** The ball kept stopping when it hit the wall.
    // Now that this is commented out, it bounces properly.
    // Keep an eye out for if this causes problems in the future.
    // Hopefully it's just redundant.
    //else
        //vx = 0;
}
