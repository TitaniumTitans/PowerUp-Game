void processClientMessage () {
  messages = newClient.readString().split("\n"); // just in case server recieves two messages at once
  for (int i = 0; i < messages.length && messages[i].length() > 0; i++) {
    println(messages[i]);
    if (messages[i].charAt(0) == '+') { // create a new robot:
      Robot robot = createRobot(messages[i].substring(1), random(width), random(height), random(TAU), newClient.ip());
      if (robot == null) { // if no more robots are allowed:
        newClient.write((byte)255); // tell the client
      } else {
        newClient.write((byte)robot.ID); // show the client that the server is ready with its robot!
        server.write(new byte[] { // tell the world!
          2, // protocol #2: robot added
          (byte)robot.ID,
          (byte)robot.name.length()
        });
        server.write(robot.name);
      }
    } else if (messages[i].charAt(0) == '-') { // remove a robot:
      int robotID = parseInt(messages[i].substring(1));
      if (validID(robotID)) {
        println("[[ " + robots[robotID].ownerIP + " Robot #" + robotID + " removed! ]]");
        if (removeRobot(robotID, newClient.ip())) {
          // tell the world:
          server.write(new byte[] {
            3, // protocol #3: robot deleted
            (byte)robotID
          });
        } else { // if the robot doesn't exist or isn't owned by the client:
          newClient.write("YOU CHEATING SCUM!"); // fair and square
        }
      }
    } else if (messages[i].charAt(0) == '@') { // request for list of robots
      int robotIDToSkip = parseInt(messages[i].substring(1));
      for (int i2 = 0; i2 < robots.length; i2++) {
        if (robots[i2] == null || i2 == robotIDToSkip) continue; // skip any removed robots or robots that are the one requested
        newClient.write(new byte[] {
          2, // protocol #2: robot added
          (byte)robots[i2].ID,
          (byte)robots[i2].name.length()
        });
        newClient.write(robots[i2].name);
      }
    } else { // press a key on the robot:
      message = messages[i].split(":");
        if (message.length == 2 && message[1].length() == 2) { // if message is correctly formatted:
        int robotID = parseInt(message[0]);
        if (validID(robotID)) {
          switch (message[1].charAt(1)) {
            case 'w':
              robots[robotID].upPressed = message[1].charAt(0) == '+';
              break;
            case 'a':
              robots[robotID].leftPressed = message[1].charAt(0) == '+';
              break;
            case 's':
              robots[robotID].downPressed = message[1].charAt(0) == '+';
              break;
            case 'd':
              robots[robotID].rightPressed = message[1].charAt(0) == '+';
              break;
          }
        } else {
          newClient.write("DAVID THIS IS NOT YOUR ROBOT!"); // tell him no
        }
      } else {
        newClient.write("YOU IDIOT!"); // that'll show him
      }
    }
  }
}
