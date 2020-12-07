rem This script is to run V&V test cases of each AS software
rem using the 32-bit C-driver and compare the output results (stored in the TestResults folder) 
rem against the expected results (stored in the Baseline folder) 

echo ... Runing Verifying Processes ...

cd ..

set execution_folder=Execution
set parent_folder=%cd%
for /D %%f in (*) do (
	if NOT "%%f"=="Scripts" (
		if NOT "%%f"=="bin" (
			cd %parent_folder%\%%f\%execution_folder%
			if "%%f"=="ElComp" (
				Run_%%f_Test_Cases.bat 64
			) else (
				if "%%f"=="Coco" (
					Run_%%f_Test_Cases.bat 64
				) else (
					Run_Test_Cases.bat 64
				)
			)
			cd ..\VERDICT
			.\Run_VERDICT.bat 64
			cd ..\..
		)
	)
)
cd %parent_folder%\Scripts
   
