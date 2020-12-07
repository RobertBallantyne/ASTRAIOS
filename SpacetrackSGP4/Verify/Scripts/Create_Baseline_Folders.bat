rem This script is to create empty Diff and TestResults folders that are needed by the V&V run 
rem but weren't saved\ignored in the vandv repo

echo ... Runing Verifying Processes ...

cd ..

set verify_folder=Verify
set parent_folder=%cd%

for /D %%f in (*) do (
    if NOT "%%f"=="Scripts" (
		rmdir %parent_folder%\%%f\%verify_folder%\BaselineWin32
		rmdir %parent_folder%\%%f\%verify_folder%\BaselineWin64
		rmdir %parent_folder%\%%f\%verify_folder%\BaselineLinux32
		rmdir %parent_folder%\%%f\%verify_folder%\BaselineLinux64
		mkdir %parent_folder%\%%f\BaselineWin32
		mkdir %parent_folder%\%%f\BaselineWin64
		mkdir %parent_folder%\%%f\BaselineLinux32
		mkdir %parent_folder%\%%f\BaselineLinux64
	)
)

cd Scripts
   
