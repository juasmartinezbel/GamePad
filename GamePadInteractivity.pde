import frames.input.*;
import frames.input.event.*;
import frames.primitives.*;
import frames.core.*;
import frames.processing.*;
import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;
static final int NO_MODELS=1;
static final int VIEW_RADIUS=100;

Node eye;
Scene scene;
String shapePath[] ={"Arwing/arwing.obj", "Pommy/Pommy.obj", "boo/boo.obj", "star/star.obj", "heart/heart.obj", "eye/eye.obj", "eye/eye.obj"};
Shape shape[] = new Shape[7];
PVector [] modelsPosition = new PVector[7];
PShape [] models = new PShape [7];

boolean selected=true;
int currentModel = 0;
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
  
  rotation = new PVector [NO_MODELS];
  childSetted = new boolean [NO_MODELS];
  for(int i=0;i<NO_MODELS;i++){
    childSetted[i]=false;
    rotation[i] = new PVector(0,0,0);
    models[i] = loadShape(shapePath[i]);
    //models[i].scale(scaleModel200.f*1.f/max(models[i]));
    shape[i] = setModel(i, true); 
  }
  
  modelsPosition[0]=new PVector(0, 0, 0);
  modelsPosition[1]=new PVector(0,100,0);
  modelsPosition[2]=new PVector(-400, 300, 0);
  modelsPosition[3]=new PVector(0, -800, 0);
  modelsPosition[4]=new PVector(0,0, -800);
  modelsPosition[5]=new PVector(400,0, 1600);
  modelsPosition[6]=new PVector(-400,0, 1600);
}

void draw() {
  background(0);
  if(buttonDelay<100){
    buttonDelay+=1;
  }
  lights();
  
  //Draw Constraints
  //scene.drawAxes();
  for(int i = 0; i < NO_MODELS; i++){ 
    pushMatrix();
      translate(modelsPosition[i].x,modelsPosition[i].y,modelsPosition[i].z);
      shape[i].draw();
    popMatrix();
  }
  /*noFill();
  sphereDetail(10);
  stroke(255);
  sphere(VIEW_RADIUS);*/
  if(!selected){
    cameraFunctions();
  }else{
    modelFunctions();
  }
  
  
  selectModel();
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
}

void cameraFunctions(){
  if(lastNeeded!=-2){
      neededPoint=0;
      removePoint(currentModel);
    }
  lastNeeded=-2;
  rotateCamera();
  moveCamera();
  neededPoint=0;
}
