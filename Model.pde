HashMap <Integer, HashMap<String, Float[]>> ShapeVertex;
HashMap <Integer, HashMap<String, PVector>> OriginalVertex;
HashMap <Integer, Integer> modelSize;
HashMap <Integer, Vector[]> boxesVector;
PVector [] rotation;
boolean [] childSetted;

HashMap <Integer, HashMap<String, ArrayList<String>>> concidentialPoints;


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


Shape setModel(int i, boolean FirstTime) {
  Shape s;
  PShape model = models[i];
  if (FirstTime) {
    setHashMap(i);
  }
  s = new OrbitShape(scene);
  Vector [] box = getBoundingBox(model);
  float max = max(abs(box[0].x() - box[1].x()), abs(box[0].y() - box[1].y()), abs(box[0].z() - box[1].z()));
  s.set(model);
  s.rotate(new Quaternion(new Vector(0, 0, 1), PI));
  s.scale(200.f*1.f/max);
  return s;
}

void setTableModel() {
  Shape s;
  PShape model = loadShape(tablePath);
  
  s = new OrbitShape(scene);
  Vector [] box = getBoundingBox(model);
  float max = max(abs(box[0].x() - box[1].x()), abs(box[0].y() - box[1].y()), abs(box[0].z() - box[1].z()));
  s.set(model);
  s.rotate(new Quaternion(new Vector(0, 0, 1), PI));
  s.scale(200.f*1.f/max);
  for(int i=0;i<NO_MODELS;i++)
    table[i]=s;
}



void setHashMap(int I) {
  PShape model = models[I];
  HashMap<String, Float[]> m = new HashMap<String, Float[]>();
  HashMap<String, PVector> n = new HashMap<String, PVector>();
  HashMap<String,  ArrayList<String>> l = new HashMap<String,  ArrayList<String>>();
  

  int size=0;
  for (int i = 0; i<model.getChildCount(); i++) {
    for (int j = 0; j<model.getChild(i).getVertexCount(); j++) {
      Float [] xyz={0.0, 0.0, 0.0};
      PVector v= model.getChild(i).getVertex(j);
      model.getChild(i).setVertex(j,  Float.valueOf(String.format("%.1f", v.x).replace(',', '.')), 
                                      Float.valueOf(String.format("%.1f", v.y).replace(',', '.')), 
                                      Float.valueOf(String.format("%.1f", v.z).replace(',', '.')));
      v=model.getChild(i).getVertex(j);
      String s = v.x+":"+v.y+":"+v.z;
      String k = i+":"+j;
      m.put(s, xyz);
      n.put(s, v);

      ArrayList <String> a = new ArrayList <String>();
      if(l.containsKey(s)){
        a = l.get(s);
      }
      a.add(k);
      l.put(s,a);
    }
  }
  size=l.size();
  
  OriginalVertex.put(I, n);
  ShapeVertex.put(I, m);
  modelSize.put(I, size-1);
  concidentialPoints.put(I,l);
}



////////////////////////////////////////////////////////////
// Funciones para mover los vertices
////////////////////////////////////////////////////////////

void changeVertex(String u, Float[] v){
  PShape model = models[currentModel];
  HashMap<String,  ArrayList<String>> l = concidentialPoints.get(currentModel);
  ArrayList<String> a = l.get(u);
  PVector w = OriginalVertex.get(currentModel).get(u);
  for(String s : a){
    int i = Integer.valueOf(s.split(":")[0]);
    int j = Integer.valueOf(s.split(":")[1]);
    model.getChild(i).setVertex(j, v[0]+w.x,v[1]+w.y,v[2]+w.z);
  }
}



////////////////////////////////////////////////////////////
// Funciones para elegir nuevos puntos
////////////////////////////////////////////////////////////
void removePoint(int I){
  PShape model = models[I];
  model.removeChild(model.getChildCount()-1);
  childSetted[I]=false;
}


void changePoint(int I, int needed){
  PShape model = models[I];
  model.removeChild(model.getChildCount()-1);
  ArrayList<String> f =  new ArrayList<String>(concidentialPoints.get(I).keySet());
  String u = f.get(needed);
  float i = Float.valueOf(u.split(":")[0]);
  float j = Float.valueOf(u.split(":")[1]);
  float k = Float.valueOf(u.split(":")[2]);
  newCircle(I, i, j, k);
 
}


void firstCircle(int I){
  ArrayList<String> f = new ArrayList<String>(concidentialPoints.get(I).keySet());
  String u = f.get(0);
  float i = Float.valueOf(u.split(":")[0]);
  float j = Float.valueOf(u.split(":")[1]);
  float k = Float.valueOf(u.split(":")[2]);
  newCircle(I, i, j, k);
}

void newCircle(int I, float i, float j, float k) {
  String s = i+":"+j+":"+k;
  println(I);
  println(s);
  PShape model = models[I];
  HashMap<String, Float[]> m = ShapeVertex.get(I);
  PVector t = OriginalVertex.get(I).get(s);
  Float [] xyz = m.get(s); 
  
  translate(modelsPosition[I].x, modelsPosition[I].y, modelsPosition[I].z);
  pushStyle();
  Vector u = new Vector(t.x+xyz[0], t.y+xyz[1], t.z+xyz[2]);
  //u.add(modelsPosition[I].x,modelsPosition[I].y,modelsPosition[I].z);
  fill(0,255,0);
  stroke(0,255,0);
  float radious = 0.50;
  if(I==1||I==2){
    radious = 0.1;
  }else if(I==3||I==7||I==4){
    radious = 0.09;
  }else if(I==6){
    radious = 0.05;
  }else if(I==5){
    radious = 3;
  }
  PShape o=createShape(SPHERE, radious);
  //PShape o=createShape(ELLIPSE, 0, 0, 1000, 1000);
  model.addChild(o);
  o.translate(u.x(), u.y(), u.z());
  popStyle();
}

////////////////////////////////////////////////////////////
// Funciones para sacar la caja de un modelo
////////////////////////////////////////////////////////////
Shape getBox(int I){
  PShape model = models[I];
  Vector[] v= getBoundingBox(model);
  pushStyle();
  //stroke(255);
  //fill(0,255,0);
  //-3.2:2.9:-2.9
  noStroke();
  noFill();
  
  PShape bo = createShape(BOX,v[1].x()-v[0].x(),  v[0].y()-v[1].y(),  v[1].z()-v[0].z());
  Shape m = new OrbitShape(scene);
  
  float max = max(abs(v[0].x() - v[1].x()), abs(v[0].y() - v[1].y()), abs(v[0].z() - v[1].z()));
  m.set(bo);
  float scale=200.f*1.f/max;
  m.scale(scale);
  v[0].multiply(scale);
  v[1].multiply(scale);
  boxesVector.put(I, v); 
  popStyle();
  return m;
}
