class Canon extends GraphicObject {

  float shootingAngle = QUARTER_PI;
  float angleIncrement = PI/60;
  float angleMax = 1.41; // sqrt 2

  float w = 32;
  float h = 16;
  float r = 50; //radius
  
  float radiusSeparation = 6 * r;
  
  PVector shootingVector = new PVector();
  PVector canonTip = new PVector();
  
  Canon() {
    super();

    location.x = width / 2;
    location.y = height - h;
  }
  
  PVector getCanonTip() {
    
    return canonTip;
  }
  
  PVector getShootingVector() {
    return shootingVector;
  }
  
  void move (float direction) {
    if (direction > 0) {
      shootingAngle += shootingAngle < angleMax  ? angleIncrement * direction : 0;
    } else {
      shootingAngle += shootingAngle > -angleMax ? angleIncrement * direction : 0;
    }
    
    // X et Y sont inverses
    shootingVector.y = -cos(shootingAngle);
    shootingVector.x = sin(shootingAngle);
    shootingVector.normalize();
    
    // Calcul du bout du canon
    canonTip.x = location.x + shootingVector.x * w;
    canonTip.y = location.y + shootingVector.y * w - 3;
    
  }

  void display() {
    pushMatrix();
      translate (location.x - w / 2, location.y);
  
      // Placer le canon
      pushMatrix();
        translate (w / 2 , -h / 2 + 6);
    
        
        rotate (shootingAngle);
        
        translate (-3, -2 * h);
        rect (0, 0, 6, w);
        
      popMatrix();
  
      ellipse (w / 2, 0, w, w);
      rect (0, 0, w, h);

    popMatrix();
   
  }
  
   PVector separate (ArrayList<Arrow> arrows) {
    PVector steer = new PVector(0, 0, 0);
    
    int count = 0;
    
    for (Arrow other : arrows) {
      float d = PVector.dist(location, other.location);
      
      if (d > 0 && d < radiusSeparation) {
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
