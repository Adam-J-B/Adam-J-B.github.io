/** 
 * File: bannerSketch.pde
 * ----------------------
 * This program generates an interactive banner 
 *
 * Author: Akinori Kinoshita
 * E-mail: art.akinoshi -at- gmail.com
 * Date: Sat May  4 11:50:42 CST 2013
 */

Grid[] grids = new Grid[52*9];
int[] colorList = {
// a
52*3+2, 52*3+3, 52*3+4,
52*4+5,
52*5+2, 52*5+3, 52*5+4, 52*5+5,
52*6+1, 52*6+5,
52*7+2, 52*7+3, 52*7+4, 52*7+5,
// d
52*1+10,
52*2+10,
52*3+10,
52*4+7, 52*4+8, 52*4+9, 52*4+10, 
52*5+7, 52*5+10,
52*6+7, 52*6+10,
52*7+7, 52*7+8, 52*7+9, 52*7+10,
// a
52*3+13, 52*3+14, 52*3+15,
52*4+16,
52*5+13, 52*5+14, 52*5+15, 52*5+16,
52*6+12, 52*6+16,
52*7+13, 52*7+14, 52*7+15, 52*7+16,

// m
52*4+19, 52*4+23, 
52*5+18, 52*5+20, 52*5+22, 52*5+24,
52*6+18, 52*6+21, 52*6+24,
52*7+18, 52*7+24,  

// b
52*1+27,
52*2+27,
52*3+27, 
52*4+27, 52*4+28, 52*4+29, 52*4+30,
52*5+27, 52*5+30,
52*6+27, 52*6+30,
52*7+27, 52*7+28, 52*7+29, 52*7+30,
// u

52*4+32, 52*4+35,
52*5+32, 52*5+35,
52*6+32, 52*6+35,
52*7+32, 52*7+33, 52*7+34, 52*7+35,

// r
52*4+37, 52*4+39,
52*5+37, 52*5+38, 52*5+40,
52*6+37, 
52*7+37, 

// n
52*4+42, 52*4+44, 52*4+45,
52*5+42, 52*5+43, 52*5+46,
52*6+42, 52*6+46,
52*7+42, 52*7+46,

//s
52*3+49, 52*3+50, 52*3+51,
52*4+48,
52*5+49, 52*5+50,
52*6+51,
52*7+48, 52*7+49, 52*7+50,
};

void setup() {
  size(852, 315); 
  for (int i = 0; i < 52; i++) {
    for (int j = 0; j < 9; j++) {
      grids[j*52+i] = new Grid(184+i*10, 115.5+j*10);
    }
  }
}

void draw() {
  background(255);
  
  for (int i = 0; i < 52; i++) {
    for (int j = 0; j < 9; j++) {
      grids[j*52+i].resetForce();
      grids[j*52+i].addRepulsionForce(mouseX, mouseY, 800, 1.0f);
      PVector catchPt2 = new PVector(184+i*10, 115.5+j*10);
      PVector diff2 = PVector.sub(catchPt2, grids[j*52+i].pos);
      diff2.div(100.0f);
      grids[j*52+i].addForce(diff2.x, diff2.y);
      grids[j*52+i].addDampingForce();
      
      for (int k = 0; k < colorList.length; k++) {
        if (colorList[k] == j*52+i) {
          stroke(0, 0, 0);
          fill(0, 0, 0);
          grids[j*52+i].run();
        }
      }
    }
  }
}

class Grid {
  PVector pos;
  PVector vel;
  PVector acc;
  float damping;
  PVector originalPos;
	
  Grid(float px, float py) {
    pos = new PVector(px, py);
    vel = new PVector();
    acc = new PVector();
    damping = 0.05f;
    originalPos = pos;
  }
	
  void resetForce() {
    acc.set(0.0f, 0.0f, 0.0f);
  }
	
  void addRepulsionForce(float x, float y, float radius, float scale) {
    PVector posOfForce;	
    posOfForce = new PVector(x, y, 0);
		
    PVector diff = PVector.sub(pos, posOfForce);
    float length = diff.mag();
		
    boolean isCloseEnough = true;
    if (radius > 0) {
      if (length > radius) {
        isCloseEnough = false;
      }
    }
		
    if (isCloseEnough) {
      float pct = 1 - (length / radius);
      diff.normalize();
      acc.x = acc.x + diff.x * scale * pct;
      acc.y = acc.y + diff.y * scale * pct;
    }
  }
	
  void run() {
    update();
    render();
  }
	
  void update() {
    vel.add(acc);
    pos.add(vel);
  }
	
  void render() {
    stroke(0);
    fill(0);
    ellipse(pos.x, pos.y, 2, 2);
  }
	
  void addDampingForce() {
    acc.x = acc.x - vel.x * damping;
    acc.y = acc.y - vel.y * damping;
  }
	
  void addForce(float x, float y) {
    acc.x = acc.x + x;
    acc.y = acc.y + y;
  }
}
