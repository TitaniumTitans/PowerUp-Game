/*
  Made by Ethan A. Black.

  Main script for the FRC Simulation System.
  
  TODO: prevent illegal robot names from being accepted (like ones with colons in it).
*/

import processing.net.*;

Server server;
Client newClient;
String[] message;
String[] messages;

final int writeFrequency = 100; // robot positions get broadcasted ten times/second (otherwise, horrific lag happens when many clients connects)
int writeTimer; // holds when the robot positions should be broadcasted next, in milliseconds.

Robot[] robots = new Robot[20];
void setup () {
  size(800, 500, P2D);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  noSmooth();
  frameRate(1000); // a.k.a. don't slow down!

  server = new Server(this, 10002);
}

void draw () {
  background(0);
  stroke(255);
  
  if (millis() > writeTimer) {
    writeTimer = millis() + writeFrequency;
    processRobots(true);
  } else {
    processRobots(false);
  }

  if ((newClient = server.available()) != null) { // '=' on purpose
    processClientMessage();
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
