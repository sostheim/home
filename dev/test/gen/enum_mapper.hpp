#ifndef ENUM_MAPPER_DOT_H
#define ENUM_MAPPER_DOT_H

#include <strstream>
#include <string>
#include <map>

template < typename T >
class enum_mapper
{
public:
  std::map< std::string, T > m_StringsToEnums;
  std::map< T, std::string > m_EnumsToStrings;
  T m_DefaultEnum;

public:
  explicit enum_mapper ( T def ) : m_DefaultEnum( def ) {}
  
  
  inline void add(const char* str, T e)
  {
    m_StringsToEnums[str] = e;
    m_EnumsToStrings[e] = str;
  }    

  inline bool exists ( T val ) const
  {
    typename std::map< T, std::string >::const_iterator it = m_EnumsToStrings.find( val );
    return ( it != m_EnumsToStrings.end() );
  }

  inline bool exists ( const std::string& str ) const
  {
    typename std::map< std::string, T >::const_iterator it = m_StringsToEnums.find( str );
    return ( it != m_StringsToEnums.end() );
  }

  const std::string convert ( T val ) const
  {
    std::string ret;
    typename std::map< T, std::string >::const_iterator it = m_EnumsToStrings.find( val );
    if ( it != m_EnumsToStrings.end() )
    {
      ret = (*it).second;
    }
    else
    {
      std::ostrstream ss;
      ss << "Unidentified ENUM value=" << val << std::ends;
      ret = ss.str ();
      ss.rdbuf()->freeze(0);
    }
    return ret;
  }

  T convert ( const std::string& str ) const
  {
    typename std::map< std::string, T >::const_iterator it = m_StringsToEnums.find( str );
    if ( it != m_StringsToEnums.end() )
    {
      return (*it).second;
    }
    return m_DefaultEnum;
  }
};

template < typename T >
class enum_adder{
public:
  enum_adder( enum_mapper< T >& m, const char* str, T val )
  {
    m.add ( str, val );
  }
};

#endif // ENUM_MAPPER_DOT_H

