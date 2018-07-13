## Protocol

# `robotID:keyAndPressedOrReleased\n`
(Newline is manditory)

Where:
`robotName` is the name of the robot whose key you want to press;
`key` is the key to press on the robot, with a ‘+’ before it if the key just got pressed, and a ‘-’ if the 
key just got released.

# E.g. `0:+w` will turn on w on robotID 0

To create a robot, send `+ROBOT_NAME`
The server will send back the ID of the new robot (Unsigned Short); ID 255 means the maximum amount of robots has been reached.

To remove a robot, send `-ROBOT_NAME`
The server will send back a `-`, at which point the client may leave.
