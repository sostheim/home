#include "mem.hpp"
#include <iostream>

Mem::Mem( )
try
  : v( 0 )
{
  std::cout << "Mem::Mem()" << std::endl; 
}
catch ( std::bad_alloc ) 
{
  std::cout << "Mem::Mem() catch block" << std::endl;
}

Mem::Mem( int size )
try
  : v( size )
{
  std::cout << "Mem::Mem( int size )" << std::endl; 
}
catch ( std::bad_alloc ) 
{
  std::cout << "Mem::Mem( int size ): catch block" << std::endl;
}

Mem::~Mem( )
{
  std::cout << "Mem::~Mem()" << std::endl; 
  v.empty();
}
