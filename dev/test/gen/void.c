#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

int main ( void )
{
  printf( "\t    short: %d\n", sizeof( short ) );
  printf( "\t      int: %d\n", sizeof( int ) );

  char *block1 = (char *)malloc( 10 );
  memset( block1, 0, 10 );
 
  struct {
    short a;
    int b;
    int c;
  } block2 = { 255, 269488144, 195935983 };

  printf( "sizeof( block2 ): %d\n", sizeof( block2 ) );
  
  void *v1 = (void *)block1;
  void *v2 = (void *)&block2;

#if defined(__GNUC__)
  void *incrementableVoidStar = (void *)block1;
  printf( "Look ma' - no hands :)\n");
  incrementableVoidStar++;
#endif 

  if ( 0 == v1 )
  {
    printf( "( 0 == v1 ) -> true\n");
  }

  if ( 0 == v2 )
  {
    printf( "( 0 == v2 ) -> true\n");
  }

  if ( v1 == v2 )
  {
    printf( "( v1 == v2 ) -> true\n");
  }
  else
  {
    printf( "( v1 == v2 ) -> false\n");
  }

  memcpy( block1, &block2, sizeof( block2 ) );

  // print the real bytes in the array.
  //
  int i = 0;
  char *ptr = block1;
  printf( "ptr block1: 0x%x :", block1 );
  while ( i++ < sizeof( block2 ) )
  {
    printf ( " %02x", *(unsigned char *)ptr++ );
  }
  printf( "\n" );

  // pointer to short a
  short *sp1 = (short *)block1;

  // pointer to int b
  int   *ip1 = (int *)(block1 + sizeof( short ));

  // pointer to int c
  int   *ip2 = (int *)(block1 + sizeof( short ) + sizeof( int));

  // Print the address of the respective pointers.
  // 
  printf( "ptr sp1: %#x, sizeof( *sp1 ): %d\n", sp1, sizeof( *sp1 ) );
  printf( "ptr ip1: %#x, sizeof( *ip1 ): %d\n", ip1, sizeof( *ip1 ) );
  printf( "ptr ip2: %#x, sizeof( *ip2 ): %d\n", ip2, sizeof( *ip2 ) );

  printf( "block2.a: %d\n", block2.a );
  printf( "block2.b: %d\n", block2.b );
  printf( "block2.c: %d\n", block2.c );

  printf( "block1[2-5]: %d", *ip1 );
  printf( "block1[6-9]: %d", *ip2 );
  printf( "block1[0,1]: %d", *sp1 );

#if defined(__GNUC__)
  //
  // Print the data at our void pointers, 2 bytes for the short, and 4 bytes for each int.
  //
  printf( "v1: 0x%02x, @v1: %02x %02x\n", v1, *(unsigned char *)v1++, *(unsigned char *)(v1++)  );
  printf( "v1: 0x%02x, @v1: %02x %02x %02x %02x\n", v1, 
	                                            *(unsigned char *)v1++, *(unsigned char *)v1++,  
	                                            *(unsigned char *)v1++, *(unsigned char *)v1++  );
  printf( "v1: 0x%02x, @v1: %02x %02x %02x %02x\n", v1, 
	                                            *(unsigned char *)v1++, *(unsigned char *)v1++,  
	                                            *(unsigned char *)v1++, *(unsigned char *)v1++  );
#endif
}
