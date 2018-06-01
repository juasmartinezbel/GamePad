int delay;
void readButtons(){
  if(delay>17){
    if(gpad.getButton("Botón 0").pressed()){
      println("triangulo");
      delay=0;
    }
    if(gpad.getButton("Botón 1").pressed()){
      println("Circulo");
      delay=0;
    }
    if(gpad.getButton("Botón 2").pressed()){
      println("X");
      delay=0;
    }
    if(gpad.getButton("Botón 3").pressed()){
      println("Cuadrado");
      delay=0;
    }
    if(gpad.getButton("Botón 4").pressed()){
      println("L1");
      delay=0;
    }
    if(gpad.getButton("Botón 5").pressed()){
      println("R1");
      delay=0;
    }
    
    if(gpad.getButton("Botón 6").pressed()){
      println("L2");
      delay=0;
    }
    
    if(gpad.getButton("Botón 7").pressed()){
      println("R2");
      delay=0;
    }
    
    if(gpad.getButton("Botón 8").pressed()){
      println("SELECT");
      delay=0;
    }
    
    if(gpad.getButton("Botón 9").pressed()){
      println("Start");
      delay=0;
    }
    
    if(gpad.getButton("Botón 10").pressed()){
      println("Stick Izquierdo");
      delay=0;
    }
    
    if(gpad.getButton("Botón 11").pressed()){
      println("Stick Derecho");
      delay=0;
    }
    
    if(gpad.getHat(0).up()){
      println("UP");
      delay=0;
    }
    if(gpad.getHat(0).down()){
      println("down");
      delay=0;
    }
    if(gpad.getHat(0).left()){
      println("left");
      delay=0;
    }
    if(gpad.getHat(0).right()){
      println("right");
      delay=0;
    }
  }
}

void readJoysticks(){
  if(gpad.getSlider("Eje Y").getValue()<minimum){
    println("Mover Stick hacia Arriba");
  }else if(gpad.getSlider("Eje Y").getValue()>minimum){
    println("Mover Stick hacia Abajo");  
  }
  
  if(gpad.getSlider("Eje X").getValue()<minimum){
    println("Mover Stick hacia Izquierda");
  }else if(gpad.getSlider("Eje X").getValue()>minimum){
    println("Mover Stick hacia Derecha");  
  }
  
  if(gpad.getSlider("Eje Z").getValue()<minimum){
    println("Mover Stick2 hacia Arriba");
  }else if(gpad.getSlider("Eje Z").getValue()>minimum){
    println("Mover Stick2 hacia Abajo");  
  }
  
  if(gpad.getSlider("Rotación Z").getValue()<minimum){
    println("Mover Stick2 hacia Izquierda");
  }else if(gpad.getSlider("Rotación Z").getValue()>minimum){
    println("Mover Stick2 hacia Derecha");  
  }
}
