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
  )  else if "%%a" == "BISYNC_WORKING_DIRECTORY" (
    set "BISYNC_WORKING_DIRECTORY=%%b"
  ) else if "%%a" == "RESYNC_YES_NO" (
    set "RESYNC_YES_NO=%%b"
  ) else if "%%a" == "SOU_RCE" (
    set "SOU_RCE=%%b"
  ) else if "%%a" == "DESTI_NATION" (
    set "DESTI_NATION=%%b"
  ) else if "%%a" == "FILTERS_FILE_PATH" (
    set "FILTERS_FILE_PATH=%%b"
  ) else if "%%a" == "RCLONE_LOG_PATH" (
    set "RCLONE_LOG_PATH=%%b"
  )
)

set /A COUNTER=0

if not "x%RCLONE_PATH%"=="x" (

if not "x%RCLONE_CONFIG_PATH%"=="x" (

	if not "x%BISYNC_WORKING_DIRECTORY%"=="x" (
	
		if not "x%RESYNC_YES_NO%"=="x" (
			
			if not "x%SOU_RCE%"=="x" (
			
			if not "x%DESTI_NATION%"=="x" (
			
			if not "x%RCLONE_LOG_PATH%"=="x" (
			echo All the Inputs are available
			echo.
			call :executeCommand
			goto :ENDOFFILE
		) else (
			set /A COUNTER+=7
		)
			
		) else (
			set /A COUNTER+=6
		)
			
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

:executeCommand
echo If paths are valid you will be able to see the changes in your log file
echo.
set "LOCALAPPDATA=%BISYNC_WORKING_DIRECTORY%"
set "PATH=%PATH%;%RCLONE_PATH%"
set "APPDATA=%RCLONE_CONFIG_PATH%"

if not "x%FILTERS_FILE_PATH%" == "x" (
echo USING FILTERS FROM PATH %FILTERS_FILE_PATH%
echo.
set "FILTERS_FILE_PATH= --filters-file "%FILTERS_FILE_PATH%""
)
set "RESYNC="
if "%RESYNC_YES_NO%"=="YES" (
echo RESYNC IS ENABLED
echo.
set "RESYNC= --resync"
)
if "%RESYNC_YES_NO%"=="yes" (
echo RESYNC IS ENABLED
echo.
set "RESYNC= --resync"
)

set "RCLONE_LOG_PATH="%RCLONE_LOG_PATH%""
set "SOU_RCE="%SOU_RCE%""
set "DESTI_NATION="%DESTI_NATION%""

rclone bisync --dry-run --log-file=%RCLONE_LOG_PATH% %SOU_RCE% %DESTI_NATION%%RESYNC% -v%FILTERS_FILE_PATH%

endlocal

:ENDOFFILE
echo Press any key to exit...
pause>nul
exit