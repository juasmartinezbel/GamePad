ControlIO control;
ControlDevice gpad;
int buttonDelay=0;
int rotationDelay=0;
float ry=0;float ty=0;

float rx=0;float tx=0;

float rz=0;float tz=0;
float minimum=-1.5258789E-5;
int ratium = 150;

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// Funciones para inicializar
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
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

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// Funciones para la camara
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
void rotateCamera(){
    int rotationRatium = ratium;
    if(gpad.getButton("Botón 10").pressed()){
      rotationRatium = 90;
    }
    if(gpad.getSlider("Rotación Z").getValue()<minimum){
      eye.rotate(new Quaternion(new Vector(0, 1, 0), PI/rotationRatium));
      rotationDelay=0;
    }else if(gpad.getSlider("Rotación Z").getValue()>minimum){
      eye.rotate(new Quaternion(new Vector(0, -1, 0), PI/rotationRatium));
      rotationDelay=0;
    }
    
    if(gpad.getSlider("Eje Z").getValue()<minimum){
      eye.rotate(new Quaternion(new Vector(-1, 0, 0), PI/rotationRatium));
      rotationDelay=0;
    }else if(gpad.getSlider("Eje Z").getValue()>minimum){
      eye.rotate(new Quaternion(new Vector(1, 0, 0), PI/rotationRatium));
      rotationDelay=0;
    }
  
    if(gpad.getButton("Botón 7").pressed()){
      eye.rotateZPos();
      rotationDelay=0;
    }
  
    if(gpad.getButton("Botón 6").pressed()){       
      eye.rotateZNeg();
      rotationDelay=0;
    }
}

void moveCamera(){
  boolean run = gpad.getButton("Botón 11").pressed();
  if(gpad.getSlider("Eje Y").getValue()<minimum){
    eye.translateZNeg();
    eye.translateZNeg();
    if (run) eye.translateZNeg();
    //pointerS.translateZPos();
    //println("AAAAAAAAA");
  }else if(gpad.getSlider("Eje Y").getValue()>minimum){
    eye.translateZPos();
    eye.translateZPos();
    if (run) eye.translateZPos();
    //pointerS.translateZNeg();
    //println("bbb");
  }
  
  if(gpad.getSlider("Eje X").getValue()<minimum){
    eye.translateXPos();
    eye.translateXPos();
    if (run) eye.translateXPos();
    //pointerS.translateXNeg();
  }else if(gpad.getSlider("Eje X").getValue()>minimum){
    eye.translateXNeg();
    eye.translateXNeg();
    if(run)eye.translateXNeg();
    //pointerS.translateXPos();
  }
  
  if(gpad.getHat(0).up()){
    eye.translateYNeg();
    eye.translateYNeg();
    if(run)eye.translateYNeg();
    //pointerS.translateYPos();
  }else if(gpad.getHat(0).down()){
    eye.translateYPos();
    eye.translateYPos();
    if(run) eye.translateYPos();
    //pointerS.translateYNeg();
  }


}
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// Funciones para interactuar con el modelo
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////


int yx=0;
void rotateModel(){
  int rotateLevel=2;
  if(gpad.getSlider("Rotación Z").getValue()>minimum){
     models[currentModel].rotateY(radians(-rotateLevel));
     rotation[currentModel].y-=rotateLevel;
  }else if(gpad.getSlider("Rotación Z").getValue()<minimum){
     models[currentModel].rotateY(radians(rotateLevel));
     rotation[currentModel].y+=rotateLevel;
  }
  
  if(gpad.getSlider("Eje Z").getValue()>minimum){
    models[currentModel].rotateX(radians(rotateLevel));
    rotation[currentModel].x+=rotateLevel;
  }else if(gpad.getSlider("Eje Z").getValue()<minimum){
    models[currentModel].rotateX(radians(-rotateLevel));
    rotation[currentModel].x-=rotateLevel;
  }

  if(gpad.getButton("Botón 6").pressed()){
    models[currentModel].rotateZ(radians(-rotateLevel));
    rotation[currentModel].z+=rotateLevel;
  }
  
  if(gpad.getButton("Botón 7").pressed()){       
    models[currentModel].rotateZ(radians(rotateLevel));
    rotation[currentModel].z-=rotateLevel;
  }
}

void movePoints(){
  HashMap<String, Float[]> m = ShapeVertex.get(currentModel);
  ArrayList<String> f =  new ArrayList<String>(concidentialPoints.get(currentModel).keySet());
  String u = f.get(neededPoint);
  Float [] xyz = m.get(u); 
  
  if(gpad.getSlider("Eje Y").getValue()<minimum){
    xyz[2]-=0.2;
  }else if(gpad.getSlider("Eje Y").getValue()>minimum){
    xyz[2]+=0.2;
  }
  
  if(gpad.getSlider("Eje X").getValue()<minimum){
    xyz[0]+=0.2;
  }else if(gpad.getSlider("Eje X").getValue()>minimum){
    xyz[0]-=0.2;
  }
  
  if(gpad.getHat(0).up()){
    xyz[1]+=0.2;
  }else if(gpad.getHat(0).down()){
    xyz[1]-=0.2;
  }
  m.put(u,xyz);
  changeVertex(u, xyz);
}


void resetPoint(){
  if(gpad.getButton("Botón 10").pressed()){
      HashMap<String, Float[]> m = ShapeVertex.get(currentModel);
      ArrayList<String> f =  new ArrayList<String>(concidentialPoints.get(currentModel).keySet());
      String u = f.get(neededPoint);
      Float [] xyz = {0.0,0.0,0.0};
      m.put(u,xyz);
      changeVertex(u, xyz);
  }
  
  if(gpad.getButton("Botón 11").pressed()){
    rotation[currentModel].y=0;
    rotation[currentModel].x=0;
    rotation[currentModel].z=0;
    models[currentModel].resetMatrix();
  }
  
}



void changePoint(){
  if(gpad.getHat(0).left()&&buttonDelay>10){
      neededPoint--;
      buttonDelay=0;
    }
    if(gpad.getHat(0).right()&&buttonDelay>10){
      neededPoint++;
      buttonDelay=0;
    }
}



float sx=1;
void scaleModel(){
  if(gpad.getSlider("Eje Y").getValue()<minimum){
    sx=1.1;
  }else if(gpad.getSlider("Eje Y").getValue()>minimum){
    sx=0.9;
  }else{
    sx=1;
  }
  models[currentModel].scale(sx);
}


////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// Funciones para seleccionar el Modelo
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

void selectModel(int I){
  if(gpad.getButton("Botón 2").pressed()&&buttonDelay>7){
    selected=true;
   scene.lookAt(new Vector(modelsPosition[I].x,modelsPosition[I].y,modelsPosition[I].z));
    currentModel = I;
    buttonDelay=0;
  }
}

void deselectModel(){
  if(gpad.getButton("Botón 1").pressed()&&buttonDelay>7){
    removePoint(currentModel);
    currentModel = -2;
    buttonDelay=0;
    selected=false;
  }
}

void reset(){
  if(gpad.getButton("Botón 9").pressed()&&buttonDelay>7){
    frameCount=-1;
    buttonDelay=0;
  }
}
void end(){
  if(gpad.getButton("Botón 8").pressed()&&buttonDelay>7){
    exit();
  }
}

void turnLights(){
  if(gpad.getButton("Botón 3").pressed()&&buttonDelay>7){
    lightsOn=!lightsOn;
    buttonDelay=0;
  }
}
