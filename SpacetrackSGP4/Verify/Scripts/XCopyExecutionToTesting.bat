rem This script is to run V&V test cases of each AS software
rem using the 32-bit C-driver and compare the output results (stored in the TestResults folder) 
rem against the expected results (stored in the Baseline folder) 

echo ... Runing Verifying Processes ...

cd ..

set verify_folder=Verify
set parent_folder=%cd%

for /D %%f in (*) do (
    if NOT "%%f"=="Scripts" (
		xcopy /s %parent_folder%\%%f\%verify_folder%\Execution %parent_folder%\%%f\Testing
	)
)

cd Scripts
   
