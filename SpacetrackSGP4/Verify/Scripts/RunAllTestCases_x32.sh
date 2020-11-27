#!/bin/bash

#This script is to run V&V test cases of each AS software
#using the 32-bit C-driver and compare the output results (stored in the TestResults folder) 
#against the expected results (stored in the Baseline folder) 

echo ... Runing Verifying Processes ...

cd ..


for d in */; do
   if [[ "$d" == "bin/" || "$d" == "Scripts/"  || "$d" == "UnitTests/" || "$d" == "buildscripts/" ]]; then
      continue
   fi

   # strip off trailing "/" character
   d=${d%/}

   echo "********************************************************"
   echo "$d"
   echo "********************************************************"
   cd $d/Execution
   if [[ "$d" == "Coco" ]]; then
      ./Run_Coco_Test_Cases.sh 32
   fi

   if [[ "$d" == "ElComp" ]]; then
      ./Run_ElComp_Test_Cases.sh 32
   fi

   if [[ "$d" != "Coco" && "$d" != "ElComp" ]]; then
      ./Run_Test_Cases.sh 32
   fi


   if [[ "$?" != 0 ]]; then
      exit 1
   fi
   cd ../VERDICT
   ./Run_VERDICT.sh 32
   cd ../..
done



