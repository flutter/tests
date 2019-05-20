set -ex

# Fetch Flutter.
git clone https://github.com/flutter/flutter.git
flutter/bin/flutter doctor -v

# Now run the tests a bunch of times to try to find flakes (tests that sometimes pass
# even though they should be failing).
flutter/bin/cache/dart-sdk/bin/dart flutter/dev/customer_testing/run_tests.dart --repeat=15 --skip-template registry/*.test
