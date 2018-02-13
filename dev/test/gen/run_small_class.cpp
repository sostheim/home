#include "enum_mapper.hpp"
#include "small_class.hpp"
#include <iostream>


int main( void )
{
  small_class sc( );

  std::cout << "run_small_class::main(): sizeof ( small_class )       : " << sizeof ( small_class ) << std::endl;
  std::cout << "                       : sizeof ( enum_mapper< int > ): " << sizeof ( enum_mapper< int > ) << std::endl;
  std::cout << "                       : sizeof ( enum_adder< int > ) : " << sizeof ( enum_adder< int > ) << std::endl;

}
