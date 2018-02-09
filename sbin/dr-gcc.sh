#!/bin/bash -
#title       : dr-gcc.sh
#description : Use GNU Compiler to compile a simple single file in to an executelable, 
#            : and optionally run it, in the GCC community docker image based container
#            : https://hub.docker.com/_/gcc/
#            : https://github.com/docker-library/gcc 
#=======================================================================================

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace
# set -o verbose

# Hard coded currently - could/should be a paramter w/ sanity checks.
GCC_VER="7.3.0"

TOOL_CMD="g++"
WORK_DIR="$(pwd)"
SRC_EXT="cpp"
RUN_CMD=false

sbin_dir=$(dirname "${BASH_SOURCE}")
source ${sbin_dir}/utils.sh 

function show_help {
  inf "Usage: \n"
  inf "dr-gcc.sh [flags] \n"
  inf ""
  inf "Description: docker run gcc container"
  inf "             default compilation tool run inside the gcc container is: g++"
  inf ""
  inf "Flags are:"
  inf "  -o <file>       - Write executelable output to <file>"
  inf "  -c|--cmd <cmd>  - Compile tool command <cmd> : default g++"
  inf "  -d|--dir <dir>  - Working directory <dir>    : default current working directory"
  inf "  -e|--ext <ext>  - Source file extension <ext>: default \"cpp\""
  inf "  -r|--run        - Run the successfully compiled binary\n"
  inf "  -h|--help       - Show this help\n"
  inf "Example:"
  inf "  dr-gcc.sh -o hello_world"
}

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
   -c|--cmd)
  TOOL_CMD="$2"
  shift
  ;;
   -d|--dir)
  WORK_DIR="$2"
  shift
  ;;
   -e|--ext)
  SRC_EXT="$2"
  shift
  ;;
   -o)
  OUT_FILE="$2"
  shift
  ;;
  -r|--run)
  RUN_CMD=true
  ;;
  -h|--help)
  SCRIPT_HELP=true
  ;;
  *)
  SCRIPT_HELP=true
  ;;
esac
shift # past argument or value
done

# -h | --help
if [ -n "${SCRIPT_HELP+x}" ]; then
  show_help
  exit 0
fi

# required flag argument
if [ -z "${OUT_FILE+x}" ]; then
  show_help
  exit 1
fi

if [ "${RUN_CMD}" = true ]; then
  docker run --rm -v "${WORK_DIR}":/usr/src/${OUT_FILE} -w /usr/src/${OUT_FILE} gcc:${GCC_VER} /bin/bash -c "${TOOL_CMD} -o ${OUT_FILE} ${OUT_FILE}.${SRC_EXT} && ./${OUT_FILE}"
else
  docker run --rm -v "${WORK_DIR}":/usr/src/${OUT_FILE} -w /usr/src/${OUT_FILE} gcc:${GCC_VER} ${TOOL_CMD} -o ${OUT_FILE} ${OUT_FILE}.${SRC_EXT}
fi 

exit 0
