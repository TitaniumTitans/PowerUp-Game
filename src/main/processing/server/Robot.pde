class Robot {
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
  float speed; // how many pixels per second
  float resistance = 0.925;
  
  boolean leftPressed;
  boolean rightPressed;
  boolean upPressed;
  boolean downPressed;
  String ownerIP; // David-proofing
  
  void physics () {}
  void draw () {
    pushMatrix();
    translate(x, y);
    rotate(r);
    noFill();
    rect(0, 0, 30, 70);
    rotate(-HALF_PI);
    fill(255);
    text(name, 0, -2);
    popMatrix();
  }
}

class DropCenterRobot extends Robot {
  public DropCenterRobot (String name, int ID, float x, float y, float r) {
    super(name, ID, x, y, r);
    speed = 10;
  }
  
  float rSpeed = 0.5; // radians per second
  float rResistance = 0.9;
  @Override
  void physics () {
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
    r = (r + rv) % TAU % -TAU;
  }
}
