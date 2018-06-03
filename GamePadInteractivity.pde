/****************************
*
* Taller Interactividad: Interacción con GamePad
* Por Juan Sebastián Martínez Beltrán
* 
* Pestaña Principal: GamePad Interactivity: Inicialización, Setup y Draw
*
*****************************/


import frames.input.*;
import frames.input.event.*;
import frames.primitives.*;
import frames.primitives.Frame;
import frames.core.*;
import frames.processing.*;
import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

// Constantes de uso: N° de modelos a utilizar y el radio de alcance de la escena
static final int NO_MODELS=8;
static final int VIEW_RADIUS=2000;

//Objetos principales de framjs
Node eye;
Scene scene;

//Ruta de las figuras a utilizar
String shapePath[] ={"Arwing/arwing.obj", "Pommy/Pommy.obj", "boo/boo.obj", "star/star.obj", "heart/heart.obj", "bee/bee.obj", "chicken/chicken.obj", "box/box.obj"};
String tablePath = "table/otukue2.obj";

//Variables de control
boolean selected;
int currentModel;
int neededPoint;
int lastNeeded=-2;
boolean lightsOn=false;
boolean controlsMove = false;
boolean controlsClick = false;

//Figuras a modelar
Figure figures[] = new Figure [NO_MODELS];
boolean started =false;
/**
*
* Setup(): Inicialización de figuras y el ambiente de Framesjs
*
**/
void setup() {
  selected=false;
  neededPoint=0;
  if(!started)
    initControllers();
  started=true;
  //fullScreen(P3D);
  size(700,700,P3D);
  buttons = createGraphics (100, 50);
  controllers = createGraphics (600, 500);
  scene = new Scene(this);
  scene.setType(Graph.Type.ORTHOGRAPHIC);
  eye = new Shape(scene);
  scene.setEye(eye);
  scene.setRadius(VIEW_RADIUS);
  scene.setFieldOfView(PI/20);
  scene.setDefaultGrabber(eye);
  scene.fitBallInterpolation();
  
  
  for(int i=0;i<NO_MODELS;i++){
    figures[i] = new Figure(i);
    figures[i].childSetted=false;
    figures[i].model = loadShape(shapePath[i]);
    figures[i].shape = setModel(i, true); 
    figures[i].getBox();
  }
  setTraslations();
  setTableModel();
}


/**
*
* Draw(): Dibujar figuras, mesas, cajas invisibles y actuar si está seleccionado o no
*
**/
void draw() {
  background(0);
  
  if(buttonDelay<100){
    buttonDelay+=1;
  }
  turnLights();
  float alpha = 200;
  if(lightsOn){
    lights();
    alpha=100; 
  }
  
  drawGrid(alpha);
  for(int i = 0; i < NO_MODELS; i++){ 
    pushMatrix();
      translate(figures[i].modelsPosition.x,figures[i].modelsPosition.y,figures[i].modelsPosition.z);
      figures[i].shape.draw();
      if(i!=3&&i!=7){
        translate(0,200,0);
        figures[i].table.draw();
      }
    popMatrix();
    /*pushMatrix();
      translate(figures[i].boxPosition.x,figures[i].boxPosition.y,figures[i].boxPosition.z);
      figures[i].box.draw();
    popMatrix();*/
  }
  
  if(!selected){
    cameraFunctions();
    pointer();
  }else{
    modelFunctions();
  }
  
  reset();
  end();
  showCanvas();
  if(controlsMove||controlsClick)
    controlcanvas();
  else
    l1r1canvas();
  
}

/**
*
* modelFunctions(): Qué tareas debe cumplir si tiene un modelo seleccionado
*
**/
void modelFunctions(){
  int size=figures[currentModel].modelSize;
  neededPoint=neededPoint%size;
  
  if (neededPoint<0) neededPoint += size;
  if(lastNeeded!=neededPoint){
    if(figures[currentModel].childSetted){
      figures[currentModel].changePoint(neededPoint);
    }else{
      figures[currentModel].firstCircle();
      figures[currentModel].childSetted=true;
    }
    lastNeeded=neededPoint;
  }
  if(gpad.getButton("TRIANGULO").pressed()){
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

/**
*
* cameraFunctions(): Qué tareas debe cumplir si no tiene un modelo seleccionado
*
**/
void cameraFunctions(){
  if(lastNeeded!=-2){
      neededPoint=0;
  }
  lastNeeded=-2;
  rotateCamera();
  moveCamera();
  neededPoint=0;
  
}

/**
*
* drawGrid(): Dibujar las cuatro grillas que actuarán como paredes y piso
*
**/
void drawGrid(float alpha){
  pushMatrix();
    pushStyle();
      stroke(255, alpha);
      
      translate(0,300,0);
      rotateX(radians(90));
      scene.drawGrid(100);
    popStyle();
  popMatrix();
  
  pushMatrix();
    pushStyle();
      stroke(255,0,0, alpha);
      translate(0,-1700,-2000);
      scene.drawGrid(40);
    popStyle();
  popMatrix();
  pushMatrix();
    pushStyle();
      stroke(0,255,0, alpha);
      rotateY(radians(90));
      translate(0,-1700,-2000);
      scene.drawGrid(40);
    popStyle();
  popMatrix();
  
  pushMatrix();
    pushStyle();
      stroke(0,0,255, alpha);
      rotateY(radians(270));
      translate(0,-1700,-2000);
      scene.drawGrid(40);
    popStyle();
  popMatrix();
}
