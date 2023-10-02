# Flutter Customer Test Registry

[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/flutter/tests/badge)](https://api.securityscorecards.dev/projects/github.com/flutter/tests)

This repository contains references to tests (in the `registry`
directory) that are run with every commit to Flutter to verify that no
breaking changes have been introduced (in the "customer_testing"
shards). The tests referenced by this repository are typically
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

* The tests must pass even if there are analysis 'info' level issues
  in the code. Generally, this means that if the test performs static
  analysis, it does so ignoring info level items (i.e., `flutter
  analyze --no-fatal-infos`).

* The tests must pass at the time they are contributed.

* The upstream repository that hosts the tests must be able to receive patches
  to support the `master` channel of Flutter. This means that CI on the
  upstream repository should use the `master` channel Flutter SDK.

* Dependencies must be pinned. (Generally, checking in the
  `pubspec.lock` file is sufficient for this purpose.) However,
  please avoid pinning packages such as `intl` that are also pinned
  by the Flutter SDK, otherwise when Flutter updates the dependency
  the tests will fail. Consider using `any` for the packages that are
  pinned by the Flutter framework (that way they are automatically
  updated when Flutter updates).


## Running the tests locally

To run these tests locally, check out this directory in a directory
parallel to your `flutter` repository checkout, then, from this
directory, run:

```
pushd ../flutter/dev/customer_testing && flutter pub get && popd
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

    - the people listed as contacts for the test are not responsive (within 72 hours).

    - the test is poorly written (e.g. it contains a race condition or
      relies on assumptions that violate clearly documented API
      contracts), and the people listed as contacts are not willing to
      fix the test or accept fixes for the test.

    - we have gone through the breaking change process cited above,
      but are unable to update the test accordingly (e.g. the people
      listed as contacts are not willing to work with us to update
      their code).

## Private tests

If you have a significant body of tests that you would like to contribute,
but are unable to do so using this registry either because they are proprietary,
or because the volume of tests is too great for our CI, please consider reaching
out on our [Discord server](https://github.com/flutter/flutter/wiki/Chat).

We are willing to add such tests to our CI, under the following conditions:

- you must commit to being very responsive, promptly responding to relevant
  discussions on our Discord during working hours in your time zone.
- you must take responsibility for helping contributors land patches which
  your tests flag as problematic, including providing debugging help.
- you must fund and maintain any tooling necessary for the integration of
  your tests into our system.
- you agree that the integration will be disabled if it has a non-trivial rate
  of false-positives, suffers regular infrastructure failures, or is otherwise
  disruptive to the project.


# SKP Generators

The `skp_generator` directory contains a Flutter program (and
associated shell scripts) to generate test SKPs for the Skia team.

Contributions in the form of stateless widgets showing scenes from
your application are welcome. See the README.md in that directory.
