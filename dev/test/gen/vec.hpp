#ifndef vec_dot_h
#define vec_dot_h

#include <vector>

class Vec 
{
public:
  Vec( );
  Vec( int size );
  ~Vec();

public:
  int s;
  std::vector< int > v;
  std::vector< int >::iterator itr;
};

#endif

