ControlIO control;
ControlDevice gpad;
int delay=0;

float ry=0;float ty=0;

float rx=0;float tx=0;

float rz=0;float tz=0;
int select=0;
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
    println("AAAAAAAA");
  }else if(gpad.getSlider("Rotación Z").getValue()>minimum){
    eye.rotateYNeg();
    println("AAAAAAAA");
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
  }else if(gpad.getHat(0).down()){
  }


}
 
