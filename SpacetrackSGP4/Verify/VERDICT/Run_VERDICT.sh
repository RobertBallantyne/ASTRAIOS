#!/bin/bash

echo ""
echo *** Starting batch file: Run_VERDICT.bat ...
echo ""

bit_size=64
if [[ "$1" == "32" ]]; then
    bit_size=32
fi

exe_name=Verdict_Linux${bit_size}
verdict=../bin/$exe_name
if [ ! -f $verdict ]; then
	verdict=../../bin/$exe_name
fi

echo ""
echo """*** Deleting previous files in Reports directory.  OK if none found."
mkdir -p Reports
rm -f Reports/*.out

echo ""
echo *** Running VERDICT program...

$verdict Sgp4Prop.ini  ../BaselineLinux$bit_size/rel14_C_LatLonHeight.out  SGP4LLH   	   ../TestResults/rel14_C_LatLonHeight.out     SGP4LLH        Reports/rel14_C_LatLonHeight.out
$verdict Sgp4Prop.ini  ../BaselineLinux$bit_size/rel14_C_MeanElem.out      SGP4MEANKEP    ../TestResults/rel14_C_MeanElem.out         SGP4MEANKEP    Reports/rel14_C_MeanElem.out
$verdict Sgp4Prop.ini  ../BaselineLinux$bit_size/rel14_C_NodalApPer.out    SGP4NODAL      ../TestResults/rel14_C_NodalApPer.out       SGP4NODAL      Reports/rel14_C_NodalApPer.out
$verdict Sgp4Prop.ini  ../BaselineLinux$bit_size/rel14_C_OscElem.out       SGP4OSCKEP     ../TestResults/rel14_C_OscElem.out          SGP4OSCKEP     Reports/rel14_C_OscElem.out
$verdict Sgp4Prop.ini  ../BaselineLinux$bit_size/rel14_C_OscState.out      SGP4OSCSTATE   ../TestResults/rel14_C_OscState.out         SGP4OSCSTATE   Reports/rel14_C_OscState.out

$verdict Sgp4Prop.ini  ../BaselineLinux$bit_size/rel14_type4_C_LatLonHeight.out  SGP4LLH   	../TestResults/rel14_type4_C_LatLonHeight.out     SGP4LLH        Reports/rel14_type4_C_LatLonHeight.out
$verdict Sgp4Prop.ini  ../BaselineLinux$bit_size/rel14_type4_C_MeanElem.out      SGP4MEANKEP    ../TestResults/rel14_type4_C_MeanElem.out         SGP4MEANKEP    Reports/rel14_type4_C_MeanElem.out
$verdict Sgp4Prop.ini  ../BaselineLinux$bit_size/rel14_type4_C_NodalApPer.out    SGP4NODAL      ../TestResults/rel14_type4_C_NodalApPer.out       SGP4NODAL      Reports/rel14_type4_C_NodalApPer.out
$verdict Sgp4Prop.ini  ../BaselineLinux$bit_size/rel14_type4_C_OscElem.out       SGP4OSCKEP     ../TestResults/rel14_type4_C_OscElem.out          SGP4OSCKEP     Reports/rel14_type4_C_OscElem.out
$verdict Sgp4Prop.ini  ../BaselineLinux$bit_size/rel14_type4_C_OscState.out      SGP4OSCSTATE   ../TestResults/rel14_type4_C_OscState.out         SGP4OSCSTATE   Reports/rel14_type4_C_OscState.out

$verdict Sgp4Prop.ini  ../BaselineLinux$bit_size/sgp4_val_C_LatLonHeight.out  SGP4LLH        ../TestResults/sgp4_val_C_LatLonHeight.out  SGP4LLH  	     Reports/sgp4_val_C_LatLonHeight.out
$verdict Sgp4Prop.ini  ../BaselineLinux$bit_size/sgp4_val_C_MeanElem.out      SGP4MEANKEP    ../TestResults/sgp4_val_C_MeanElem.out      SGP4MEANKEP    Reports/sgp4_val_C_MeanElem.out
$verdict Sgp4Prop.ini  ../BaselineLinux$bit_size/sgp4_val_C_NodalApPer.out    SGP4NODAL      ../TestResults/sgp4_val_C_NodalApPer.out    SGP4NODAL      Reports/sgp4_val_C_NodalApPer.out
$verdict Sgp4Prop.ini  ../BaselineLinux$bit_size/sgp4_val_C_OscElem.out       SGP4OSCKEP     ../TestResults/sgp4_val_C_OscElem.out       SGP4OSCKEP     Reports/sgp4_val_C_OscElem.out
$verdict Sgp4Prop.ini  ../BaselineLinux$bit_size/sgp4_val_C_OscState.out      SGP4OSCSTATE   ../TestResults/sgp4_val_C_OscState.out      SGP4OSCSTATE   Reports/sgp4_val_C_OscState.out
echo ""
echo *** Run_VERDICT.bat: Done.  Results are in the Reports directory...
echo ""

