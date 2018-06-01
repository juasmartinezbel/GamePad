HashMap <Integer, HashMap<String, Integer[]>> ShapeVertex;
HashMap <Integer, Integer> modelSize;
HashMap <Integer, String[]> modelBoards;
PVector [] rotation;
boolean [] childSetted;
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

void initHash() {
  for (int i=0; i<NO_MODELS; i++) {
    ShapeVertex.put(i, null);
  }
}

Shape setModel(int i, boolean FirstTime) {
  Shape s;
  PShape model = models[i];
  if (FirstTime) {
    setHashMap(i);
  }
  s = new OrbitShape(scene);
  Vector [] box = getBoundingBox(model);
  float max = max(abs(box[0].x() - box[1].x()), abs(box[0].y() - box[1].y()), abs(box[0].z() - box[1].z()));
  s.set(editModel(i));
  s.rotate(new Quaternion(new Vector(0, 0, 1), PI));
  //s.scale(200.f*1.f/max);
  return s;
}

PShape editModel(int I) {
  //Integer[] c = ShapeVertex.get(I);
  HashMap<String, Integer[]> m = ShapeVertex.get(I);
  PShape model = models[I];
  for (int i = 0; i<model.getChildCount(); i++) {
    for (int j = 0; j<model.getChild(i).getVertexCount(); j++) {
      
      Integer [] xyz = m.get(i+":"+j); 
      PVector t = model.getChild(i).getVertex(j);
      model.getChild(i).setVertex(j, t.x+xyz[0], t.y+xyz[1], t.z+xyz[2]);
    }
  }

  return model;
}

void setHashMap(int I) {
  PShape model = models[I];
  HashMap<String, Integer[]> m = new HashMap<String, Integer[]>();
  int size=0;
  for (int i = 0; i<model.getChildCount(); i++) {
    for (int j = 0; j<model.getChild(i).getVertexCount(); j++) {
      Integer [] xyz={0, 0, 0};
      m.put(i+":"+j, xyz);
      size++;
    }
  }
  int current=0;
  String [] p = new String [size];
  for (int i = 0; i<model.getChildCount(); i++) {
    for (int j = 0; j<model.getChild(i).getVertexCount(); j++) {
      p[current] = i+":"+j;
      current++;
    }
  }
  
  ShapeVertex.put(I, m);
  modelSize.put(I, size-1);
  modelBoards.put(I, p);
}



PVector getPoint(int I, int needed) {
  int size=modelSize.get(I);
  int n=needed%size;
  
  int current=0;
  PShape model = models[I];
  HashMap<String, Integer[]> m = ShapeVertex.get(I);

  for (int i = 0; i<model.getChildCount(); i++) {
    for (int j = 0; j<model.getChild(i).getVertexCount(); j++) {
      if (n==current) {
        Integer [] xyz = m.get(i+":"+j); 
        //println(i+":"+j);
        PVector t = model.getChild(i).getVertex(j);
        
       
        
        pushMatrix();
          translate(modelsPosition[I].x, modelsPosition[I].y, modelsPosition[I].z);
          rotateX(radians(rotation[I].x));
          rotateY(radians(rotation[I].y));
          rotateZ(radians(rotation[I].z));
          pushStyle();
            pushMatrix();
              PVector u = new PVector(t.x+xyz[0]+modelsPosition[I].x, t.y+xyz[1]+modelsPosition[I].y, t.z+xyz[2]+modelsPosition[I].z);
              
              
              
              fill(0,255,0);
              stroke(0,255,0);
              PShape o=createShape(ELLIPSE, 0, 0, 0.50, 0.50);
              
              model.addChild(o);
              o.translate(u.x, u.y, u.z);
            popMatrix();
          popStyle();
        popMatrix();
        return u;
      }
      current++;
    }
  }
  return null;
}

void removePoint(int I){
  PShape model = models[I];
  model.removeChild(model.getChildCount()-1);
  childSetted[I]=false;
}


void changePoint(int I, int needed){
  PShape model = models[I];
  model.removeChild(model.getChildCount()-1);
  String u = modelBoards.get(I)[needed];
  int i = Integer.valueOf(u.split(":")[0]);
  int j = Integer.valueOf(u.split(":")[1]);
  newCircle(I, i, j);
 
}

void newCircle(int I, int i, int j) {
  PShape model = models[I];
  HashMap<String, Integer[]> m = ShapeVertex.get(I);
  println(model.getChildCount());
  PVector t = model.getChild(i).getVertex(j);
  Integer [] xyz = m.get(i+":"+j); 
  
  translate(modelsPosition[I].x, modelsPosition[I].y, modelsPosition[I].z);
  pushStyle();
  PVector u = new PVector(t.x+xyz[0]+modelsPosition[I].x, t.y+xyz[1]+modelsPosition[I].y, t.z+xyz[2]+modelsPosition[I].z);
  fill(0,255,0);
  stroke(0,255,0);
  PShape o=createShape(ELLIPSE, 0, 0, 0.50, 0.50);

  model.addChild(o);
  o.translate(u.x, u.y, u.z);
  popStyle();
  println(model.getChildCount());
}
