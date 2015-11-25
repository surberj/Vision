#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/glut.h>
#include <cstdlib> /* for exit */
#include <vector>
#include "geometry.h"
#include "drawable.h"


using namespace std;

vector<GfxPoint> myPoints;
/*Where is this deallocated?*/
Drawable* l1 = new Line(GfxPoint(0, -0.5), GfxPoint(0, 0.5));

void display(){
 
 glClear(GL_COLOR_BUFFER_BIT);
 glColor3f(0.0,0.0,1.0);
 glBegin(GL_POLYGON);
   for(int i=0; i<3; i++){
     glVertex2f(myPoints[i].x, myPoints[i].y);
   }
   glVertex2fv(myPoints[3].ptr());
 glEnd();
 glColor3f(1.,1.,1.);
 l1->draw();
 glFlush();
}

void init(){
  glClearColor(1.0, 0., 0., 0.);
  GfxPoint p1 = GfxPoint(-0.5, -0.5);
  GfxPoint p2 = GfxPoint(p1);
  p2.y=0.5;
  myPoints.push_back(p1);
  myPoints.push_back(p2);
  p2.x=0.5;
  myPoints.push_back(p2);
  myPoints.push_back(GfxPoint(0.5, -0.5));
}

void keyboard(unsigned char key, int x, int y){
  switch(key) {
    case 'q': case 'Q': case 27:
      exit(0);
      break;
  }
}

int main(int argc, char** argv){
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
  glutInitWindowSize(500, 500);
  glutInitWindowPosition(0,0);
  glutCreateWindow("simple");
  glutDisplayFunc(display);
  glutKeyboardFunc(keyboard);
  init();
  glutMainLoop();
  return 0;
}


