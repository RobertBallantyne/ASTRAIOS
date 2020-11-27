@setlocal enabledelayedexpansion

@rem passing parameters: 
@rem %1=bit size (32, 64)
@rem %2=path to AS libraries (optional)
@rem example: .\run_test_cases.sh 32 ..\..\Lib\Win32

@echo off

set name=C_Sgp4Prop

echo.

if not exist "..\TestResults" mkdir ..\TestResults
del /q ..\TestResults\*.*

if not exist "..\Diff" mkdir ..\Diff
del /q ..\Diff\*.*

set bit_size=64
set exe_name=%name%_x64.exe
if "%1" == "32" (
    set bit_size=32
	set exe_name=%name%_Win32.exe
)

set lib_path=..\..\Lib\Win%bit_size%\
if not exist %lib_path% set lib_path=..\..\..\Lib\Win%bit_size%\
if not "%2" == "" (
	set lib_path=%2
)
set path=%lib_path%;%path%

for %%f in (input\*.inp) do (
	@rem Create a local variable
	set str=%%f
	
	@rem strip off the directory (i.e.. "..\input\") and file extension (i.e.. ".inp")
	set str=!str:~6,-4!
	
	set cmd=%exe_name% input\!str!.inp ..\TestResults\!str! -I%lib_path%
	echo *********************************************************************
	echo !cmd!
	echo *********************************************************************
	!cmd!
	
	if !ERRORLEVEL! NEQ 0 (
		echo "Error executing !cmd!"
		exit /B 1
	)
)

echo.                                                                                   
echo.                                                                                   
echo Comparing Files ...                                                                
echo.

for %%f in (..\BaselineWin%bit_size%\*.out) do (
	@rem Create a local variable
	set str=%%f
	
	@rem strip off the directory and file extension
	set str=!str:~17,-4!

	set cmd=\Windows\System32\fc /N /W /C  ..\BaselineWin%bit_size%\!str!.out  ..\TestResults\!str!.out ^> ..\Diff\!str!.dif
    echo !cmd!
	\Windows\System32\fc /N /W /C ..\TestResults\!str!.out ..\BaselineWin%bit_size%\!str!.out > ..\Diff\!str!.dif
	
	@rem fc command returns -1 if an error occurred not 1 like other apps
	if !ERRORLEVEL! == -1 (
		echo "Error executing !cmd!"
		exit /B 1
	)
)

echo.
echo  Done.   Diffs are in the ..\Diff directory...
rem pause   

exit /B 0
