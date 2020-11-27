#!/bin/bash

name=$1
conf_file=$name.ini

# Set the bit size but default to 64
bit_size="64"
if [ "$#" -gt 1 ]; then
    if [ "$2" -eq "32" ]; then
        bit_size="32" #setting here in case user passed in bit size of some odd number
    fi
fi

exe_name=Verdict_Linux$bit_size
verdict=../bin/$exe_name
if [ ! -f $verdict ]; then
	verdict=../../bin/$exe_name
fi


echo ""
echo """*** Starting batch file: Run_VERDICT.bat ..."
echo ""

echo ""
echo """*** Deleting previous files in Reports directory.  OK if none found."
mkdir -p Reports
rm -f Reports/*.out

echo ""
echo """*** Running VERDICT program..."
echo ""
echo ""

for f in ../BaselineLinux$bit_size/*.out; do
    # Create a local variable 
    str=$f

    # strip off the directory path
    str=${str##*/}

    # strip off file extension
    str=${str%.out}
	
	cmd="$verdict $conf_file ../BaselineLinux$bit_size/${str}.out $name ../TestResults/${str}.out $name Reports/${str}.out"
	echo "$cmd"
	eval $cmd
	
	# if [[ "$?" != 0 ]]; then
	# 	echo "Error executing $cmd"
	# 	exit 1
    # fi
	
done


echo ""
echo """*** Run_VERDICT.bat: Done.  Results are in the Reports directory..."
echo ""
