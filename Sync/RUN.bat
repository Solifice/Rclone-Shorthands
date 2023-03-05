@echo off
setlocal enabledelayedexpansion

set "FILE_NAME=_environmentVariables_.txt"
set "PROFILE_NAME=_profileSettings_.txt"
set "SEARCHPATH=%~dp0"

for %%I in ("%SEARCHPATH%..") do set "PARENTPATH=%%~fI"
echo Parent directory: %PARENTPATH%

set "R_CLONE="%PARENTPATH%\%FILE_NAME%""

if not exist %R_CLONE% (

echo Error: %FILE_NAME% file does not exist.
echo Please download the file from Git Repo and after saving the values place the file to path %PARENTPATH%.
goto :ENDOFFILE

)

for /f "usebackq tokens=1,2 delims==" %%a in (%R_CLONE%) do (
  if "%%a" == "RCLONE_PATH" (
    set "RCLONE_PATH=%%b"
  ) else if "%%a" == "RCLONE_CONFIG_PATH" (
    set "RCLONE_CONFIG_PATH=%%b"
  )  else if "%%a" == "WORKING_DIRECTORY" (
    set "WORKING_DIRECTORY=%%b"
  )
)

set /A COUNTER=0

if not "x%RCLONE_PATH%"=="x" (

if not "x%RCLONE_CONFIG_PATH%"=="x" (

	if not "x%WORKING_DIRECTORY%"=="x" (
	echo working
		) else (
		set /A COUNTER+=3
	) 
	
	) else (
	set /A COUNTER+=2
	)
	) else (
	set /A COUNTER+=1
	)

if %COUNTER% GTR 0 (
echo Please check your %FILE_NAME% file.
echo These are mandatory inputs.
echo Please provide the input and run the file again...
goto :ENDOFFILE
)

set i=0
for /d %%A in ("%SEARCHPATH%\*") do (
  if exist "%%~A\%PROFILE_NAME%" (
    set /a i+=1
    set "folder[!i!]=%%~nxA"
    echo !i!. %%~nxA
  )
)

if %i% equ 0 (
  echo No Folders with Profiles found.
  goto :ENDOFFILE
)

:select
set /p choice="Enter the number of the folder you want to select: "

if not defined choice goto :ENDOFFILE

if not defined folder[%choice%] (
  echo Invalid choice. Please try again.
  goto select
)

echo You selected: %SEARCHPATH%!folder[%choice%]!
set "INPUT_BAT="%SEARCHPATH%!folder[%choice%]!\%PROFILE_NAME%""
echo %INPUT_BAT%

for /f "usebackq tokens=1,2 delims==" %%a in (%INPUT_BAT%) do (
  if "%%a" == "SOU_RCE" (
    set "SOU_RCE=%%b"
  ) else if "%%a" == "DESTI_NATION" (
    set "DESTI_NATION=%%b"
  )
)

set /A COUNT=0
			
if not "x%SOU_RCE%"=="x" (
			
if not "x%DESTI_NATION%"=="x" (
			
echo All the Inputs are available
echo.
call :setVariables
call :checkDryRun
goto :ENDOFFILE
			
) else (

set /A COUNT+=2

)
) else (

set /A COUNT+=1

)

if %COUNT% GTR 0 (
echo It seems the profile you created %PROFILE_NAME% is not provided with required valued
echo Please provide the inputs and run the file again...
goto :ENDOFFILE
)

:setVariables

set "LOCALAPPDATA=%WORKING_DIRECTORY%"
set "PATH=%PATH%;%RCLONE_PATH%"
set "APPDATA=%RCLONE_CONFIG_PATH%"
set "FILTERS_FILE_PATH="%SEARCHPATH%!folder[%choice%]!\_filters_.txt""

if exist %FILTERS_FILE_PATH% (
  echo Filters Found
  echo Applying Filters
  set "FILTERS_FILE_PATH= --filter-from %FILTERS_FILE_PATH%"
) else (
echo There are no filters to apply
)

echo.

set "SOU_RCE="%SOU_RCE%""
set "DESTI_NATION="%DESTI_NATION%""

goto :eof

:checkDryRun

echo Want to dry-run first before proceeding? (press y/n)
set /p DRY_RUN=Your Answer :- 
echo.

if "%DRY_RUN%" == "y" (
call :checkContinue
) else if "%DRY_RUN%" == "n" (

set "ARGU_MENT= -P"
call :executeCommand

) else (
echo Invalid Input
)
goto :eof

:checkContinue

set "ARGU_MENT= --dry-run"
call :executeCommand
echo Do you feel continuing to make actual changes? (press y/n)
set /p CONT_INUE=Your Answer :- 
echo.

if "%CONT_INUE%" == "y" (
set "ARGU_MENT= -P"
call :executeCommand
)

goto :eof

:executeCommand

rclone sync%ARGU_MENT% %SOU_RCE% %DESTI_NATION%%FILTERS_FILE_PATH%
echo.

goto :eof

endlocal

:ENDOFFILE
echo Press any key to exit...
pause>nul
exit