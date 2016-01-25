#include "geometry.h" //Look for header in this directory

/*To implement class methods use <ret_type> <clasname>::<methodname>(...)*/
GfxPoint::GfxPoint( GLfloat xx, GLfloat yy, GLfloat zz){
  x=xx; y=yy; z=zz;
}

//Create a new point from an old point
GfxPoint::GfxPoint(const GfxPoint& other){
  x = other.x; y=other.y; z=other.z;
}

bool GfxPoint::operator==(const GfxPoint& other) const {
  return ( (x==other.x) && (y==other.y) && (z==other.z) );
}


