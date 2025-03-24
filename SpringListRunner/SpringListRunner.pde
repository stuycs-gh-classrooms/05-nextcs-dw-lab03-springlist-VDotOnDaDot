/* ===================================
SpringListDriver (No Work Goes Here)

This program will work similarly to SpringArrayDriver,
but it will use a linked list of OrbNodes instead of
an array. This driver file is complete, all your work should
be done in the OrbList class. When working, the program can
be controlled as follows:

Keyboard commands:
  1: Create a new list of orbs in a line.
  2: Create a new list of random orbs.
  =: add a new node to the front of the list
  -: remove the node at the front
  SPACE: Toggle moving on/off
  g: Toggle earth gravity on/off

Mouse Commands:
  mousePressed: if the mouse is over an
    orb, remove it from the list.
=================================== */


int NUM_ORBS = 10;
int MIN_SIZE = 10;
int MAX_SIZE = 60;
float MIN_MASS = 10;
float MAX_MASS = 100;
float G_CONSTANT = 1;
float D_COEF = 0.1;

int SPRING_LENGTH = 50;
float  SPRING_K = 0.005;

int MOVING = 0;
int BOUNCE = 1;
int GRAVITY = 2;
int DRAGF = 3;
boolean[] toggles = new boolean[4];
String[] modes = {"Moving", "Bounce", "Gravity", "Drag"};

FixedOrb earth;

OrbList slinky;

void setup() {
  size(1500, 900);

  earth = new FixedOrb(width/2, height * 200, 1, 20000);

  slinky = new OrbList();
  slinky.populate(NUM_ORBS, true);
}//setup

void draw() {
  background(255);
  displayMode();

  slinky.display();

  if (toggles[MOVING]) {

    slinky.applySprings(SPRING_LENGTH, SPRING_K);

    if (toggles[GRAVITY]) {
      slinky.applyGravity(earth, GRAVITY);
    }
    slinky.run(toggles[BOUNCE]);
  }//moving
}//draw

void mousePressed() {
  OrbNode selected = slinky.getSelected(mouseX, mouseY);
  if (selected != null) {
    slinky.removeNode(selected);
  }
}//mousePressed

void keyPressed() {
  if (key == ' ') { toggles[MOVING] = !toggles[MOVING]; }
  if (key == 'g') { toggles[GRAVITY] = !toggles[GRAVITY]; }
  if (key == 'b') { toggles[BOUNCE] = !toggles[BOUNCE]; }
  if (key == 'd') { toggles[DRAGF] = !toggles[DRAGF]; }
  if (key == '=' || key =='+') {
    slinky.addFront(new OrbNode());
  }
  if (key == '-') {
    slinky.removeFront();
  }
  if (key == '1') {
    slinky.populate(NUM_ORBS, true);
  }
  if (key == '2') {
    slinky.populate(NUM_ORBS, false);
  }
}//keyPressed


void displayMode() {
  textAlign(LEFT, TOP);
  textSize(20);
  noStroke();
  int spacing = 85;
  int x = 0;

  for (int m=0; m<toggles.length; m++) {
    //set box color
    if (toggles[m]) { fill(0, 255, 0); }
    else { fill(255, 0, 0); }

    float w = textWidth(modes[m]);
    rect(x, 0, w+5, 20);
    fill(0);
    text(modes[m], x+2, 2);
    x+= w+5;
  }
}//display
