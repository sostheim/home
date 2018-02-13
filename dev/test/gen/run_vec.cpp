#include "vec.hpp"
#include <iostream>
#include <unistd.h>

void subRoutineContext( int l )
{
}

int main( void )
{
  std::cout << "start run_vec::main()\n";

  std::vector< int > v;
  std::vector< int >::iterator itr( v.begin() );

  std::cout << "an vector v: " << v.size() << std::endl;

  std::cout << "we can only do benign operations like boolean comparison (itr == v.end())?: " << ((itr == v.end())?"true":"false") << std::endl;

  std::cout << "what's in an empty vector when we dereference the iterator: " << *itr << std::endl;

  std::cout << "exit main( void )\n";
}
