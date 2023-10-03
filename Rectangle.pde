class Rectangle extends GraphicObject{
  float x, y, w, h;
  
  float rr = 50; //radius
  
  float radiusRectSeparation = 2 * rr;
  
  Rectangle(float _x, float _y, float _w, float _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }
  
  Boolean contains(Rectangle _r) {
    Boolean result = false;
    
    if (x <= _r.x && ((x + w) >= (_r.x + _r.w)) && y <= _r.y && ((y + h) >= (_r.y + _r.h))) {
      result = true;
    }
    
    return result;
  }
  
  float left () {return x;}
  float top () {return y;}
  float right () {return x + w;}
  float bottom () {return y + h;}
  
  Boolean intersect(Rectangle _r) {
    Boolean result = false;
    
    if (!(this.left() > _r.right() ||
        this.right() < _r.left() ||
        this.top() > _r.bottom() ||
        this.bottom() < _r.top())) {
      result = true;
    }
        
    return result;
  }
   
  void display() {
    pushMatrix();
    translate (x, y);
    fill(255,255,255);
    rect (0, 0, w, h);
    popMatrix();
  }
  
     void flock (ArrayList<Arrow> arrows) {
    PVector separation = separate(arrows);
    //how to applyforce on Arrow (from here?)?
    
  }
   PVector separate (ArrayList<Arrow> arrows) {
    PVector steer = new PVector(0, 0, 0);
    
    int count = 0;
    
    for (Arrow other : arrows) {
      float d = PVector.dist(location, other.location);
      
      if (d > 0 && d < radiusRectSeparation) {
        PVector diff = PVector.sub(location, other.location);
        
        diff.normalize(); // Ramène à une longueur de 1
        
        
        //////devra surement enlever les calculs ici, pour ne pas faire deplacer le canon
        
        // Division par la distance pour pondérer.
        // Plus qu'il est loin, moins qu'il a d'effet
        diff.div(d); 
        
        // Force de braquage
        steer.add(diff);
        
        count++;
      }
    }
    
    if (count > 0) {
      steer.div(count);
    }
    return steer;
  }
}
