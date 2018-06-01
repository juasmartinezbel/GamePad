import frames.input.*;
import frames.input.event.*;
import frames.primitives.*;
import frames.primitives.Frame;
import frames.core.*;
import frames.processing.*;
import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;
static final int NO_MODELS=2;
static final int VIEW_RADIUS=200;

Node eye;
Scene scene;
String shapePath[] ={"Arwing/arwing.obj", "Pommy/Pommy.obj", "boo/boo.obj", "star/star.obj", "heart/heart.obj", "eye/eye.obj", "eye/eye.obj"};
Shape shape[] = new Shape[NO_MODELS];
Shape boxes[] = new Shape[NO_MODELS];
PVector [] modelsPosition = new PVector[7];
PShape [] models = new PShape [7];
PShape pointer;
Shape pointerS;
boolean selected=false;
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
  boxesVector = new HashMap <Integer, Vector[]>();
  initPointer();
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
  
  modelsPosition[0]=new PVector(0, 0, 0);
  modelsPosition[1]=new PVector(0,150,0);
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
      boxes[i].draw();
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
   pointer();
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

void initPointer(){
  
  
}
void pointer(){
  pushMatrix();
    pushStyle();
      scene.beginScreenCoordinates();
      noLights();
      noStroke();
      fill(255);
      ellipse(height/2,width/2,10,10);
      scene.endScreenCoordinates();
    popStyle();
  popMatrix();
  //println("Pointer coordinates:\t"+scene.pointUnderPixel(0, 0).toString());
  getBoxes();
}

void getBoxes(){
  //new Vector(0,0,0) 
  if(scene.pointUnderPixel(height/2, width/2)!=null){
    Vector o = scene.pointUnderPixel(height/2, width/2);
    boolean found=false;
    for(int i: boxesVector.keySet()){ 
      Vector [] v = boxesVector.get(i);
      Vector [] u = new Vector [2];
      PVector m = modelsPosition[i];
      u[0]=new Vector(v[0].x()+m.x,v[0].y()+m.y,v[0].z()+m.z);
      u[1]=new Vector(v[1].x()+m.x,v[1].y()+m.y,v[1].z()+m.z);
      
      boolean Flag1=(u[1].x()>o.x()&&u[0].x()<o.x())||(u[1].x()<o.x()&&u[0].x()>o.x());
      boolean Flag2=(u[1].y()>o.y()&&u[0].y()<o.y())||(u[1].y()<o.y()&&u[0].y()>o.y());
      boolean Flag3=(u[1].z()>o.z()&&u[0].z()<o.z())||(u[1].z()<o.z()&&u[0].z()>o.z());
      if(Flag1&&Flag2&&Flag3){
        println("Está dentro del objeto: "+shapePath[i]);
      }else{
        println(u[0].toString()+":"+u[1].toString());
        println("El puntero está en: "+o.toString());
      }
    }
     
  }else{
    println("Nada");
  }
  Frame F=(Frame) shape[0];
  //println("Coordenadas Caja: "+ scene.projectedCoordinatesOf(new Vector(0,0,0), eye).toString());
  //scene.lookAt(new Vector(0,0,0));
}
