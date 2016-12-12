/// scr_platformCheck();

// Check if entity has collide with anything, above or below
var collision = instance_place(x, y + sign(vy), o_solid); 

if (collision) {
    
    if (vy >= 0) { // Below
    
        platformTarget = collision;
        // as far as I know, now platformTarget is now equal ot the platform
        // which is weird as it was initialized as 0...
        // so it COULD also equal 1 now??
        // I guess the new number assigne to platformTarget is its object ID?
        
    } else { // Above
        vy = 0;  // Stop the entity from rising or falling
    }
    
    return true;
}

if (vy < 0) { // Entity is airborne and not touching any solid
    platformTarget = 0; // anull any previous platform that was memorized
}

// These two IF conditions could be necessary for dealing with old remembered platform targets
// or maybe if platforms can someone be destroyed?
if (instance_exists(platformTarget)) { // Verifiying platform with object ID exists
    if (platformTarget) {
        
        if (place_meeting(x, y + 1, platformTarget) && !place_meeting(x, y, platformTarget)) {
            // Landing on platform and NOT droppiong through a passable platform?
            vy = 0;
            return true;
        } else
            platformTarget = 0;
    }
} else
    platformTarget = 0;
    
//
if (vy > 0) {
    with (o_entityParent) {
        {
            if (place_meeting(x, y - 1, other) && !place_meeting(x, y, other)) {
                vy = 0;
            }
        }
    }
}

// By default, the assumption is the player is airborn, until they're not
platformTarget = 0;
return false;

