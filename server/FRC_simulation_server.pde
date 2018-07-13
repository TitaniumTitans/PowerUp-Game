/*
  Ethan A. Black
  
  Server for the FRC simulation.
*/

import processing.net.*;

Server server;
//ArrayList<Client> clients = new ArrayList<Client> ();
Client newClient;
String[] message;
String[] messages;

Robot[] robots = new Robot[20];
void setup() {
  size(800, 500);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  noSmooth();
  
  server = new Server(this, 10002);
}

void draw () {
  background(230);
  stroke(random(255), random(255), random(255));
  for (int i = 0; i < robots.length; i++) {
    if (robots[i] == null) continue; // skip any removed robots
    robots[i].physics();
    robots[i].draw();
  }
  
  if ((newClient = server.available()) != null) { // '=' on purpose
    messages = newClient.readString().split("\n"); // just in case server recieves two messages at once
    for (int i = 0; i < messages.length && messages[i].length() > 0; i++) {
      println(messages[i]);
      if (messages[i].length() == 0) continue;
      if (messages[i].charAt(0) == '+') { // create a new robot:
        Robot robot = createRobot(messages[i].substring(1), random(width), random(height), random(TAU), newClient.ip());
        if (robot == null) { // if no more robots are allowed:
          newClient.write(new byte[] {(byte)255}); // tell the client
        } else {
          newClient.write(new byte[] {(byte)(robot.ID)}); // show the client that the server is ready!
        }
      } else if (messages[i].charAt(0) == '-') { // remove a robot:
        int robotID = parseInt(messages[i].substring(1));
        if (validID(robotID)) {
          println("[[" + robots[i].ownerIP + " Robot #" + robotID + " removed! ]]");
          if (removeRobot(robotID, newClient.ip())) {
            newClient.write("-"); // tell it that it's robot has been removed.
          } else {
            newClient.write("Meanie!");
          }
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
}

Robot createRobot (String name, float x, float y, float r, String IP) {
  for (int i = 0; i < robots.length; i++) {
    if (robots[i] == null) {
      robots[i] = new DropCenterRobot(name, i, x, y, r);
      robots[i].ownerIP = IP;
      return robots[i];
    }
  }
  return null; // no more room for robots!
}

boolean removeRobot (int ID, String IP) { // returns false if this is NOT your robot, or the specified robot couldn't be found
  for (int i = 0; i < robots.length; i++) {
    if (robots[i] != null && robots[i].ID == ID && robots[i].ownerIP.equals(IP)) {
      robots[i] = null;
      return true;
    }
  }
  return false;
}

boolean validID (int robotID) {
  return robotID < robots.length && robotID >= 0 && robots[robotID] != null && robots[robotID].ownerIP.equals(newClient.ip());
}