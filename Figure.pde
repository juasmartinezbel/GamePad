/****************************
*
* Taller Interactividad: Interacción con GamePad
* Por Juan Sebastián Martínez Beltrán
* Por el momento solo funciona con Twin USB GamePad configurado en Windows
* 
* Pestaña Figure: Clase Figure, con un respectivo Shape y PShape, y HashMaps indicados
*
*****************************/

class Figure{
  public Shape shape;
  public PShape model;
  public Shape box;
  public Shape table;
  public HashMap<String, Float[]> ShapeVertex;
  public HashMap<String, PVector> OriginalVertex;
  public Vector[] boxVector;
  public boolean childSetted;
  public HashMap<String, ArrayList<String>> concidentialPoints;
  public PVector modelsPosition;
  public PVector boxPosition;
  public int modelSize;
  public int I;
  public Vector[] boundaries;
  
  /**
  *
  * Figure() Inicializa la figura
  *
  **/
  public Figure(int I){
    ShapeVertex=new HashMap<String, Float[]>();
    OriginalVertex = new HashMap<String, PVector>();
    concidentialPoints = new HashMap<String, ArrayList<String>>();
    this.I=I;
  }
  
  /**
  *
  * setHashMap(): Inicializa los HashMaps de la clase
  *
  **/
  void setHashMap() { 
    ShapeVertex = new HashMap<String, Float[]>();
    OriginalVertex = new HashMap<String, PVector>();
    concidentialPoints = new HashMap<String,  ArrayList<String>>();
    
  
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
        ShapeVertex.put(s, xyz);
        OriginalVertex.put(s, v);
  
        ArrayList <String> a = new ArrayList <String>();
        if(concidentialPoints.containsKey(s)){
          a = concidentialPoints.get(s);
        }
        a.add(k);
        concidentialPoints.put(s,a);
      }
    }
    size=concidentialPoints.size();
    
    modelSize=size-1;
  }
  
  /**
  *
  * changeVertex(): Me cambia los parametros del vertice
  *
  **/
  void changeVertex(String u, Float[] v){
    HashMap<String,  ArrayList<String>> l = concidentialPoints;
    ArrayList<String> a = l.get(u);
    PVector w = OriginalVertex.get(u);
    for(String s : a){
      int i = Integer.valueOf(s.split(":")[0]);
      int j = Integer.valueOf(s.split(":")[1]);
      model.getChild(i).setVertex(j, v[0]+w.x,v[1]+w.y,v[2]+w.z);
    }
  }
  
  
  /**
  *
  * removePoint(): Se deselecciona el modelo y se elimina el hijo creado
  *
  **/
  void removePoint(){
    model.removeChild(model.getChildCount()-1);
    childSetted=false;
  }
  
  /**
  *
  * changePoint(): Cambia el punto a editar seleccionado
  *
  **/
  void changePoint(int needed){
    model.removeChild(model.getChildCount()-1);
    ArrayList<String> f =  new ArrayList<String>(concidentialPoints.keySet());
    String u = f.get(needed);
    float i = Float.valueOf(u.split(":")[0]);
    float j = Float.valueOf(u.split(":")[1]);
    float k = Float.valueOf(u.split(":")[2]);
    newCircle(i, j, k);
  }
  
    /**
  *
  * firstCirlce(): Elige el primer punto a editar
  *
  **/
  void firstCircle(){
    ArrayList<String> f = new ArrayList<String>(concidentialPoints.keySet());
    String u = f.get(0);
    float i = Float.valueOf(u.split(":")[0]);
    float j = Float.valueOf(u.split(":")[1]);
    float k = Float.valueOf(u.split(":")[2]);
    newCircle(i, j, k);
  }
  
    /**
  *
  * newCircle(): Me crea una esfera en el lugar donde se va a editar
  *
  **/
  void newCircle(float i, float j, float k) {
    String s = i+":"+j+":"+k;
    HashMap<String, Float[]> m = ShapeVertex;
    PVector t = OriginalVertex.get(s);
    Float [] xyz = m.get(s); 
    
    translate(modelsPosition.x, modelsPosition.y, modelsPosition.z);
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
    sphereDetail(4);
    PShape o=createShape(SPHERE, radious);
    //PShape o=createShape(ELLIPSE, 0, 0, 1000, 1000);
    model.addChild(o);
    o.translate(u.x(), u.y(), u.z());
    popStyle();
  }


  /**
  *
  * getBox(): Me crea la caja invisible
  *
  **/
  void getBox(){
    Vector[] v= boundaries;
    pushStyle();
    stroke(255);
    fill(0,255,0,40);
    //-3.2:2.9:-2.9
    //noStroke();
    //noFill();
    
    PShape bo = createShape(BOX,v[1].x()-v[0].x(),  v[0].y()-v[1].y(),  v[1].z()-v[0].z());
    Shape m = new Shape(scene);
    
    float max = max(abs(v[0].x() - v[1].x()), abs(v[0].y() - v[1].y()), abs(v[0].z() - v[1].z()));
    m.set(bo);
    float scale=200.f*1.f/max;
    m.scale(scale);
    v[0].multiply(scale);
    v[1].multiply(scale);
    boxVector = v; 
    popStyle();
    box=m;
  }

}
