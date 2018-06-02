/****************************
*
* Taller Interactividad: Interacción con GamePad
* Por Juan Sebastián Martínez Beltrán
* Por el momento solo funciona con Twin USB GamePad configurado en Windows
* 
* Pestaña Model: Funciones con respecto a inicializar y crear modelos 
* Las operaciones de esta pestaña fueron tomadas de: https://github.com/VisualComputing/framesjs/blob/processing/examples/ik/InteractiveFish/InteractiveFish.pde
*
*****************************/

/**
*
* getBoundingBox(): Me obtiene los máximos y mínimos de un modelo.
*
**/

Vector[] getBoundingBox(PShape shape) {
  Vector v[] = new Vector[2];
  float minx = 999;  
  float miny = 999;
  float maxx = -999; 
  float maxy = -999;
  float minz = 999;  
  float maxz = -999;
  for (int j = 0; j < shape.getChildCount(); j++) {
    PShape aux = shape.getChild(j);
    for (int i = 0; i < aux.getVertexCount(); i++) {
      float x = aux.getVertex(i).x;
      float y = aux.getVertex(i).y;
      float z = aux.getVertex(i).z;
      minx = minx > x ? x : minx;
      miny = miny > y ? y : miny;
      minz = minz > z ? z : minz;
      maxx = maxx < x ? x : maxx;
      maxy = maxy < y ? y : maxy;
      maxz = maxz < z ? z : maxz;
    }
  }

  v[0] = new Vector(minx, miny, minz);
  v[1] = new Vector(maxx, maxy, maxz);
  return v;
}

/**
*
* getBoundingBox(): Se relaciona el modelo con el Shape
*
**/
Shape setModel(int i, boolean FirstTime) {
  Shape s;
  PShape model = figures[i].model;
  if (FirstTime) {
    figures[i].setHashMap();
  }
  s = new Shape(scene);
  Vector [] box = getBoundingBox(model);
  figures[i].boundaries=box;
  float max = max(abs(box[0].x() - box[1].x()), abs(box[0].y() - box[1].y()), abs(box[0].z() - box[1].z()));
  s.set(model);
  s.rotate(new Quaternion(new Vector(0, 0, 1), PI));
  s.scale(200.f*1.f/max);
  return s;
}

/**
*
* setTableModel(): Crea una mesa para el modelo  
*
**/

void setTableModel() {
  Shape s;
  PShape model = loadShape(tablePath);
  s = new Shape(scene);
  Vector [] box = getBoundingBox(model);
  float max = max(abs(box[0].x() - box[1].x()), abs(box[0].y() - box[1].y()), abs(box[0].z() - box[1].z()));
  s.set(model);
  s.rotate(new Quaternion(new Vector(0, 0, 1), PI));
  s.scale(200.f*1.f/max);
  for(int i=0;i<NO_MODELS;i++)
    figures[i].table=s;
}

/**
*
* setTraslations(): Define las traslaciones de los modelos 
*
**/
void setTraslations(){
  
  /*
  * x+ -> Hacia la Izquierda  x- -> Derecha
  * y+ -> Hacia arriba        y- -> Abajo
  * z+ -> Empuja              z- -> Jala
  */
  
  /*
  * X+ -> Lleva hacia la derecha
  * Y+ -> Baja en la Matriz
  * Z+ -> Acerca a la Camara
  */
  int y = 100;
  int d=729;
  int h = 1000;
  int max = 1800;
  figures[0].modelsPosition=new PVector(100, y, max);
  figures[0].boxPosition = new PVector (figures[0].modelsPosition.x,   figures[0].modelsPosition.y-15,   figures[0].modelsPosition.z+15);
  figures[1].modelsPosition=new PVector(-h, y, max-d);
  figures[1].boxPosition = new PVector (figures[1].modelsPosition.x,   figures[1].modelsPosition.y-30,   figures[1].modelsPosition.z+4);
  figures[2].modelsPosition=new PVector(h, y, max-d*2);
  figures[2].boxPosition = new PVector (figures[2].modelsPosition.x-5, figures[2].modelsPosition.y-77,   figures[2].modelsPosition.z+40);
  figures[3].modelsPosition=new PVector(0, -1000, 0);
  figures[3].boxPosition = new PVector (figures[3].modelsPosition.x,   figures[3].modelsPosition.y,      figures[3].modelsPosition.z);
  figures[4].modelsPosition=new PVector(-h, y, max-d*3);
  figures[4].boxPosition = new PVector (figures[4].modelsPosition.x,   figures[4].modelsPosition.y-90,   figures[4].modelsPosition.z);
  figures[5].modelsPosition=new PVector(h, y, max-d*4);
  figures[5].boxPosition = new PVector (figures[5].modelsPosition.x,   figures[5].modelsPosition.y-90,   figures[5].modelsPosition.z);
  figures[6].modelsPosition=new PVector(-h, y, max-d*5);
  figures[6].boxPosition = new PVector (figures[6].modelsPosition.x,      figures[6].modelsPosition.y-50,   figures[6].modelsPosition.z-10);
  figures[7].modelsPosition=new PVector(100+310, 100, max-100);
  figures[7].boxPosition = new PVector (figures[7].modelsPosition.x,      figures[7].modelsPosition.y,     figures[7].modelsPosition.z);
}


/**
*
* getBoxes(): Me verifica si el puntero está dando contra el área de una caja
*
**/
int getBoxes(){
  //new Vector(0,0,0) 
  if(scene.pointUnderPixel(height/2, width/2)!=null){
    Vector o = scene.pointUnderPixel(height/2, width/2);
    for(int i=0; i<NO_MODELS; i++){
      
      Vector [] v = figures[i].boxVector;
      Vector [] u = new Vector [2];
      PVector m = figures[i].boxPosition;
      u[0]=new Vector(v[0].x()+m.x,v[0].y()+m.y,v[0].z()+m.z);
      u[1]=new Vector(v[1].x()+m.x,v[1].y()+m.y,v[1].z()+m.z);
      u[0].add(-20,-20,-20);
      u[1].add(20,20,20);
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
