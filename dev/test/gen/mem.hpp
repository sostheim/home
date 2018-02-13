#ifndef Mem_DOT_H
#define Mem_DOT_H

#include <vector>

class Mem 
{
public:
  Mem( );
  Mem( int size );
  ~Mem();

private:
  std::vector< int > v;
};

#endif

