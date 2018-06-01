ControlIO control;
ControlDevice gpad;
int buttonDelay=0;

float ry=0;float ty=0;

float rx=0;float tx=0;

float rz=0;float tz=0;
float minimum=-1.5258789E-5;

void initControllers(){
  int init=0;
  control = ControlIO.getInstance(this);
  for(ControlDevice s : control.getDevices()){
    String g=s.toString();
    g=g.replaceAll(" ","");
    println(g);
    if(g.equals("TwinUSBGamepad")){
      break;
    }
    init++;
  }
  // Find a device that matches the configuration file
  gpad = control.getDevice(init);
  if (gpad == null) {
    println("No suitable device configured");
    System.exit(-1); // End the program NOW!
  }
  
  println(gpad.toText(""));
}

void rotateCamera(){
  if(gpad.getSlider("Rotación Z").getValue()<minimum){
    eye.rotateYPos();
  }else if(gpad.getSlider("Rotación Z").getValue()>minimum){
    eye.rotateYNeg();
  }
  
  if(gpad.getSlider("Eje Z").getValue()<minimum){
    eye.rotateXPos();
  }else if(gpad.getSlider("Eje Z").getValue()>minimum){
    eye.rotateXNeg();
  }

  if(gpad.getButton("Botón 7").pressed()){
    eye.rotateZPos();
  }
  
  if(gpad.getButton("Botón 6").pressed()){       
    eye.rotateZNeg();
  }
}

void moveCamera(){
  if(gpad.getSlider("Eje Y").getValue()<minimum){
    eye.translateZNeg();
  }else if(gpad.getSlider("Eje Y").getValue()>minimum){
    eye.translateZPos();
  }
  
  if(gpad.getSlider("Eje X").getValue()<minimum){
    eye.translateXPos();
  }else if(gpad.getSlider("Eje X").getValue()>minimum){
    eye.translateXNeg();
  }
  
  if(gpad.getHat(0).up()){
    eye.translateYNeg();
  }else if(gpad.getHat(0).down()){
    eye.translateYPos();
  }


}

/*void changeModel(){
    if(delay>5){
      if(gpad.getButton("Botón 0").pressed()){
        shape = new Shape(scene);
        shape = setModel(shapePath);
        delay=1;
      }else if(gpad.getButton("Botón 1").pressed()){
        shape = new Shape(scene);
        shape = setModel(shapePath2);
        delay=1;
      }else if(gpad.getButton("Botón 2").pressed()){
        shape = new Shape(scene);
        shape = setModel(shapePath3);
        delay=1;
      }else if (gpad.getButton("Botón 3").pressed()){
        shape = new Shape(scene);
        shape = setModel(shapePath4);
        delay=1;
      }
    }
}*/


int yx=0;
void rotateModel(){
  if(gpad.getSlider("Rotación Z").getValue()>minimum){
     models[currentModel].rotateY(radians(-1));
     rotation[currentModel].y-=1;
  }else if(gpad.getSlider("Rotación Z").getValue()<minimum){
     models[currentModel].rotateY(radians(1));
     rotation[currentModel].y+=1;
  }
  
  if(gpad.getSlider("Eje Z").getValue()>minimum){
    models[currentModel].rotateX(radians(-1));
    rotation[currentModel].x-=1;
  }else if(gpad.getSlider("Eje Z").getValue()<minimum){
    models[currentModel].rotateX(radians(1));
    rotation[currentModel].x+=1;
  }

  if(gpad.getButton("Botón 6").pressed()){
    models[currentModel].rotateZ(radians(-1));
    rotation[currentModel].z+=1;
  }
  
  if(gpad.getButton("Botón 7").pressed()){       
    models[currentModel].rotateZ(radians(1));
    rotation[currentModel].z-=1;
  }
}

void movePoints(){
  
}

void selectModel(){
  if(gpad.getButton("Botón 8").pressed()&&buttonDelay>15){
    selected=!selected;
    buttonDelay=0;
  }
}



void changePoint(){
  if(gpad.getHat(0).left()&&buttonDelay>15){
      neededPoint--;
      buttonDelay=0;
    }
    if(gpad.getHat(0).right()&&buttonDelay>15){
      neededPoint++;
      buttonDelay=0;
    }
}
