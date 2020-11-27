#!/bin/bash

# passing parameters: 
# $1=bit size (32, 64)
# $2=path to AS libraries (optional)
# example: ./run_test_cases.sh 32 ../../Lib/Linux32

name=C_Sgp4Prop

echo ""

mkdir -p ../TestResults
rm -f ../TestResults/*

mkdir -p ../Diff
rm -f ../Diff/*

bit_size=64
exe_name=${name}_Linux64
if [[ $1 == 32 ]]; then
    bit_size=32
    exe_name=${name}_Linux32
fi

lib_path=../../Lib/Linux${bit_size}/
if [ ! -d "$lib_path" ]; then
	lib_path=../../../Lib/Linux${bit_size}/
fi

if [[ "$2" != "" ]]; then
	lib_path=$2
fi

export LD_LIBRARY_PATH=$lib_path

for f in input/*.inp; do
    # Create a local variable 
    str=$f

    # strip off the directory path
    str=${str##*/}

    # strip off file extension
    str=${str%.inp}

    cmd="./$exe_name input/${str}.inp ../TestResults/${str} WGS-72 -I$lib_path"
	echo "*********************************************************************"
	echo "$cmd"
	echo "*********************************************************************"
    eval $cmd

    if [[ "$?" != 0 ]]; then
		echo "Error executing $cmd"
        exit 1
    fi
done

echo ""
echo ""
echo "Comparing Files ..."
echo ""

for f in ../BaselineLinux$bit_size/*.out; do
    # Create a local variable 
    str=$f

    # strip off the directory path
    str=${str##*/}

    # strip off file extension
    str=${str%.out}

    cmd="diff ../BaselineLinux$bit_size/${str}.out ../TestResults/${str}.out > ../Diff/${str}.dif"
    echo "$cmd"
    eval $cmd

    if [[ "$?" > 1 ]]; then
		echo "Error executing $cmd"
        exit 1
    fi
done

echo ""
echo "Done.  Diffs are in the ../Diff directory..."
