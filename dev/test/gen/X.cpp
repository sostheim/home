#include "X.hpp"
#include <iostream>

X::X( int size )
try
  : v( size )
{
  std::cout << "X::X()" << std::endl; 
}
catch ( std::bad_alloc ) 
{
   std::cout << "X::X() catch block" << std::endl; 
}
