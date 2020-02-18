# Flutter Tests

This repository contains references to tests that are run with every
commit to Flutter to verify that no breaking changes have been
introduced. The tests referenced by this repository are typically
maintained by people outside of the Flutter team, as part of the
development of their applications. They are intended to give the
Flutter team visibility into how their changes affect real-world
developers using Flutter.

## Adding more tests

You are welcome to add a new batch of tests. To do so, copy the file
`registry/template.test` to create a new file in the `registry/`
directory. Fill in the fields and delete all the comments. Then,
submit a PR with this new file.

Tests must fulfill the following criteria to be added:

* All the code must be available publicly on GitHub under a license
  compatible with this effort.

* Tests must be hermetic. For example, a test should not involve
  network activity, spawn processes, or access the local file system
  except to access files that are packaged with the test.

* Tests must be resilient to being run concurrently with other tests,
  including concurrent runs of themselves.

* Tests must be reliable. A test must not claim to pass if it is
  failing. Running a test multiple times in a row must always have the
  same result.

* Tests must have no output when they are passing.

* Tests must be as fast as possible given the hardware. For example,
  tests must not use real timers or depend on the wall clock.

* The time taken by tests must be proportional to their value. A few
  thousands tests are expected to run within a few minutes. An upper
  limit of about five minutes will be applied to each contributed test
  suite (not including the time to download the tests), but it is
  expected that most suites will complete in seconds.

* The tests must be compatible with any tools for automatically
  updating Flutter code (e.g. they cannot rely on custom code
  generation unless such code generation can hook into the automatic
  update mechanism).

* The tests must represent good practices as described in Flutter's
  documentation. For example, using an object after calling its
  `dispose` method violates the contract described by that method.
  Accessing the fields of a private `State` subclass from another
  package by casting it to dynamic is similarly sketchy and would not
  be supported behaviour.

* The tests must pass at the time they are contributed.

* Dependencies must be pinned. (Generally, checking in the
  `pubspec.lock` file is sufficient for this purpose.)


## Running the tests locally

To run these tests locally, check out this directory in a directory
parallel to your `flutter` repository checkout, then, from this
directory, run:

```
pushd ../flutter/dev/customer_testing && pub get && popd
../flutter/bin/cache/dart-sdk/bin/dart ../flutter/dev/customer_testing/run_tests.dart --skip-template --verbose registry/*.test
```

The first command retrieves the Dart packages used by `customer_testing`
and can be omitted for subsequent executions.

## If a test is broken

The point of these tests is to make sure we don't break existing code,
while still being able to make improvements to Flutter APIs.

If you find that a PR you have created in flutter/flutter causes one
these tests to fail, you have the following options:

1. Change your PR so that the test no longer fails. This is the
   preferred option, so long as the result is one we can be proud of.
   Is the resulting API something that you would plausibly come up
   with without the backwards-compatibility constraint? That's good.
   Is the resulting API something that, as soon as you see it, you
   think "why?" or "that's weird"? That's bad. Consider the advice in
   the Style guide:
   https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo

2. Go through the breaking change process, as documented here:
   https://github.com/flutter/flutter/wiki/Tree-hygiene#handling-breaking-changes
   If you're going to do this, you will need to contact the relevant
   people responsible for the breaking test(s) (see the relevant .test
   files), help them fix their code, and update this repository to use
   the new version of their tests, in addition to the steps described
   on the wiki. You will also need to land your change in two parts,
   so that people have time to migrate (a "soft-breaking" change).

3. Remove the test in question. This is by far the least ideal
   solution. To go down this path, we must first establish that one of
   the following is true:

    - the people listed as contacts for the test are not responsive.

    - the test is poorly written (e.g. it contains a race condition or
      relies on assumptions that violate clearly documented API
      contracts), and the people listed as contacts are not willing to
      fix the test or accept fixes for the test.

    - we have gone through the breaking change process cited above,
      but are unable to update the test accordingly (e.g. the people
      listed as contacts are not willing to work with us to update
      their code).
