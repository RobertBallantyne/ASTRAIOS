rem This script is to run V&V test cases of each AS software
rem using the 32-bit C-driver and compare the output results (stored in the TestResults folder) 
rem against the expected results (stored in the Baseline folder) 

echo ... Runing Verifying Processes ...

set baseline_folder=Verify\Baseline
set parent_folder=%cd%
for /D %%f in (*) do (
    cd %parent_folder%\%%f\%baseline_folder%
    ren *.txt *.out
)

cd %parent_folder%
   
