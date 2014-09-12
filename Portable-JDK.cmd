@ECHO OFF
SETLOCAL EnableDelayedExpansion

REM Backup location for 7-Zip for when localhost doesn't have it
SET "SRC_UNZIP=http://dl.bintray.com/fernando/binaries/7z.exe"

ECHO.
ECHO This script can be used to convert any JDK installation into a portable
ECHO version. The main requirement is to download your preferred JDK installer from
ECHO Oracle prior to proceeding with the conversion.
ECHO.

CHOICE /C NY /M "Do you want to proceed"
ECHO.

IF ERRORLEVEL 2 (
	REM Get user input OR terminate if empty value is entered
	SET /P "JDK_INSTALLER_FULL_PATH=Drag & Drop the JDK Installer Executable here: " || EXIT /B
	SET /P "NEW_JAVA_HOME=Enter location to unpack the JDK: " || EXIT /B
	
	REM Remove double quotations from input since we're adding them later
	SET JDK_INSTALLER_FULL_PATH=!JDK_INSTALLER_FULL_PATH:"=!
	SET NEW_JAVA_HOME=!NEW_JAVA_HOME:"=!
	
	REM Extract folder path & file names for JDK installation
	CALL :EXTRACT_FOLDER_PATH JDK_INSTALLER_FOLDER_PATH "!JDK_INSTALLER_FULL_PATH!"
	CALL :EXTRACT_FILE_NAME JDK_INSTALLER_FILE_NAME "!JDK_INSTALLER_FULL_PATH!"
	
	REM Extract JDK version & architecture type for creating sub folder later
	FOR /F "TOKENS=1,2,3,4 DELIMS=-" %%a IN ("!JDK_INSTALLER_FILE_NAME!") DO (
		SET JDK_VERISON=%%b
		SET JDK_ARCH=%%d
	)
	
	REM Check if target unpack location already contains files and query user for clean-up
	DIR "!NEW_JAVA_HOME!\*" > NUL 2> NUL && (
		ECHO.
		CHOICE /C NY /M "Do you want to clean-up the contents of the unpack target"
		IF ERRORLEVEL 2 (
			IF EXIST "!NEW_JAVA_HOME!\JDK" (
				ECHO Cleaning up "!NEW_JAVA_HOME!\JDK"...
				RMDIR /S /Q "!NEW_JAVA_HOME!\JDK" >NUL 2> NUL
			) ELSE (
				ECHO Cleaning up "!NEW_JAVA_HOME!"...
				RMDIR /S /Q "!NEW_JAVA_HOME!" >NUL 2> NUL
			)
		)
		ECHO.
	)
	
	REM Check if 7-Zip is installed in Program Files, and if not download it
	IF EXIST "%ProgramFiles%\7-Zip\7z.exe" (
		SET "UNZIPPER=%ProgramFiles%\7-Zip\7z.exe"
		ECHO Found unzipping utility...
		ECHO.
	) ELSE IF EXIST "%ProgramFiles(x86)%\7-Zip\7z.exe" (
		SET "UNZIPPER=%ProgramFiles(x86)%\7-Zip\7z.exe"
		ECHO Found unzipping utility...
		ECHO.
	) ELSE (
		SET "TEMP_FOLDER=!NEW_JAVA_HOME!\TEMP_7Z"
		SET "UNZIPPER=!TEMP_FOLDER!\7z.exe"
		
		RMDIR /S /Q "!TEMP_FOLDER!" >NUL 2> NUL
		MKDIR "!TEMP_FOLDER!" >NUL 2> NUL
		
		ECHO Downloading unzipping utility. Please wait for a few seconds...
		ECHO.
	
		PowerShell -Command "Invoke-WebRequest '!SRC_UNZIP!' -OutFile '!UNZIPPER!'"
	)
	
	REM Continue only if 7-Zip was found or downloaded
	IF EXIST "!UNZIPPER!" (
		ECHO Extracting the JDK Setup...
		"!UNZIPPER!" x -o"!NEW_JAVA_HOME!\JDK\!JDK_VERISON!_!JDK_ARCH!" -y "!JDK_INSTALLER_FULL_PATH!" > NUL
		"!UNZIPPER!" x -o"!NEW_JAVA_HOME!\JDK\!JDK_VERISON!_!JDK_ARCH!" -y "!NEW_JAVA_HOME!\JDK\!JDK_VERISON!_!JDK_ARCH!\tools.zip" > NUL

		PUSHD "!NEW_JAVA_HOME!\JDK\!JDK_VERISON!_!JDK_ARCH!"
		
		ECHO Unpacking JAR Files...
		FOR /R %%x IN (*.pack) DO (
			SET "FILE=%%x"
			bin\unpack200 "%%x" "!FILE:~0,-5!.jar"
		)
		
		ECHO Cleaning Up Temporary Files...
		ECHO.
		DEL /F /S /Q *.pack >NUL 2> NUL
		DEL /F /S /Q tools.zip >NUL 2> NUL

		POPD

		REM Remove temp folder used for downloading 7-Zip, only if it was created
		IF EXIST "!TEMP_FOLDER!" RMDIR /S /Q "!TEMP_FOLDER!" >NUL 2> NUL
		
		REM Set the new location as the JAVA_HOME System Environment Variable
		CHOICE /C NY /M "Do you want to point the JAVA_HOME environement variable to the new location"
		IF ERRORLEVEL 2 (
			SETX JAVA_HOME "!NEW_JAVA_HOME!\JDK\!JDK_VERISON!_!JDK_ARCH!" /M > NUL
		)

		ECHO Done.
		ECHO.
	) ELSE (
		ECHO Error while downloading 7z.exe... Please try again later.
		ECHO.
	)
) ELSE IF ERRORLEVEL 1 (
	ECHO Quitting.
	ECHO.
)

GOTO :END

REM Subroutines to extract folder path and file name from fully qualified path
:EXTRACT_FOLDER_PATH <folderPath> <fullPath>
(
    SET "%1=%~dp2"
	EXIT /B
)

:EXTRACT_FILE_NAME <fileName> <fullPath>
(
    SET "%1=%~n2"
	EXIT /B
)

:END
PAUSE
ENDLOCAL