rem This script is to copy latest C-driver executable code from the output folder to the appropriate Veriry\Execution folder
rem passing paramters: %1=debug\release, if none provided, default "debug" value is used
rem echo off
set mode=Debug

if "%1"=="" goto cont
if %1==release set mode=Release

:cont

set execution_folder=Verify\Execution

cd ..

for /D %%f in (*) do (
    set "TRUE="
	if "%%f"=="Sgp4" set TRUE=1
	if "%%f"=="SP" set TRUE=1
	if defined TRUE	(
	   	copy ..\mastersolutions\%mode%\C_%%fProp_Win32.exe .\%%f\%execution_folder%
		copy ..\mastersolutions\x64\%mode%\C_%%fProp_x64.exe .\%%f\%execution_folder%
	) else (
	    if NOT "%%f"=="Scripts" (
			copy ..\mastersolutions\%mode%\C_%%f_Win32.exe .\%%f\%execution_folder%
			copy ..\mastersolutions\x64\%mode%\C_%%f_x64.exe .\%%f\%execution_folder%
		)
	)
)

cd Scripts

