For Linux users, the "astestpreparation.sh" script needs to run to correct
Windows to Linux issues.  Please run the following commands.

Run: 
sed -i 's/\r$//g' ./Verify/Scripts/astestpreparation.sh

Then run:
./Verify/Scripts/astestpreparation.sh
