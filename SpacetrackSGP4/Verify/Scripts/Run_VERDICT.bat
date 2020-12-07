@setlocal enabledelayedexpansion

@echo OFF

set name=%1
set conf_file=%name%.ini

set bit_size=64
if "%2" == "32" (
    set bit_size=32
)

set exe_name=Verdict_Win%bit_size%.exe

set verdict=..\bin\%exe_name%
if not exist %verdict% set verdict=..\..\bin\%exe_name%


echo.
echo *** Starting batch file: Run_VERDICT.bat ...
echo.

echo.
echo *** Deleting previous files in Reports directory.  OK if none found.
if not exist "Reports" mkdir Reports
del /q Reports\*.out

echo.
echo *** Running VERDICT program... 
echo.
echo.

for %%f in (..\BaselineWin%bit_size%\*.out) do (
	@rem Create a local variable
	set str=%%f
	
	@rem strip off the directory and file extension
	set str=!str:~17,-4!
	
	set cmd=%verdict% %conf_file% ..\BaselineWin%bit_size%\!str!.out %name% ..\TestResults\!str!.out %name% Reports\!str!.out
	echo !cmd!
	!cmd!
	
	rem if !ERRORLEVEL! NEQ 0 (
	rem 	echo "Error executing !cmd!"
	rem 	exit /B 1
	rem )
	
)


echo.
echo *** Run_VERDICT.bat: Done.  Results are in the Reports directory...
echo.
