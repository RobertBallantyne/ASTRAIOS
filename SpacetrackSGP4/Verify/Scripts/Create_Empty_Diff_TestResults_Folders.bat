rem This script is to create empty Diff and TestResults folders that are needed by the V&V run 
rem but weren't saved\ignored in the vandv repo

echo ... Runing Verifying Processes ...

cd ..

set verify_folder=Verify
set parent_folder=%cd%

for /D %%f in (*) do (
    if NOT "%%f"=="Scripts" (
		mkdir %parent_folder%\%%f\%verify_folder%\Diff
		copy .gitkeep %parent_folder%\%%f\%verify_folder%\Diff
		mkdir %parent_folder%\%%f\%verify_folder%\TestResults
		copy .gitkeep %parent_folder%\%%f\%verify_folder%\TestResults
	)
)

cd Scripts
   
