#!/bin/bash
set -e
trap 'echo "Error occurred at line $LINENO"; exit 1;' ERR

# Default values
SHARDS=1
SHARD_INDEX=0
LOCAL_FLUTTER=0
REPEAT=
TESTS=()

function usage() {
  echo "Usage: ${BASH_SOURCE[0]} [--shards <num>|-n <num>] [--shard-index <num>|-i <num>] "
  echo "                         [--local-flutter|-l] [--repeat <num>|-r <num>] [--help|-h] [<specific tests>...]"
  echo ""
  echo "  --shards <num>:      Specifies the total number of shards that are being run."
  echo "  --shard-index <num>: Specifies the index of the current shard to be executed."
  echo "  --local-flutter:     Indicates that the local Flutter installation should be used."
  echo "  --repeat <num>:      The number of times to repeat each test. Defaults to 15 unless --local-flutter is set."
  echo "  --help:              Displays this usage information."
  echo "  <specific tests>...: Specifies the individual tests to be executed."
}

while getopts "n:i:r:lh" opt; do
  case $opt in
    n) SHARDS="$OPTARG" ;;
    i) SHARD_INDEX="$OPTARG" ;;
    r) REPEAT="$OPTARG" ;;
    l) LOCAL_FLUTTER=1 ;;
    h) usage; exit 0 ;;
    *) usage; exit 1 ;;
  esac
done
shift $((OPTIND -1))

# Default REPEAT value if not set
REPEAT=${REPEAT:-15}
[[ $LOCAL_FLUTTER -eq 1 ]] && REPEAT=1

if [[ ${#@} -eq 0 ]]; then
  TESTS=(registry/*.test)
else
  TESTS=("$@")
fi

if [[ $LOCAL_FLUTTER -eq 1 ]]; then
  FLUTTER_DIR=$(flutter --machine --version | grep "flutterRoot" | awk '{print $2}' | sed -e 's/"//g')
  echo "Using Flutter in $FLUTTER_DIR"
else
  FLUTTER_DIR="$PWD/flutter"
  if [ ! -d "$FLUTTER_DIR" ]; then
    git clone https://github.com/flutter/flutter.git "$FLUTTER_DIR"
  fi
  export PATH="$FLUTTER_DIR/bin:$FLUTTER_DIR/bin/cache/dart-sdk/bin:$PATH"
  "$FLUTTER_DIR/bin/flutter" doctor -v
fi

(cd "$FLUTTER_DIR/dev/customer_testing" && "$FLUTTER_DIR/bin/dart" pub get)

"$FLUTTER_DIR/bin/dart" "$FLUTTER_DIR/dev/customer_testing/run_tests.dart" \
  --shards "$SHARDS" --shard-index "$SHARD_INDEX" --skip-template --repeat="$REPEAT" \
  --verbose "${TESTS[@]}"
