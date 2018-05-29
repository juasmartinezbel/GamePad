HashMap <PShape, Integer[]> Vertexs;
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

Shape setModel(String shapePath){
  Shape s;
  PShape model = loadShape(shapePath);
  Vector[] box = getBoundingBox(model);
  float max = max(abs(box[0].x() - box[1].x()), abs(box[0].y() - box[1].y()), abs(box[0].z() - box[1].z()));
  s = new OrbitShape(scene);
  s.set(editModel(model));
  s.rotate(new Quaternion(new Vector(0, 0, 1), PI));
  s.scale(200.f*1.f/max);
  
  return s;
}

PShape editModel(PShape model){
  for(int i = 0; i<model.getChildCount(); i++){
    for(int j = 0; j<model.getChild(i).getVertexCount(); j++){
      PVector t = model.getChild(i).getVertex(j);
      if(i==1&&j==0){
        model.getChild(i).setVertex(j, t.x+tx, t.y+ty, t.z+tz);
      }
    }
  }
  
  return model;
}
