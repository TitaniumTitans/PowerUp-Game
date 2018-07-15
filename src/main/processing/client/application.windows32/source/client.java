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

// SERVER DOESN'T SEND OUT POSITION UPDATES YET!



Client me;
int robotID;

public void setup () {
	me = new Client(this, "localhost", 10002); // that IP address is my server
	
	// ask server to create new robot:
	try {
		me.write("+" + InetAddress.getLocalHost().getHostName() + "\n");
	} catch (java.net.UnknownHostException error) {
		me.write("+unknown\n");
	}
	while (me.available() == 0) {} // wait for server to create robot!
	robotID = me.read();
	if (robotID == 255) { // if server says that you're not allowed to make another robot:
		println("No more robots allowed!");
		super.exit(); // quit
	}
}

public void draw () {
	
}

public void keyPressed () {
	me.write(str(robotID) + ":+" + key + "\n");
}

public void keyReleased () {
	me.write(str(robotID) + ":-" + key + "\n");
}

public void exit() { // runs when window is closed:
	me.write("-" + robotID);
	while (me.available() == 0) {}
	if (!me.readString().equals("-")) {
		println("Error: server sent back something other than '-'!");
		me.stop(); // disconnect neatly
	}
	super.exit();
}
	static public void main(String[] passedArgs) {
		String[] appletArgs = new String[] { "client" };
		if (passedArgs != null) {
			PApplet.main(concat(appletArgs, passedArgs));
		} else {
			PApplet.main(appletArgs);
		}
	}
}
