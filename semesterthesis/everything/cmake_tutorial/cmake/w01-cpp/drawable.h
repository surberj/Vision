#ifndef _DRAWABLE_H
#define _DRAWABLE_H

#include "geometry.h"
#include <GL/gl.h>

/* not much going on here. Functionality in derived classes */
class Drawable {
  public:
    Drawable(){}; //default, empty constructor
    // class can have only a single destructor
    // "virtual" with a destructor means that derived classes can 
    // change the functionality of the base class destructor by 
    // adding their own destructor to clean-up their part of the class
    // (without virtual only the base class destructor is invoked)
    // overriding a destructor has different semantics than overriding
    // a regular function (all destructors are invoked)
    // destructors are called in this order:
    //   1. derived class destructor
    //   2. base class destructor
    virtual ~Drawable() { /*do nothing*/ };

    //Pure virtual function. Must be implemented by derived class
    virtual void draw()=0; 
};

class Line : public Drawable {

   public:
     Line(GfxPoint const& pt1, GfxPoint const& pt2){
       p1=pt1; p2=pt2;
     }
     void draw(){
       glBegin(GL_LINES);
         glVertex2fv(p1.ptr());
         glVertex2fv(p2.ptr());
       glEnd();
     }
     virtual ~Line() {/*do nothing*/};

   private:
     GfxPoint p1, p2;
};

#endif //_DRAWABLE_H
