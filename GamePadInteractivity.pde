import frames.input.*;
import frames.input.event.*;
import frames.primitives.*;
import frames.primitives.Frame;
import frames.core.*;
import frames.processing.*;
import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;
static final int NO_MODELS=8;
static final int VIEW_RADIUS=2000;

Node eye;
Scene scene;
String shapePath[] ={"Arwing/arwing.obj", "Pommy/Pommy.obj", "boo/boo.obj", "star/star.obj", "heart/heart.obj", "bee/bee.obj", "chicken/chicken.obj", "box/box.obj"};
String tablePath = "table/otukue2.obj";
Shape shape[] = new Shape[NO_MODELS];
Shape boxes[] = new Shape[NO_MODELS];
PVector [] modelsPosition = new PVector[NO_MODELS];
PVector [] boxPosition = new PVector [NO_MODELS];
PShape [] models = new PShape [NO_MODELS];

PShape pointer;
Shape pointerS;
boolean selected=false;
int currentModel;
int neededPoint;
int lastNeeded=-2;

void setup() {
  neededPoint=0;
  initControllers();
  //fullScreen(P3D);
  size(700,700,P3D);
  //1. Set a scene and an Eye
  scene = new Scene(this);
  scene.setType(Graph.Type.ORTHOGRAPHIC);
  eye = new OrbitShape(scene);
  scene.setEye(eye);
  scene.setRadius(VIEW_RADIUS);
  scene.setFieldOfView(PI/6);
  scene.setDefaultGrabber(eye);
  scene.fitBallInterpolation();
  ShapeVertex=new HashMap <Integer, HashMap<String, Float[]>>();
  OriginalVertex = new HashMap <Integer, HashMap<String, PVector>>();
  concidentialPoints = new HashMap <Integer, HashMap<String, ArrayList<String>>>(); 
  modelSize= new HashMap <Integer, Integer>();
  boxesVector = new HashMap <Integer, Vector[]>();
  rotation = new PVector [NO_MODELS];
  childSetted = new boolean [NO_MODELS];
  for(int i=0;i<NO_MODELS;i++){
    childSetted[i]=false;
    rotation[i] = new PVector(0,0,0);
    models[i] = loadShape(shapePath[i]);
    //models[i].scale(scaleModel200.f*1.f/max(models[i]));
    shape[i] = setModel(i, true); 
    boxes[i] = getBox(i);
  }
  setTraslations();
}

void draw() {
  background(0);
 
  if(buttonDelay<100){
    buttonDelay+=1;
  }
  if(rotationDelay<50){
    rotationDelay+=1;
  }
  //lights();
  
  //Draw Constraints
  //scene.drawAxes();
  for(int i = 0; i < NO_MODELS; i++){ 
    pushMatrix();
      translate(modelsPosition[i].x,modelsPosition[i].y,modelsPosition[i].z);
      shape[i].draw();
    popMatrix();
    pushMatrix();
      translate(boxPosition[i].x,boxPosition[i].y,boxPosition[i].z);
      boxes[i].draw();
    popMatrix();
  }
  if(!selected){
    cameraFunctions();
    pointer();
  }else{
    modelFunctions();
  }
  
  
  
  
}

void modelFunctions(){
  int size=modelSize.get(currentModel);
  neededPoint=neededPoint%size;
  
  if (neededPoint<0) neededPoint += size;
  if(lastNeeded!=neededPoint){
    if(childSetted[currentModel]){
      changePoint(currentModel, neededPoint);
    }else{
      firstCircle(currentModel);
      childSetted[currentModel]=true;
    }
    lastNeeded=neededPoint;
  }
  if(gpad.getButton("Botón 0").pressed()){
    scaleModel();
  }else{
    sx=1;
    rotateModel();
    movePoints();
    changePoint();
    resetPoint();
  }
  deselectModel();
}

void cameraFunctions(){
  if(lastNeeded!=-2){
      neededPoint=0;
  }
  lastNeeded=-2;
  rotateCamera();
  moveCamera();
  neededPoint=0;
  
}



int getBoxes(){
  //new Vector(0,0,0) 
  if(scene.pointUnderPixel(height/2, width/2)!=null){
    Vector o = scene.pointUnderPixel(height/2, width/2);
    for(int i: boxesVector.keySet()){ 
      Vector [] v = boxesVector.get(i);
      Vector [] u = new Vector [2];
      PVector m = boxPosition[i];
      u[0]=new Vector(v[0].x()+m.x,v[0].y()+m.y,v[0].z()+m.z);
      u[1]=new Vector(v[1].x()+m.x,v[1].y()+m.y,v[1].z()+m.z);
      
      boolean Flag1=(u[1].x()>o.x()&&u[0].x()<o.x())||(u[1].x()<o.x()&&u[0].x()>o.x());
      boolean Flag2=(u[1].y()>o.y()&&u[0].y()<o.y())||(u[1].y()<o.y()&&u[0].y()>o.y());
      boolean Flag3=(u[1].z()>o.z()&&u[0].z()<o.z())||(u[1].z()<o.z()&&u[0].z()>o.z());
      if(Flag1&&Flag2&&Flag3){
        return i;
      }
    }
  }
  return -2;
}

void setTraslations(){
  
  /*
  * x+ -> Hacia la Izquierda  x- -> Derecha
  * y+ -> Hacia arriba        y- -> Abajo
  * z+ -> Empuja              z- -> Jala
  */
  modelsPosition[0]=new PVector(0, 0, 0);
  boxPosition[0] = new PVector (modelsPosition[0].x, modelsPosition[0].y-15, modelsPosition[0].z+15);
  modelsPosition[1]=new PVector(200, 200, 0);
  boxPosition[1] = new PVector (modelsPosition[1].x, modelsPosition[1].y-30, modelsPosition[1].z+4);
  modelsPosition[2]=new PVector(-200, 400, 0);
  boxPosition[2] = new PVector (modelsPosition[2].x-5, modelsPosition[2].y-77, modelsPosition[2].z+40);
  modelsPosition[3]=new PVector(0, 600, 0);
  boxPosition[3] = new PVector (modelsPosition[3].x, modelsPosition[3].y, modelsPosition[3].z);
  modelsPosition[4]=new PVector(200, 800, 0);
  boxPosition[4] = new PVector (modelsPosition[4].x, modelsPosition[4].y-90, modelsPosition[4].z);
  modelsPosition[5]=new PVector(-200, 1000, 0);
  boxPosition[5] = new PVector (modelsPosition[5].x, modelsPosition[5].y-90, modelsPosition[5].z);
  modelsPosition[6]=new PVector(0, 1200, 0);
  boxPosition[6] = new PVector (modelsPosition[6].x, modelsPosition[6].y-50, modelsPosition[6].z-10);
  modelsPosition[7]=new PVector(200, 1400, 0);
  boxPosition[7] = new PVector (modelsPosition[7].x, modelsPosition[7].y, modelsPosition[7].z);
  
}
