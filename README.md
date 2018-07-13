# Protocol

### TL;DR:
**The standard protocol is `+ROBOT_ID\n` for connecting to robots, and `ROBOT_ID:KEY\n` for changing keys.**

**E.g. `0:+w` will turn on w on robotID 0**

**(Newline is manditory)**

### To press a key, send `id:+key\n`
This will register in the server as this key being held down indefinently.

### To release a key, send `id:-key\n`
This will register in the server as this key no longer being held down.

### To create a robot, send `+ROBOT_ID\n`
The server will send back the ID of the new robot (Unsigned Short); ID 255 means the maximum amount of robots has been reached.

### To remove a robot, send `-ROBOT_ID\n`
The server will send back a `-`, at which point the client may leave.
