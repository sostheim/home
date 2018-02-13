# Caution!!!
This environment is very outdated and should be reviewed and updated before being used in any meaningful project.

# Vagrant Environment
The C++ project development environment is defined in the following Vagrantfile and the corresponding bootstrap.sh.  These files should be easily adaptable to any vagrant environment, but they based off of the patter from https://github.com/strux/codemachine.

The bootstrap takes care of building the system dependencies, most of which are fairly apt-get installable and therefore very straight forward.  There is at least one dependencies to watch out for however...

## POCO C++ Libraries Project
The one to watch out for is POCO Project (https://github.com/pocoproject/poco) which must be downloaded and built.  If the build is successful the appropriate header files and libraries are installed on the devbox and can be complied / linked against.  If the build fails, then the vagrant user's home directory will contain a ~/poco directory in a partially built state.  
