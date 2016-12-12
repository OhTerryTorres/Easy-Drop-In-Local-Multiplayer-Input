/// scr_approach(start, end, shift);

if (argument0 < argument1)
    return min(argument0 + argument2, argument1); 
else
    return max(argument0 - argument2, argument1);
    
    
    // Suppose we this script is being called to decide how fast
    // the player should fall.
    // At first, may have just started falling with a slow speed.
    //          14,             18,      .7
    // Since the 14 is lower than 18, the shift will be added to the fomer.
    //          14.7,           18
    // And then the lowest value is returned: 5.7.
    // This will keep happening until we hit 18, the maximum fall speed.
    //          15.4,           18
    //          16.1,           18
    //          16.8,           18
    //          17.5,           18
    //          18.2,           18
    // Finally, in this case, 18.2 is higher than 18.
    // As a result, 18 is returned.
    // This is a great way to deal with fine-tuned acceleration.
