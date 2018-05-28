import frames.input.*;
import frames.input.event.*;
import frames.primitives.*;
import frames.core.*;
import frames.processing.*;
import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;



PImage label;
PShape can;
float angle;

PShader texShader;
HashMap <String, Integer[]> CilinderPoints;
int cilinderDetail;

Node eye;
Shape shape;
Shape shape2;
Scene scene;
String shapePath = "Arwing/arwing.obj";
String shapePath2 = "KillerBee/killerbee.obj";

public void setup() {
    initControllers();
  size(700, 700, P3D);
  //1. Set a scene and an Eye
  scene = new Scene(this);
  scene.setType(Graph.Type.ORTHOGRAPHIC);
  eye = new OrbitShape(scene);
  scene.setEye(eye);
  scene.setFieldOfView(PI / 3);
  scene.setDefaultGrabber(eye);
  scene.fitBallInterpolation();
  shape = setModel(shapePath);
  shape2 = setModel(shapePath2);
}

public void draw() {
  background(255);
  if(delay<100){
    delay+=1;
  }
  
  scene.traverse();
  background(0);
  //lights();
  rotateCamera();
  //Draw Constraints
  scene.drawAxes();
  shape.draw();
  pushMatrix();
    translate(10,10,300);
    //lights();
    shape2.draw();
  popMatrix();
  rotateCamera();
  moveCamera();
}
