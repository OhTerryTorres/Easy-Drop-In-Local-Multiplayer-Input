/// scr_ballStateDefault()

var tempFric;
if onGround {
    tempFric = groundFric;
} else {
    tempFric = airFric;
}


// Falling
vy = scr_approach(vy, vyMax, gravNorm);

// Check for ground
if onGround {
    vy = -bounce + weight;
    bounce = 0;

    // Start idle timer
    idleTimer -= 1;
    
} else {

    if vy > 0 {
        bounce = vy;
    }
    
    // Reset idle timer
    idleTimer = idleTimerMax;
}


// Horizontal collisions

if cLeft || cRight {
    show_debug_message("wall bounce");
    vx = -vx;
}

// Friction
vx = scr_approach(vx, 0, tempFric);

// Image angle
image_angle += -vx
