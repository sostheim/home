#include "small_class.hpp"
#include <string>
#include <iostream>

#define ADD_VAL( val ) static enum_adder< int > valMapping_##val ( *this, #val, val )

small_class & small_class::instance ( )
{
    static small_class theInstance;

    return theInstance;
}


small_class::small_class ( ) 
  : enum_mapper< int >( -1 )
{
  ADD_VAL( 1 );
  ADD_VAL( 2 );
  ADD_VAL( 3 );
  ADD_VAL( 4 );
  ADD_VAL( 5 );
  ADD_VAL( 6 );
  ADD_VAL( 7 );
  ADD_VAL( 8 );
  ADD_VAL( 9 );
  ADD_VAL( 10 );
  ADD_VAL( 11 );
  ADD_VAL( 12 );
  ADD_VAL( 13 );
  ADD_VAL( 14 );
  ADD_VAL( 15 );
  ADD_VAL( 16 );
  ADD_VAL( 17 );
  ADD_VAL( 18 );
  ADD_VAL( 19 );
}

void small_class::add( int val, const std::string &valName )
{
  if ( 0 != val && 
       false == valName.empty() &&
       false == exists( val ) )
  {
    enum_mapper< int >::add( valName.c_str(), val );
  }
}
