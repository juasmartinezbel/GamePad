/****************************
*
* Taller Interactividad: Interacción con GamePad
* Por Juan Sebastián Martínez Beltrán
* 
* Pestaña Controller: Operaciones de inicialización y operación de los controles
*
*****************************/

ControlIO control;
Configuration config;
ControlDevice gpad;

int buttonDelay=0;
int rotationDelay=0;
float ry=0;float ty=0;

float rx=0;float tx=0;

float rz=0;float tz=0;
float minimum=0;//-1.5258789E-5;
int ratium = 200;

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// Funciones para inicializar
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
void initControllers(){
  int init=0;
  // Initialise the ControlIO
  control = ControlIO.getInstance(this);
  // Find a device that matches the configuration file
  gpad = control.getMatchedDevice("gamepad_config");
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
    if(gpad.getButton("STICKI").pressed()){
      rotationRatium = 90;
    }
    if(gpad.getSlider("EJEXD").getValue()<minimum){
      eye.rotate(new Quaternion(new Vector(0, 1, 0), PI/rotationRatium));
      rotationDelay=0;
    }else if(gpad.getSlider("EJEXD").getValue()>minimum){
      eye.rotate(new Quaternion(new Vector(0, -1, 0), PI/rotationRatium));
      rotationDelay=0;
    }
    
    if(gpad.getSlider("EJEYD").getValue()<minimum){
      eye.rotate(new Quaternion(new Vector(-1, 0, 0), PI/rotationRatium));
      rotationDelay=0;
    }else if(gpad.getSlider("EJEYD").getValue()>minimum){
      eye.rotate(new Quaternion(new Vector(1, 0, 0), PI/rotationRatium));
      rotationDelay=0;
    }
  
    if(gpad.getButton("R2").pressed()){
      eye.rotateZPos();
      rotationDelay=0;
    }
  
    if(gpad.getButton("L2").pressed()){       
      eye.rotateZNeg();
      rotationDelay=0;
    }
}

void moveCamera(){
  boolean run = gpad.getButton("STICKD").pressed();
  if(gpad.getSlider("EJEYI").getValue()<minimum){
    eye.translateZNeg();
    eye.translateZNeg();
    if (run) { eye.translateZNeg();  eye.translateZNeg(); }
  }else if(gpad.getSlider("EJEYI").getValue()>minimum){
    eye.translateZPos();
    eye.translateZPos();
    if (run){ eye.translateZPos(); eye.translateZPos();}
  }
  
  if(gpad.getSlider("EJEXI").getValue()<minimum){
    eye.translateXPos();
    eye.translateXPos();
    if (run) {eye.translateXPos(); eye.translateXPos();}
  }else if(gpad.getSlider("EJEXI").getValue()>minimum){
    eye.translateXNeg();
    eye.translateXNeg();
    if(run){eye.translateXNeg();eye.translateXNeg();}
  }
  
  if(gpad.getHat(0).up()){
    eye.translateYNeg();
    eye.translateYNeg();
    if(run){eye.translateYNeg();eye.translateYNeg();}
  }else if(gpad.getHat(0).down()){
    eye.translateYPos();
    eye.translateYPos();
    if(run) {eye.translateYPos();eye.translateYPos();}
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
  if(gpad.getSlider("EJEXD").getValue()>minimum){
     figures[currentModel].model.rotateY(radians(-rotateLevel));
  }else if(gpad.getSlider("EJEXD").getValue()<minimum){
     figures[currentModel].model.rotateY(radians(rotateLevel));
  }
  
  if(gpad.getSlider("EJEYD").getValue()>minimum){
    figures[currentModel].model.rotateX(radians(rotateLevel));
  }else if(gpad.getSlider("EJEYD").getValue()<minimum){
    figures[currentModel].model.rotateX(radians(-rotateLevel));
  }

  if(gpad.getButton("L2").pressed()){
    figures[currentModel].model.rotateZ(radians(-rotateLevel));
  }
  
  if(gpad.getButton("R2").pressed()){       
    figures[currentModel].model.rotateZ(radians(rotateLevel));
  }
}

void movePoints(){
  
  ArrayList<String> f =  new ArrayList<String>(figures[currentModel].concidentialPoints.keySet());
  String u = f.get(neededPoint);
  Float [] xyz = figures[currentModel].ShapeVertex.get(u); 
  
  if(gpad.getSlider("EJEYI").getValue()<minimum){
    xyz[2]-=0.2;
  }else if(gpad.getSlider("EJEYI").getValue()>minimum){
    xyz[2]+=0.2;
  }
  
  if(gpad.getSlider("EJEXI").getValue()<minimum){
    xyz[0]+=0.2;
  }else if(gpad.getSlider("EJEXI").getValue()>minimum){
    xyz[0]-=0.2;
  }
  
  if(gpad.getHat(0).up()){
    xyz[1]+=0.2;
  }else if(gpad.getHat(0).down()){
    xyz[1]-=0.2;
  }
  figures[currentModel].ShapeVertex.put(u,xyz);
  figures[currentModel].changeVertex(u, xyz);
}


void resetPoint(){
  if(gpad.getButton("STICKI").pressed()){
      
      ArrayList<String> f =  new ArrayList<String>(figures[currentModel].concidentialPoints.keySet());
      String u = f.get(neededPoint);
      Float [] xyz = {0.0,0.0,0.0};
      figures[currentModel].ShapeVertex.put(u,xyz);
      figures[currentModel].changeVertex(u, xyz);
  }
  
  if(gpad.getButton("STICKD").pressed()){
    figures[currentModel].model.resetMatrix();
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
  if(gpad.getSlider("EJEYI").getValue()<minimum){
    sx=1.1;
  }else if(gpad.getSlider("EJEYI").getValue()>minimum){
    sx=0.9;
  }else{
    sx=1;
  }
  figures[currentModel].model.scale(sx);
}


////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// Funciones para seleccionar el Modelo
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

void selectModel(int I){
  if(gpad.getButton("EQUIS").pressed()&&buttonDelay>7){
    selected=true;
   scene.lookAt(new Vector(figures[I].modelsPosition.x,figures[I].modelsPosition.y,figures[I].modelsPosition.z));
    currentModel = I;
    buttonDelay=0;
  }
}

void deselectModel(){
  if(gpad.getButton("CIRCULO").pressed()&&buttonDelay>7){
    figures[currentModel].removePoint();
    currentModel = -2;
    buttonDelay=0;
    selected=false;
  }
}

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// Otras Funciones
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

void reset(){
  if(gpad.getButton("START").pressed()&&buttonDelay>7){
    frameCount=-1;
    buttonDelay=0;
  }
}
void end(){
  if(gpad.getButton("SELECT").pressed()&&buttonDelay>7){
    exit();
  }
}

void turnLights(){
  if(gpad.getButton("CUADRADO").pressed()&&buttonDelay>7){
    lightsOn=!lightsOn;
    buttonDelay=0;
  }
}

void showCanvas(){
   if(gpad.getButton("L1").pressed()){
      controlsMove= true;
    }else{
      controlsMove= false;
    }
    
    if(gpad.getButton("R1").pressed()){
      controlsClick= true;
    }else{
      controlsClick = false;
    }
    
}
