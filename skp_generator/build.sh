#!/bin/bash
# Copyright 2014 The Flutter Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Output each command, and quit immediately if any fail.
set -ex

# This function deletes everything in the entire repository except the
# skps directory and what's already checked into git. This includes,
# for example, the output of `flutter create`, any locally-checked-out
# flutter in the parent directory, and the `build` directory (all of
# these get created by subsequent action in this script).
#
# This function is called immediately on startup below, as well as
# automatically when the script exits (see the "trap" below).
function cleanup() {
    git clean -xffdq -e skps ..
}

# This function returns the actual absolute path of a file path that
# may include symlinks.
#
# In principle we'd use "readlink -f", but on Mac OS, readlink -f
# doesn't work. Instead, this function traverses the path one link at
# a time, and then cds into the link destination to find out where it
# ended up.
#
# The function is enclosed in a subshell (using parentheses instead of
# braces) to avoid changing the working directory of the caller.
function follow_links() (
    cd -P "$(dirname -- "$1")"
    file="$PWD/$(basename -- "$1")"
    while [[ -h "$file" ]]; do
        cd -P "$(dirname -- "$file")"
        file="$(readlink -- "$file")"
        cd -P "$(dirname -- "$file")"
        file="$PWD/$(basename -- "$file")"
    done
    echo "$file"
)

# Delete everything that's not in git, and set up post-run cleanup.
cleanup
if [ "$1" != "--no-clean" ]
then
    trap cleanup EXIT
fi

# If Flutter isn't locally installed, then obtain it and add it to the path.
if ! command -v flutter
then
    pushd ..
    git clone https://github.com/flutter/flutter.git
    export PATH="$PWD/flutter/bin:$PATH"
    popd
fi

# Configure the application to be ready to run.
flutter create .
flutter pub add vm_service

# Remove any previous output and prepare the directory.
rm -rf test skps
mkdir skps

# Obtain all dependencies
flutter packages get

# Update the code in case there have been API changes.
dart fix --apply

# Check for analysis errors. This script fails if this finds any errors.
flutter analyze

# Prepare the application for execution.
flutter build bundle

# This determines the type of binary to use. We try to run the
# application on the local host but using the headless binary so that
# there's no need to have an SDK installed, a device, a graphics
# environment, etc. In particular this means it can run in CI.
case "$(uname -s)" in
    Darwin)
        PLATFORM=darwin-x64
        ;;
    Linux)
        PLATFORM=linux-x64
        ;;
    MINGW*)
        PLATFORM=windows-x64
        ;;
esac

# Using follow_links above, we figure out where the Flutter tool is
# located. We need this so we can get to the binary. We use
# follow_links rather than `which` so that this will work even if your
# flutter tool is a symlink to the actual tool you want to use.
FLUTTER="$(follow_links "$(type -P flutter)")"
BIN_DIR="$(cd "${FLUTTER%/*}" ; pwd -P)"

# Run the flutter_tester binary with our app.
# The output will be placed in the skps/ directory.
# We use --run-forever because the app terminates itself when it's done.
"$BIN_DIR/cache/artifacts/engine/$PLATFORM/flutter_tester" --run-forever --non-interactive --packages=.dart_tool/package_config.json --flutter-assets-dir=build/flutter_assets/ build/flutter_assets/kernel_blob.bin

[ -s skps/flutter_Slate.01.skp ] || (echo 'ERROR! Output is missing expected files!' && exit 1)
