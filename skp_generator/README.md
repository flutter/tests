# SKP Generator

The script in this directory generates SKPs of Flutter scenes for use
by the Skia team in their regression and performance testing.


## Generating the SKPs

Ensure that `git` and `flutter` are available on the PATH of your
POSIX command line.

Run "build.sh" to generate the SKPs. They will all be placed in the
`skps/` directory if everything is successful.

WARNING!!! THIS SCRIPT DELETES EVERYTHING NEW IN THIS DIRECTORY.
Only files commited to Git before running the script will survive!


## Contributing new scenes

Contributions of scenes are welcome. New scenes should be
significantly distinct from existing scenes (in terms of visuals and
Flutter widgets used to create them), and should either show a scene
that is expensive to rasterize, or show an interesting or complex
scene from a real-world application.

To contribute a scene, create a stateless widget in its own file in
the `lib/tests` directory, then add a reference to that widget from
the `lib/main.dart` file in the array near the top.

Scenes may have variants, e.g. to show several frames from an
animation. This is achieved by passing different arguments to the
stateless widget from the array (see `lib/main.dart` for some
examples). In general, the number of variants should be kept small.

Scenes may have complex visual hierarchies but should avoid
unnecessary widgets. For example, avoid introducing Navigators,
inherited widgets for data models, etc. Leave only the widgets
necessary to create the scene statically in one build.

You can use https://debugger.skia.org/ to make sure that you created
what you expected (click on EndDrawPicture at the end of the op list
to see the final output). The output size is 800x600 at 3dpr.

If you have animations, consider placing all the frames into one image
(side by side) to simulate the cost of rendering the entire animation.


## Developing

To create the test environment, run `build.sh --no-clean`. This will
skip the final step that deletes build artifacts and thus leave the
directory in a state where you can use `flutter run`, the analyzer,
hot reload, and so forth.

You can also edit the `void main()` in `lib/main.dart` to call
`runApp` directly with your test widget (then `return`) so that you
bypass the regular logic and can hot reload while you're doing your
development.


## Troubleshooting

If things don't work, make sure your Flutter version is up to date.
This is intended to work against the latest `master` branch of the
flutter/flutter repo.
