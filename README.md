# Easy-Local-Multiplayer-Input
This small game makes use of a Smash Bros-esque character select screen, allowing players to push a button on any controller (or keyboard) currently connected to the PC to join the game.

This is done by relying on a series of objects working together.
<ul>a ubiquitous <b>game</b> object to act as listener and controller
an <b>input</b> object that assigns key/button presses based on the type of controller
a <b>menu</b> object that reads every possible input
a <b>selector</b> object whose instances correspond to each player
a <b>slot</b> object use by the game object to received information for each player

</ul>
