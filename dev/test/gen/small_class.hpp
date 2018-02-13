#ifndef SMALL_CLASS_DOT_H
#define SMALL_CLASS_DOT_H

#include <string>
#include "enum_mapper.hpp"

class small_class : public enum_mapper< int >
{
  static small_class & instance();
     
private:
  small_class( );
  small_class( const small_class &val );
  small_class &operator=( const small_class &val ); 

  void add( int tag, const std::string &tagName );
};

#endif

