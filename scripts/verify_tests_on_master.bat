@ECHO ON

REM Fetch Flutter.
git clone https://github.com/flutter/flutter.git || GOTO :END
CALL flutter\bin\flutter doctor -v || GOTO :END

@ECHO.
@ECHO.

REM Now run the tests a bunch of times to try to find flakes (tests that sometimes pass
REM even though they should be failing).
CALL flutter\bin\cache\dart-sdk\bin\dart flutter\dev\customer_testing\run_tests.dart --repeat=15 --skip-template registry/*.test || GOTO :END

@ECHO.
@ECHO.
@ECHO Testing complete.
GOTO :EOF

:END
@ECHO.
@ECHO.
@ECHO Testing failed.
EXIT /B 1
