#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/glut.h>
#include <cstdlib> /* for exit */

using namespace std;

void display(){
 glClear(GL_COLOR_BUFFER_BIT);
 glBegin(GL_POLYGON);
   glVertex2f(-0.5, -0.5);
   glVertex2f(-0.5, 0.5);
   glVertex2f(0.5, 0.5);
   glVertex2f(0.5, -0.5);
 glEnd();
 glFlush();
}

void init(){
  glClearColor(1.0, 0., 0., 0.);
  glColor3f(0.,0.,1.);
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


