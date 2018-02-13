#include "vec.hpp"
#include <iostream>

Vec::Vec( )
  : s( 0 ),
    v( 0 ),
    itr( v.begin() )
{
  std::cout << "Vec::Vec() catch block" << std::endl;
}

Vec::Vec( int size )
try
: v( s = size ),
  itr( v.begin() )
{
  std::cout << "Vec::Vec( int size )" << std::endl; 
}
catch ( std::bad_alloc ) 
{
  std::cout << "Vec::Vec( int size ): catch block" << std::endl;
}

Vec::~Vec( )
{
  std::cout << "Vec::~Vec()" << std::endl; 
  v.clear();
  itr = v.begin();
}
