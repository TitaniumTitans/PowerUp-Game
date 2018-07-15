package org.titaniumtitans.game;
import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 
import processing.net.*; 
import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class server extends PApplet {
	Server server;
	Client newClient;
	String[] message;
	String[] messages;
	Robot[] robots = new Robot[20];
	public void setup() {
		rectMode(CENTER);
		textAlign(CENTER, CENTER);
		server = new Server(this, 10002);
	}
	public void draw () {
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
							newClient.write("-"); // tell the client that its robot has been removed.
						} else { // if the robot doesn't exist or isn't owned by the client:
							newClient.write("YOU CHEATING SCUM!"); // fair and square
						}
					}
				} else { // press a key on the robot:
					message = messages[i].split(":");
						if (message.length == 2 && message[1].length() == 2) { // if message is correctly formatted:
						int robotID = parseInt(message[0]);
						if (validID(robotID)) {
							switch (message[1].charAt(1)) {
								case 'w': robots[robotID].upPressed = message[1].charAt(0) == '+'; break;
								case 'a': robots[robotID].leftPressed = message[1].charAt(0) == '+'; break;
								case 's': robots[robotID].downPressed = message[1].charAt(0) == '+'; break;
								case 'd': robots[robotID].rightPressed = message[1].charAt(0) == '+'; break;
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
	public Robot createRobot (String name, float x, float y, float r, String IP) {
		for (int i = 0; i < robots.length; i++) {
			if (robots[i] == null) {
				robots[i] = new DropCenterRobot(name, i, x, y, r);
				robots[i].ownerIP = IP;
				return robots[i];
			}
		}
		return null; // no more room for robots!
	}
	public boolean removeRobot (int ID, String IP) { // returns false if this is NOT your robot, or if the specified robot couldn't be found
		for (int i = 0; i < robots.length; i++) {
			if (robots[i] != null && robots[i].ID == ID && robots[i].ownerIP.equals(IP)) {
				robots[i] = null;
				return true;
			}
		}
		return false;
	}
	public boolean validID (int robotID) {
		return robotID < robots.length && robotID >= 0 && robots[robotID] != null && robots[robotID].ownerIP.equals(newClient.ip());
	}
	abstract class Robot {
		public Robot (String name, int ID, float x, float y, float r) {
			this.name = name;
			this.ID = ID;
			this.x = x;
			this.y = y;
			this.r = r;	
			speed = 10;
		}
		String name;
		int ID;
		float x, y;
		float xv, yv;
		float r; // rotation in degrees
		float rv; // rotation velocity
		float speed; // how many pixels per frame
		float resistance = 0.925f;
		boolean leftPressed;
		boolean rightPressed;
		boolean upPressed;
		boolean downPressed;
		String ownerIP; // David-proofing	
		public abstract void physics ();
		public void draw () {
			pushMatrix();
			translate(x, y);
			rotate(r);
			noFill();
			rect(0, 0, 30, 70);
			rotate(-HALF_PI);
			fill(0);
			text(name, 0, -2);
			popMatrix();
		}
	}
	class DropCenterRobot extends Robot {
		public DropCenterRobot (String name, int ID, float x, float y, float r) {
			super(name, ID, x, y, r);
			speed = 10;
		}
		float rSpeed = 0.5f; // radians per frame
		float rResistance = 0.9f;
		public void physics () {
			if (leftPressed ^ rightPressed) {
				if (leftPressed) {
					rv -= rSpeed / frameRate;
				}
				if (rightPressed) {
					rv += rSpeed / frameRate;
				}
			}
			if (upPressed ^ downPressed) {
				if (upPressed) {
					xv += sin(r) * speed / frameRate;
					yv -= cos(r) * speed / frameRate;
				}
				if (downPressed) {
					xv -= sin(r) * speed / frameRate;
					yv += cos(r) * speed / frameRate;
				}
			}
			xv *= resistance;
			yv *= resistance;
			rv *= rResistance;
			x = constrain(x + xv, 0, width);
			y = constrain(y + yv, 0, height);
			r += rv;
		}
	}
	public void settings() {
		size(800, 500);
		noSmooth();
	}
	static public void main(String passedArgs[]) {
		String[] appletArgs = new String[] {"server"};
		if (passedArgs != null) {
			PApplet.main(concat(appletArgs, passedArgs));
		} else {
			PApplet.main(appletArgs);
		}
	}
}
