
/*
  Written by Adam Robertson
  Owned by the Titanium Titans
*/


PImage img ;
PrintWriter output; 
IntList points = new IntList();
boolean update = false;
int index = 0;
boolean imageLoaded = false;
int prevSec = 0;

void setup(){
  surface.setResizable(true);
  surface.setSize(1200, 200);
  strokeWeight(3);
}


void draw(){
  if(imageLoaded) background(img);        //Image has been loaded, draw the background then continue with the program.
  else{                                   //Other wise display directions and freeze the program.
    background(0);
    fill(255);
    textAlign(CENTER);
    textSize(20);
    text("Select a file to use. ", width/2, height/6);
    text("Once a file is selected you may click two points to make a line outlining a structure.", width/2, 2*height/6);
    text("The consecutive points created will form a chain of lines. ", width/2, 3*height/6);
    text("The server will use this chain of lines to determine what the robot can bump into.",width/2, 4*height/6);
    text("To break the chain press the space bar. A file named StructureArray*.txt will be generated when you press 's'",width/2, 5*height/6);
    selectInput("Select a file to use:", "fileSelected");        //Pulls up window to select image.
    noLoop();                //Freeze the program until an image is selected.
  }
  
  if (second() != prevSec){                          //Set stroke to a random color every second.
    stroke(random(255),random(255),random(255));
    prevSec = second();
  }

  
  for(int i = 0; i < points.size();){                  //Draw the points.
   if(points.get(i) == -1){
     i++;
   }
   else{
     if(i + 3 < points.size() && points.get(i + 2) != -1){
       line(points.get(i),points.get(i + 1),points.get(i + 2),points.get(i + 3));
       i += 2;
     }
     else{i += 2;}
   }
   
   
    
    
  }
   
   /*
   if(update){
    println("Points:");
    printArray(points);
    update = false;
   }*/
   
  if(mousePressed){                                      //Add a point when the mouse is pressed.
    points.set(index, mouseX);
    points.set(index + 1, mouseY);
    index = index + 2;
    update = true;
    noLoop();
    return;
  }
  
  if(keyPressed && key == 's'){                          //Save  
  
     //Searches for an available file name.
    int fileNum = 0;
    File saveFile = new File(sketchPath() + "\\StructureArray" + fileNum + ".txt");
      while(saveFile.exists()){
        fileNum++;
        saveFile = new File(sketchPath() + "\\StructureArray" + fileNum + ".txt");
      }
    
    
    output = createWriter("StructureArray" + fileNum + ".txt");    //Writes to a .txt file using the available name.
    for(int i = 0 ; i < points.size(); i++) {
      if(i != 0)output.print(":");
      if(points.get(i) == -1){
        output.print(-1);
      }
      else{
        output.print(points.get(i));
      }
     }  
    output.flush();
    output.close();    
    
    exit();
  }
  
  if(keyPressed && key == ' '){            //Adds a -1 to be used as an indicator for a break in the chain.
    if(points.get(index - 1) != -1){
      points.set(index, -1);
      index++;
      update = true;
      noLoop();
      return;
    }
  }
 
  
}


void fileSelected(File selection) {        // Called when the loadImage method finishes.

  if (selection == null) {
    exit();                                //If canceled, exit.
  } else {
    img = loadImage(selection.getAbsolutePath());
    surface.setSize(img.width, img.height);
    imageLoaded = true;
    loop();            //Continue the program.
  }
}


void keyPressed(){}
void keyReleased(){loop();}

void mousePressed(){}
void mouseReleased(){loop();}