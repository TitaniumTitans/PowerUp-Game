package org.titaniumtitans.game;
import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 
import processing.net.*; 
import java.net.InetAddress; 
import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class client extends PApplet {
	private Client user;
	private int robotID;
	private static Thread thread;
	private static String[] args;
	public void setup () {
		user = new Client(this, "localhost", 10002);
		// Request the creation of a new robot:
		try {
			user.write("+" + InetAddress.getLocalHost().getHostName() + "\n");
		} catch (java.net.UnknownHostException error) {
			user.write("+unknown\n");
		}
		while (user.available() == 0) {}
		robotID = user.read();
		if (robotID == 255) {
			println("The server has hit the maximum quantity of robots allowed.");
			super.exit(); // quit
		}
	}
	public void draw () {
		
	}
	public void keyPressed () {
		user.write(str(robotID) + ":+" + key + "\n");
	}
	public void keyReleased () {
		user.write(str(robotID) + ":-" + key + "\n");
	}
	// Runs upon exit:
	public void exit() {
		user.write("-" + robotID);
		while (user.available() == 0) {}
		if (!user.readString().equals("-")) {
			println("Error: Server sent invalid confirmation. Forcing disconnect.");
			// Exit
			user.stop();
		}
		super.exit();
	}
	public static void main(String passedArgs[]) {
		String[] appletArgs = new String[] {"client"};
		if (passedArgs != null) {
			PApplet.main(concat(appletArgs, passedArgs));
		} else {
			PApplet.main(appletArgs);
		}
	}
}
