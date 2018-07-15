// SERVER DOESN'T SEND OUT POSITION UPDATES YET!
import processing.net.*;
import java.net.InetAddress;

Client me;
int robotID;

void setup () {
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

void draw () {
  
}

void keyPressed () {
  me.write(str(robotID) + ":+" + key + "\n");
}

void keyReleased () {
  me.write(str(robotID) + ":-" + key + "\n");
}

void exit() { // runs when window is closed:
  me.write("-" + robotID);
  while (me.available() == 0) {}
  if (!me.readString().equals("-")) {
    println("Error: server sent back something other than '-'!");
    me.stop(); // disconnect neatly
  }
  super.exit();
}
