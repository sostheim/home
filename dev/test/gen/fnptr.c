typedef void (*FnPtr_t)(int);

void realFunction( int x )
{
  // do something
  x++;
}

int main( void )
{
  FnPtr_t fnPtr = realFunction;
  (*fnPtr)( 100 );
}
