#include "mem.hpp"
#include <iostream>
#include <unistd.h>

void subRoutineContext( int l )
{
  std::cout << "instantiate subRoutineContext( int l )'s Mem object\n";
  Mem memObject;

  std::cout << "malloc subRoutineContext( int l )'s Mem object block\n";
  Mem *mallocObjects = static_cast<Mem *>( malloc( l * sizeof( Mem ) ) );
  if ( 0 == mallocObjects ) 
  {
    std::cout << "malloc of subRoutineContext( int l )'s Mem object block failed\n";
    return;
  }

  std::cout << "new subRoutineContext( int l )'s Mem object block\n";
  Mem *newObjects = 0; 
  try
  {
    newObjects = new Mem[l];
  }
  catch ( std::bad_alloc )
  {
    std::cout << "new of subRoutineContext( int l )'s Mem object block failed\n";
    return;
  }

  std::cout << "\n\tThis is a test of the emergency broadcast system...\n\t";
  for ( int i = 0; i < l; i++ )
  {
    std::cout << "." << std::flush;
    sleep( 1 );
  }
  std::cout << std::endl << std::endl;

  std::cout << "subRoutineContext( int l ) - free( mallocObjects )\n";
  free( mallocObjects );

  std::cout << "subRoutineContext( int l ) - delete newObjects\n";
  delete [] newObjects;

  std::cout << "subRoutineContext( int l )'s objects go out of scope\n";
}


int main( void )
{
  std::cout << "instantiate main( void )'s Mem object\n";
  Mem memory( 1 );
  subRoutineContext( 3 );
  std::cout << "main( void )'s objects go out of scope\n";
}
