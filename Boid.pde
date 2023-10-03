 class Arrow extends GraphicObject {
  float topSpeed = 2;
  float topSteer = 0.03;
  
  float theta = 0;
  float r = 10; // Rayon du Arrow
  
  float radiusSeparation = 25 * r;

  float mass = 1.0;
  
  float red, g, b;
  
  PVector diff; 
  
  float d;
  
  boolean isVisible = false;
  
  boolean debugMode = false;
  
  boolean isTeleported = true;
  
  int fillColor;
  
  Arrow () {
    location = new PVector();
    velocity = new PVector();
    acceleration = new PVector();
    isVisible = true;
  }
  
  Arrow (PVector loc, PVector vel) {
    
    
    this.location = loc.copy();
    this.velocity = vel.copy();
    this.acceleration = new PVector (0 , 0);
      isVisible = true;
  }
  
  void checkEdges() {
    if (location.x < 0) {
      location.x = width - r;
    } else if (location.x + r> width) {
      location.x = 0;
    }
    
    if (location.y < 0) {
      location.y = height - r;
    } else if (location.y + r> height) {
      location.y = 0;
    }
  }
  
  void flock (ArrayList<Arrow> Arrows) {
    PVector separation = separate(Arrows);
    
    applyForce(separation);
  }

  void update(float deltaTime) {
    checkEdges();
    
    velocity.add (acceleration);
    velocity.limit(topSpeed);
    location.add (velocity);

    acceleration.mult (0);      
  }
  
  void display() {
    fill(fillColor);
    
    theta = velocity.heading() + radians(90);
    if(isVisible == true)
    {
      pushMatrix();
      translate(location.x, location.y);
      rotate (theta);
      
      beginShape(TRIANGLES);
        vertex(0, -r * 2);
        vertex(-r, r * 2);
        vertex(r, r * 2);
      
      endShape();
      
      if (debugMode) {
        rotate(-theta);
        displayDebugCircle(radiusSeparation, color (0, 255, 0), "Separation");
      }
      
      popMatrix();  
    }
  }
  
  void displayDebugCircle(float radius, color c, String title) {
    noFill();
    stroke(c);
    strokeWeight(2);
    
    if (title != null && title != "") {
      float sz = textWidth(title);
      text(title, -sz / 2, -radius + 10);
    }
    
    ellipse(0, 0, radius * 2, radius * 2);
  }
  
  PVector separate (ArrayList<Arrow> Arrows) {
    PVector steer = new PVector(0, 0, 0);
    
    int count = 0;
    
    for (Arrow other : Arrows) {
      float d = PVector.dist(location, other.location);
      
      if (d > 0 && d < radiusSeparation) {
        PVector diff = PVector.sub(location, other.location);
        
        diff.normalize(); // Ramène à une longueur de 1
        
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
    
    if (steer.mag() > 0) {
      steer.setMag(topSpeed);
      steer.sub(velocity);
      steer.limit(topSteer);
    }
    
    return steer;
  }

  void applyForce (PVector force) {
    PVector f;
    
    if (mass != 1)
      f = PVector.div (force, mass);
    else
      f = force;
   
    this.acceleration.add(f);    
  }
  
  void setAlpha(int alpha) {
    red = red(fillColor);
    g = green(fillColor);
    b = blue(fillColor);
    
    fillColor = color (red, g, b, alpha);    
  }
  
  void setDebugMode(boolean debugMode) {
    this.debugMode = debugMode;
  }
  
  void driveAway (GraphicObject c) {
    PVector steer = new PVector(0, 0, 0);
    
    int count = 0;
    
     d = PVector.dist(location, c.location);
    
    if (d > 0 && d < radiusSeparation) {
       diff = PVector.sub(location, c.location);
      diff.normalize(); // Ramène à une longueur de 1
      
      // Division par la distance pour pondérer.
      // Plus qu'il est loin, moins qu'il a d'effet
      diff.div(d); 
      
      // Force de braquage
      steer.add(diff);
      
      count++;
    }
    
    if (count > 0) {
      steer.div(count);
    }
    
    if (steer.mag() > 0) {
      steer.setMag(topSpeed);
      steer.sub(velocity);
      steer.limit(topSteer);
    }
    
    applyForce(steer.mult(0.5));

  }
  
   public boolean checkCollisions(Rectangle paddle) {

    if(isBouncingY(paddle)) {
      velocity.y *= -1;
      return true;
    }
     return false;
  }
  
    public float left() { return (int)location.x - r / 2; }
  public float right() { return (int)location.x + r /2; }
  
  public float top() { return (int)location.y - r /2; }
  public float bottom() { return (int)location.y + r /2; }
  
    public boolean isBouncingY(Rectangle paddle) {

    boolean checkRight = right() > paddle.left();
    boolean checkLeft = left() < paddle.right();
    
    // Si je continue en Y est-ce que je vais
    // avoir une collision avec l'autre
    boolean passBottom = bottom() + velocity.y > paddle.top();
    boolean passTop = top() + velocity.y < paddle.bottom();
    
    return checkRight && checkLeft && passBottom && passTop;
  }
}
