void processRobots (boolean writeRobots) {
  for (int i = 0; i < robots.length; i++) {
    if (robots[i] == null) continue; // skip any removed robots
    robots[i].physics();
    robots[i].draw();
    
    if (writeRobots) {
      // send out this robot
      server.write(new byte[] { // using as few bytes as I can:
        1, // protocol #1: robot update
        (byte)i, // robot ID
        (byte)round(robots[i].x),
        (byte)(round(robots[i].x) >> 8),
        (byte)round(robots[i].y),
        (byte)(round(robots[i].y) >> 8),
        (byte)round(map(robots[i].r, -TAU, TAU, 0, 255)), // rotation in degrees
      });
    }
  }
}
/*
  (byte)round(map(robots[i].x, 0, width, 1, 255)), // x position
  (byte)round(map(robots[i].y, 0, height, 1, 255)), // y position
*/
