@ECHO ON

REM Fetch Flutter.
git clone https://github.com/flutter/flutter.git || GOTO :END
cd flutter
git config user.email "goderbauer@google.com"
git config user.name "Michael Goderbauer"
git checkout -b goderbauer-allowLongPathNamesInCustomerTests master
git pull https://github.com/goderbauer/flutter.git allowLongPathNamesInCustomerTests
cd ..
CALL flutter\bin\flutter doctor -v || GOTO :END
@ECHO ON

SET PATH=%PATH%;%CD%\flutter/bin;%CD%\flutter\bin\cache\dart-sdk\bin

@ECHO.
@ECHO.

CD flutter\dev\customer_testing
CALL pub get || GOTO :END
@ECHO ON
CD ..\..\..

REM Now run the tests a bunch of times to try to find flakes (tests that sometimes pass
REM even though they should be failing).
@ECHO.
CALL dart flutter\dev\customer_testing\run_tests.dart --repeat=15 --skip-template registry/*.test || GOTO :END
@ECHO ON

@ECHO.
@ECHO.
@ECHO Testing complete.
GOTO :EOF

:END
@ECHO.
@ECHO.
@ECHO Testing failed.
EXIT /B 1
