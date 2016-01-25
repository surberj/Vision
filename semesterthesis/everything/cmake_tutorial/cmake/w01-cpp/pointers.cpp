#include <cstdio>

using namespace std;

void swap_broken(int x, int y){
  /* copies of x, y made when function called */
  int tmp = y;
  y=x;
  x=tmp;
  return; /* nothing happens in main, only copies modified */
}

void swap_ptr(int* w, int* z){
   /* w and z are pointers to ints. Copies of these pointers 
    * are made when function is called */
  int tmp=*w;
  *w=*z;  /*Here, we are changing the data to which w points, not w itself*/
  *z=tmp;
  return; 
}

void swap_ref(int &x, int &y){ 
  /* The ampersands here, in the function definition indicate that
   * x and y should be passed by reference. A copy is NOT made. Changes 
   * to x,y inside the function are visible outside the function. x and y
   * are still ints, not pointers to ints or something weird
   */
  int tmp=y;
  y=x;
  x=tmp;
  /*I'm tired of typing return. It isn't needed in void functions*/
}

int main() {
  
  int i, j;
  /* p and q are both of type int*, they are pointers to 
   * integers. Their contents is the address of a location in
   * memory that stores an int. The pointers do not store the int
   * itself but simply the address. NULL is special address that 
   * does not point to any real object */
  int *p = NULL, *q = NULL, *s = NULL;   

  i = 10;

  j = i;    /* Copies value of i into j */
  p = &i;   /* &i = the address of i */ 
  q = p;    /* or, try q = &i which is the same! */

  i = i + 1;
  *p = *p + 1;  /* *p dereferences the pointer */

  /* illegal. Cannot dereference a null pointer -> seg fault 
   * just like null pointer exception in Java (where everything is a ptr)*/
  // *s = 5; 

  printf ("    i: %d\n", i);
  printf ("*(&i): %d\n", *(&i));
  printf ("    j: %d\n", j);
  printf ("   *p: %d\n", *p);
  printf ("   *q: %d\n", *q);
  
  /* Pointer uses: 
   *   store/free dynamically created content (using new/delete)
   *   arrays, matrices
   *   modify multiple parameters in a function
   */

  int x=10, y=20;
  printf ("\n\n\nThe swap example\n");
  printf ("x = %d, y = %d\n", x, y);
  printf ("&x = %p, &y = %p\n", &x, &y);

  swap_broken(x, y);
  printf ("After swap_broken\n");
  printf ("x = %d, y = %d\n", x, y);
  printf ("&x = %p, &y = %p\n", &x, &y);
  
  swap_ptr(&x, &y);
  printf ("After swap_ptr\n");
  printf ("x = %d, y = %d\n", x, y);
  printf ("&x = %p, &y = %p\n", &x, &y);

  swap_ref(x, y);
  printf ("After swap_ref\n");
  printf ("x = %d, y = %d\n", x, y);
  printf ("&x = %p, &y = %p\n", &x, &y);

  return 0;
}
