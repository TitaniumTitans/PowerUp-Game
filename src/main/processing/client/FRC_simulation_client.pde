/*
  Made by Ethan A. Black.

  Client for the FRC Simulation System.
*/

import processing.net.*;
import java.net.*;

Client me;
int[] message = new int[200]; // TODO: make buffer extend and shrink when needed

Robot[] robots = new Robot[20];

int robotID;
int currentRobotID; // temp var

void setup () {
  size(800, 500);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  noSmooth();
  
  me = new Client(this, "localhost", 10002); // that 96.236.201.172 IP address is my server. Use "localhost" if the server is running on the local host.
  
  // ask server to create new robot:
  try {
    me.write("+" + InetAddress.getLocalHost().getHostName() + "\n");
  } catch (java.net.UnknownHostException error) {
    me.write("+Unknown\n");
  }
  while (me.available() == 0) delay(100); // wait for server to create robot!
  robotID = me.read();
  if (robotID == 255) { // if server says that you're not allowed to make another robot:
    println("No more robots allowed!");
    super.exit(); // quit
    noLoop();
    return;
  }
  me.write('@' + str(robotID)); // request list of robots, except this one
}

void draw () {
  background(#7FCCF7); // nice sky-blue color
  for (int i = 0; i < robots.length; i++) {
    if (robots[i] == null) continue; // skip any removed robots
    robots[i].draw();
  }
  
  if (me.available() != 0) {
    switch (me.read()) {
      case 1: // robot position update
        for (int i = 0; i < 6; i++) {
          do {
            message[i] = me.read();
          } while (message[i] == -1);
        }
        currentRobotID = message[0];
        if (invalidID(currentRobotID)) {
          println("[Protocol #1]\tRobot " + currentRobotID + " invalid!");
          break;
        }
        robots[currentRobotID].x = message[1] | (message[2] << 8);
        robots[currentRobotID].y = message[3] | (message[4] << 8);
        robots[currentRobotID].r = map(message[5], 0, 255, -TAU, TAU);
        break;
      case 2: // new robot added:
        for (int i = 0; i < 2; i++) {
          do {
            message[i] = me.read();
          } while (message[i] == -1);
        }
        currentRobotID = message[0];
        if (currentRobotID < 0 || currentRobotID >= robots.length) {
          println("[Protocol #2]\tRobot " + currentRobotID + " invalid!");
          break;
        }
        Robot newRobot = (robots[message[0]] = new Robot("", message[0], 0, 0, 0.0));
        int currentByte;
        for (int i = 0; i < message[1]; i++) {
          do {
            currentByte = me.read();
          } while (currentByte == -1);
          newRobot.name = newRobot.name + (char)currentByte;
        }
        println("[Protocol #2]\tNew robot " + currentRobotID + " added: \"" + newRobot.name + "\"");
        break;
      case 3: // robot deleted:
        do {
          message[0] = me.read();
        } while (message[0] == -1);
        currentRobotID = message[0];
        if (invalidID(currentRobotID)) {
          println("[Protocol #3]\tRobot " + currentRobotID + " invalid!");
          break;
        }
        String robotName = robots[currentRobotID].name;
        robots[currentRobotID] = null;
        println("[Protocol #3]\tRobot " + currentRobotID + " removed: \"" + robotName + "\"");
        break;
      case 4: // background picture (NOT YET):
        
        break;
      default:
        println("INVALID PROTOCOL YEH DUMMY: \"" + message.toString() + "\"");
        break;
    }
  }
}

void keyPressed () {
  me.write(str(robotID) + ":+" + key + "\n");
}

void keyReleased () {
  me.write(str(robotID) + ":-" + key + "\n");
}

/*Robot createRobot (String name, int x, int y, float r) {
  for (int i = 0; i < robots.length; i++) {
    if (robots[i] == null) {
      robots[i] = new Robot(name, i, x, y, r);
      return robots[i];
    }
  }
  return null; // no more room for robots!
}*/

boolean removeRobot (int ID) { // returns false if the specified robot couldn't be found
  for (int i = 0; i < robots.length; i++) {
    if (robots[i] != null && robots[i].ID == ID) {
      robots[i] = null;
      return true;
    }
  }
  return false;
}

void exit() { // runs when window is closed:
  me.write("-" + robotID + "\n");
  /*while (me.available() == 0) {}
  if (!me.readString().equals("-")) {
    println("Error: server sent back something other than '-'!");
    me.stop(); // disconnect neatly
  }*/
  delay(300);
  me.stop();
  super.exit();
}
