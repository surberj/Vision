#ifndef _GEOMETRY_H
#define _GEOMETRY_H

#include <GL/gl.h>

class GfxPoint{
  public:
    GLfloat x, y, z; /* stored consecutively in memory */

    //Constructors
    GfxPoint( GLfloat x_ = 0, GLfloat y_ = 0, GLfloat z_ = 0);
    GfxPoint( const GfxPoint &); /* copy constructor */
 
    /*Explain inline, const, this, operator overloading, simple functions*/
    inline GLfloat operator[] (int idx) const { return ((GLfloat*)this)[idx]; }
    inline GLfloat* ptr (void){ return (GLfloat*)&x; }
    
    /*define in geometry.cpp */
    bool operator== (const GfxPoint &) const;

  private:
    //helper methods could go here
};
#endif //_GEOMETRY_H

