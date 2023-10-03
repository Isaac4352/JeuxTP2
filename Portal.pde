class Portal extends GraphicObject {
  
  float w;
  
  float h;
  
  boolean side;
  
  float r = 5;
  
  float radiusSeparation = 15 * r; 
  
  boolean isVisible = true;
  
  
  Portal(float _x, float _y, float _w, float _h){
    location.x = _x;
    location.y = _y;
    w = _w;
    h = _h;
  }
  
  void display(){
    if(isVisible) {
      
      pushMatrix();
    
   
    
      fill(255,255,255);
      ellipse(location.x,location.y, w, h);
    
    
    
      popMatrix(); 
    }
 
  }
  
  void teleport(ArrayList<Arrow> arrows, Portal otherPortal){
 
    if(isVisible) {
      for (Arrow other : arrows) {
      
        float d = PVector.dist(location, other.location);
      
        if (d > 0 && d < radiusSeparation) {
          other.location.x = otherPortal.location.x + (location.x - other.location.x + other.velocity.x);
          other.location.add(velocity);
          other.isTeleported = false;
         
        
        }
      }
    }
   
  }
}
