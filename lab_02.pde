ArrayList<Projectile> bullets;
ArrayList<Arrow> flock;

int maxBullets = 10;
int flockSize = 50;
float dist;

Rectangle floor;
Rectangle ceiling;
Arrow arrow;
Canon c;
Portal portal1;
Portal portal2;

float portal1X = 350;
float portal1Y = 200;
float portal2X = 50;
float portal2Y = 100;

int portalWidth = 20;
int portalHeight = 40;

int distanceHit = 220;
PVector diff;
float d;
int index = 0;

void setup() {
  size (800,600);
  
  c = new Canon();
  
  flock = new ArrayList<Arrow>();
  
   for (int i = 0; i < flockSize; i++) {
    Arrow m = new Arrow(new PVector(random(0, width), random(0, height-100)), new PVector(random (-5, 5), random(-5, 5)));
    m.fillColor = color(random(255), random(255), random(255));
    flock.add(m);
  }
  
  portal1 = new Portal(portal1X, portal1Y, portalWidth, portalHeight);
  portal2 = new Portal(portal2X, portal2Y, portalWidth, portalHeight);
  
  floor = new Rectangle(0,height,width, 10);
  ceiling = new Rectangle(0,-10,width,10);
  bullets = new ArrayList<Projectile>();
  arrow = new Arrow(new PVector(random(0, width),random(height/2,height)), new PVector(random(-5,5),random(-5,5)));
}

int currentTime;
int previousTime = 0;
int deltaTime;

void draw() {
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime;
  

  update(deltaTime);
  render();
}

float angle = 0;

void update (float deltaTime) {
  
  c.update();
  c.separate(flock);
  hit();
  portal1.teleport(flock, portal2);
  portal2.teleport(flock, portal1);
  
  portal1.location.x = portal1X;
  portal1.location.y = portal1Y;
  portal2.location.x = portal2X;
  portal2.location.y = portal2Y;
  
   for (Arrow m : flock) {

    m.update(deltaTime);
    m.checkEdges();
    m.driveAway(c);
    m.checkCollisions(floor);
    m.checkCollisions(ceiling);
  }
  
  for ( Projectile p : bullets) {
    p.update(deltaTime);
  }
  checkReset();
}

void render() {
  background(0);
  
  arrow.display(); // fait en sorte que la divition pour le turret disparraitz
  floor.display();
  ceiling.display();
  portal1.display();
  portal2.display();
 
  
  for (Arrow m : flock) {
    m.display();
  }
  
  for ( Projectile p : bullets) {
    p.display();
  }
  
  c.display();
}

void keyPressed() {
  if (key == 'a') {
      c.move (-1);
  }
  if (key == 'd') {
      c.move (1);
  }
  if (key == ' ') {
    fire (c);
  }
  
  if(key == 'r') {
    flock.clear();
    for (int i = 0; i < flockSize; i++) {
      Arrow m = new Arrow(new PVector(random(0, width), random(0, height-100)), new PVector(random (-5, 5), random(-5, 5)));
      m.fillColor = color(random(255), random(255), random(255));
      flock.add(m);
    }
  }
  
  if(key == 'g') {
   if(portal1.isVisible && portal2.isVisible) {
     portal1.isVisible = false;
     portal2.isVisible = false;
   }
   else {
     portal1.isVisible = true;
     portal2.isVisible = true;
   }
  }

}

void checkReset(){
  print(flock.size() + "\n");
  boolean isEmpty = true;
  
  for (Arrow m : flock) {
    if(m.isVisible){
      isEmpty = false;
    }
  }
  if(isEmpty) {
    for (int i = 0; i < flockSize; i++) {
      Arrow m = new Arrow(new PVector(random(0, width), random(0, height-100)), new PVector(random (-5, 5), random(-5, 5)));
      m.fillColor = color(random(255), random(255), random(255));
      flock.add(m);
    }
  }
}

void hit() {
   for ( Projectile p : bullets) {
     for (Arrow m : flock) {
          d = PVector.dist(p.location, m.location);
          if (d > 0 && d < m.radiusSeparation-distanceHit) {
            if(p.isVisible && m.isVisible){
              fill(255,255,255);
              rect(m.location.x,m.location.y,100,100);
              p.isVisible = false;
              m.isVisible = false;
            }
        }
     }
   
    }
  }


void fire(GraphicObject m) {
  Canon c = (Canon)m;
  if (bullets.size() < maxBullets) {
    Projectile p = new Projectile();
    
    p.location = c.getCanonTip().copy();
    p.topSpeed = 5;
    p.velocity = c.getShootingVector().copy().mult(p.topSpeed);
   
    p.activate();
    p.isVisible = true;
    
    bullets.add(p);
  } else {
    for ( Projectile p : bullets) {
      if (!p.isVisible) {
        p.location.x = c.getCanonTip().x;
        p.location.y = c.getCanonTip().y;
        p.velocity.x = c.getShootingVector().x;
        p.velocity.y = c.getShootingVector().y;
        p.velocity.mult(p.topSpeed);
        p.activate();
        break;
      }
    }
  }  
}
