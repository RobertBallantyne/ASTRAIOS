rem This script is to cleanup all the files that are not needed in the distrubtion package.
rem Files that are in the TestResults, Diff, and Verdict\Reports folders

echo ... Runing Verifying Processes ...

cd ..

set verify_folder=Verify
set parent_folder=%cd%

for /D %%f in (*) do (
    if NOT "%%f"=="Scripts" (
		del /q %parent_folder%\%%f\%verify_folder%\TestResults\*.*
		del /q %parent_folder%\%%f\%verify_folder%\Diff\*.*
		del /q %parent_folder%\%%f\%verify_folder%\VERDICT\Reports\*.*
	)
)

cd Scripts
   
