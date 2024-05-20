set -e

# Default values.
SHARDS=1
SHARD_INDEX=0
LOCAL_FLUTTER=0
REPEAT=
TESTS=()

function usage() {
  echo "Usage: ${BASH_SOURCE[0]} [--shards <num>|-n <num>] [--shard-index <num>|-i <num>] "
  echo "                         [--local-flutter] [--help] [<specific tests>...]"
  echo ""
  echo "  --shards <num>:      Specifies the total number of shards that are being run."
  echo "  --shard-index <num>: Specifies the index of the current shard to be executed."
  echo "  --local-flutter:     Indicates that the local Flutter installation should be used"
  echo "                       instead of cloning the Flutter repo. Used to reproduce test "
  echo "                       failures locally."
  echo "  --repeat:            The number of times to repeat each test, to check for flakiness."
  echo "                       Defaults to 1 if --local-flutter is set, 15 otherwise."
  echo "  --help:              Displays the usage information for the script and exits."
  echo "  <specific tests>...: Specifies the individual tests to be executed. If none are"
  echo "                       specified, all of the tests in the 'registry' directory are run."
}

# Parse given command for variables.
 while (( "$#" )); do
  arg="$1"
  case $arg in
      -n|--shards)
      shift
      SHARDS="$1"
      ;;
      -i|--shard-index)
      shift
      SHARD_INDEX="$1"
      ;;
      -r|--repeat)
      shift
      REPEAT="$1"
      ;;
      --local-flutter)
      LOCAL_FLUTTER=1
      ;;
      --help)
      usage
      exit
      ;;
      *)
      TESTS=("${tests[@]}" "$1")
      ;;
  esac
  shift
done
set -x

if [[ ${#TESTS[@]} -eq 0 ]]; then
  # Not quoted, to expand glob.
  TESTS=(registry/*.test)
fi

if [[ $LOCAL_FLUTTER -eq 1 ]]; then
  # Use the flutter command that is in the path and get its location.
  FLUTTER_DIR=$(flutter --machine --version | grep "flutterRoot" | awk '{print $2}' | sed -e 's/"//g')
  echo "Using Flutter in $FLUTTER_DIR"
  REPEAT=${REPEAT:-1}
else
  # Fetch Flutter.
  git clone https://github.com/flutter/flutter.git
  FLUTTER_DIR="$PWD/flutter"
  "$FLUTTER_DIR/bin/flutter" doctor -v

  # Put Flutter at the start of the PATH because the OS image may contain
  # another version of Flutter.
  export PATH="$FLUTTER_DIR/bin:$FLUTTER_DIR/bin/cache/dart-sdk/bin:$PATH"

  # In CI, run the tests a bunch of times to try to find flakes (tests that
  # sometimes pass even though they should be failing).
  REPEAT=${REPEAT:-15}
fi

(cd "$FLUTTER_DIR/dev/customer_testing" && "$FLUTTER_DIR/bin/dart" pub get)

"$FLUTTER_DIR/bin/dart" "$FLUTTER_DIR/dev/customer_testing/run_tests.dart" \
  --shards "$SHARDS" --shard-index "$SHARD_INDEX" --skip-template --repeat="$REPEAT" \
  --verbose "${TESTS[@]}"
