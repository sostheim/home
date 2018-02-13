#include <stdio.h>
#include <stdbool.h>

int main ( void )
{
  printf( "Size of ...\n"); 
  printf( "\t         char: %d\n", sizeof( char ) );
  printf( "\tunsigned char: %d\n", sizeof( unsigned char ) );
#ifdef _GLIBCXX_USE_WCHAR_T
  printf( "\t      wchar_t: %d\n", sizeof( wchar_t ) );
#endif
  printf( "\t        short: %d\n", sizeof( short ) );
  printf( "\t        _Bool: %d\n", sizeof( _Bool ) );
  printf( "\t         bool: %d\n", sizeof( bool ) );
  printf( "\t          int: %d\n", sizeof( int ) );
  printf( "\t     unsigned: %d\n", sizeof( unsigned ) );
  printf( "\t         long: %d\n", sizeof( long ) );
  printf( "\t    long long: %d\n", sizeof( long long ) );
  printf( "\t        float: %d\n", sizeof( float ) );
  printf( "\t       double: %d\n", sizeof( double ) );
  printf( "\t         void: %d\n", sizeof( void ) );
  printf( "\t       void *: %d\n", sizeof( void * ) );
  printf( "\t      char[0]: %d\n", sizeof( char[0] ) );
}
