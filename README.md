# Outdated, archaic Protocols.

## Client-to-server Protocol

### TL;DR:
**The standard protocol is `+ROBOT_ID\n` for creating robots, and `ROBOT_ID:KEY\n` for changing keys.**

**E.g. `0:+w` will turn on w on robotID 0**

**(Newline is manditory)**

### To press a key, send `id:+key\n`
This will register in the server as this key being held down indefinently.

### To release a key, send `id:-key\n`
This will register in the server as this key no longer being held down.

### To create a robot, send `+ROBOT_ID\n`
The server will send back the ID of the new robot (byte), starting at 1. ID 255 means the maximum amount of robots has been reached. The server associates the client's IP address with the new robot. Only clients with the associated IP have access to that robot.

### To remove a robot, send `-ROBOT_ID\n`
The server will send back a `-`, at which point the client may leave.

### To request the background image, send `{`
The server will send you the image.

## Server-to-client protocol \[OUTDATED!\]

"+ROBOT_ID:ROBOT_NAME\n" means that the server registered a new robot named ROBOT_NAME.
"-ROBOT_ID\n" means that the server removed robot ROBOT_ID.

"@ROBOT_ID:X:Y:DEGREES\n" means that robot ROBOT_ID is now positioned at 4_BYTE_X, 4_BYTE_Y, and rotated at 1_BYTE_DEGREES.

"{4_BYTE_WIDTH4_BYTE_COLOR4_BYTE_COLOR"..."4_BYTE_COLOR}\n" - the background image.
