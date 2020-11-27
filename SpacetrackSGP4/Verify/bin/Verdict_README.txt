HQ AFSPC / A9			                                        09-Dec-2009


VERDICT (VERsatile Difference and Compare Tool) is a numerical data file comparision utility written by Dinh Nguyen of HQ AFSPC.   The VERDICT.doc or VERDICT.pdf for additional information. 


This program examines two files and generates a report of differences found in numerical data.  Unlike most other comparision programs, the comparision data can be in different locations in each file and be written in different numerical notation.  An initialization file, written by the user, tells the program what values to read and how to interpret the data.  If differences in the target data are found, the program will provide information on the magnitude of the differences found.  Thus, the user can easily distinguish between a roundoff value and a more serious difference in a file with a large amount of data.


To use the VERDICT program, do the following:

1.  Run the Run_Test_Cases.bat batch file (located in the "Execution" directory) to populate the "TestResults" directory with data.  

2.  Navigate to the VERDICT directory.  Run the Run_VERDICT.bat batch file.

The Run_VERDICT.bat batch file will conduct a file by file comparison of output data contained in the "TestResults" directory with those found in the Baseline directory.  Based on instructions contained in a user-defined .ini file, the program will search two files for differences in the target data and will generate a report on the changes found.

The Run_VERDICT.bat batch file (defined here) will write the output to the "Reports" directory.



Suggestion  #1:  To see an example of the results if no differences are found, modify one of the files to be compared by changing a numeric value (see .ini file for target data).


Suggestion #2:  If you modify the .ini file for your own use, test first with known differences in the targeted data, particular at both ends of the value.  (Counting columns to specify the data to extract can be tedious).  For example, if target field has a value of 0.999999, run against a copy of the file with the value modified to be 1.999991.  Using this strategy, you can determine if the full field is being read for the comparision.  

Future Improvements Planned:
- Print out the raw target data to ensure the entire value is read.








