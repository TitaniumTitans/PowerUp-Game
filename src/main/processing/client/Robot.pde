class Robot {
  Robot (String name, int ID, int x, int y, float r) {
    this.name = name;
    this.ID = ID;
    this.x = x;
    this.y = y;
    this.r = r;
  }
  
  String name;
  int ID;
  int x, y;
  float r;
  
  void draw () {
    pushMatrix();
    translate(x, y);
    rotate(r);
    fill(#BAC5D3);
    rect(0, 0, 30, 70);
    rotate(-HALF_PI);
    fill(0);
    text(name, 0, -2);
    popMatrix();
  }
}

boolean invalidID (int robotID) {
  return robotID < 0 || robotID >= robots.length || robots[robotID] == null;
}
