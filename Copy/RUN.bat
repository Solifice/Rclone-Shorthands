@echo off
setlocal enabledelayedexpansion

if not exist INPUT-FOR-BAT.txt (
  echo Error: INPUT-FOR-BAT.txt file does not exist.
  echo Please create the INPUT-FOR-BAT.txt file with your desired details at location %CD%
  goto :ENDOFFILE
)

for /f "tokens=1,2 delims==" %%a in (INPUT-FOR-BAT.txt) do (
  if "%%a" == "RCLONE_PATH" (
    set "RCLONE_PATH=%%b"
  ) else if "%%a" == "RCLONE_CONFIG_PATH" (
    set "RCLONE_CONFIG_PATH=%%b"
  )  else if "%%a" == "SYNC_WORKING_DIRECTORY" (
    set "SYNC_WORKING_DIRECTORY=%%b"
  ) else if "%%a" == "SOU_RCE" (
    set "SOU_RCE=%%b"
  ) else if "%%a" == "DESTI_NATION" (
    set "DESTI_NATION=%%b"
  ) else if "%%a" == "FILTERS_FILE_PATH" (
    set "FILTERS_FILE_PATH=%%b"
  )
)

set /A COUNTER=0

if not "x%RCLONE_PATH%"=="x" (

if not "x%RCLONE_CONFIG_PATH%"=="x" (

	if not "x%SYNC_WORKING_DIRECTORY%"=="x" (
			
			if not "x%SOU_RCE%"=="x" (
			
			if not "x%DESTI_NATION%"=="x" (
			
			echo All the Inputs are available
			echo.
			call :setVariables
			call :checkDryRun
			goto :ENDOFFILE
		) else (
			set /A COUNTER+=5
		)
			
		) else (
			set /A COUNTER+=4
		)
		
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
echo Please check your input.txt file
echo Mandatory Inputs are not given
echo Please provide the input and run the file again...
goto :ENDOFFILE
)

:setVariables

set "LOCALAPPDATA=%SYNC_WORKING_DIRECTORY%"
set "PATH=%PATH%;%RCLONE_PATH%"
set "APPDATA=%RCLONE_CONFIG_PATH%"

if not "x%FILTERS_FILE_PATH%" == "x" (
echo USING FILTERS FROM PATH %FILTERS_FILE_PATH%
echo.
set "FILTERS_FILE_PATH= --filter-from "%FILTERS_FILE_PATH%""
)

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

rclone copy%ARGU_MENT% %SOU_RCE% %DESTI_NATION% %FILTERS_FILE_PATH%
echo.

goto :eof

endlocal

:ENDOFFILE
echo Press any key to exit...
pause>nul
exit