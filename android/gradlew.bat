@ECHO OFF
SETLOCAL

SET APP_HOME=%~dp0
SET WRAPPER_JAR=%APP_HOME%gradle\wrapper\gradle-wrapper.jar

IF EXIST "%WRAPPER_JAR%" (
  IF "%JAVA_HOME%"=="" (
    ECHO JAVA_HOME is not set.
    EXIT /B 1
  )
  "%JAVA_HOME%\bin\java.exe" -classpath "%WRAPPER_JAR%" org.gradle.wrapper.GradleWrapperMain %*
  EXIT /B %ERRORLEVEL%
)

WHERE gradle >NUL 2>NUL
IF %ERRORLEVEL% EQU 0 (
  gradle %*
  EXIT /B %ERRORLEVEL%
)

ECHO Gradle wrapper jar is missing and Gradle is not installed.
ECHO Run "flutter create . --platforms=android" on a machine with Flutter installed to regenerate wrapper binaries.
EXIT /B 1
