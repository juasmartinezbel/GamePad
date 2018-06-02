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
  //println("Pointer coordinates:\t"+scene.pointUnderPixel(0, 0).toString());
}
