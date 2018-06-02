PGraphics buttons;
PGraphics controllers;
void pointer(){
  int found= getBoxes();
  pushMatrix();
    pushStyle();
      scene.beginScreenCoordinates();
      noLights();
      noStroke();
      if(found<0){
        fill(255);
      }else{
        fill(255,0,0);
        selectModel(found);
      }
      ellipse(height/2,width/2,10,10);
      scene.endScreenCoordinates();
      
    popStyle();
  popMatrix();
}

void l1r1canvas(){
  scene.beginScreenCoordinates();
  buttons.beginDraw();
  PImage bg = loadImage("buttons.gif");
  bg.resize(100,50);
  buttons.background(bg);
  buttons.endDraw();
  image(buttons, 0, 0); 
  scene.endScreenCoordinates();
}

void controlcanvas(){
  String c="";
  if(controlsMove==true){
    c="controles2.gif";
    if(selected)
      c="controles3.gif";
  }else if(controlsClick==true) {
    c="controles1.gif";
    if(selected)
      c="controles4.gif";
  }
  pushMatrix();
    scene.beginScreenCoordinates();
    controllers.beginDraw();
    PImage bg = loadImage(c);
    bg.resize(600,500);
    controllers.background(bg);
    controllers.endDraw();
    image(controllers, 50, 70); 
    scene.endScreenCoordinates();
  popMatrix();
}
