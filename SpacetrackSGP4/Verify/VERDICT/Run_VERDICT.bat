@echo OFF
echo.
echo *** Starting batch file: Run_VERDICT.bat ...
echo.
title  (SGP4) Run_VERDICT.bat

set bit_size=64
if "%1" == "32" (
    set bit_size=32
)

set exe_name=Verdict_Win%bit_size%.exe

set verdict=..\bin\%exe_name%
if not exist %verdict% set verdict=..\..\bin\%exe_name%

echo.
echo *** Deleting previous files in Reports directory...
if not exist "Reports" mkdir Reports
del /q Reports\*.out

echo.
echo *** Running VERDICT program...

%verdict% SGP4PROP.INI  ..\BaselineWin%bit_size%\rel14_C_LatLonHeight.out  SGP4LLH   	   ..\TestResults\rel14_C_LatLonHeight.out     SGP4LLH        Reports\rel14_C_LatLonHeight.out
%verdict% SGP4PROP.INI  ..\BaselineWin%bit_size%\rel14_C_MeanElem.out      SGP4MEANKEP    ..\TestResults\rel14_C_MeanElem.out         SGP4MEANKEP    Reports\rel14_C_MeanElem.out
%verdict% SGP4PROP.INI  ..\BaselineWin%bit_size%\rel14_C_NodalApPer.out    SGP4NODAL      ..\TestResults\rel14_C_NodalApPer.out       SGP4NODAL      Reports\rel14_C_NodalApPer.out
%verdict% SGP4PROP.INI  ..\BaselineWin%bit_size%\rel14_C_OscElem.out       SGP4OSCKEP     ..\TestResults\rel14_C_OscElem.out          SGP4OSCKEP     Reports\rel14_C_OscElem.out
%verdict% SGP4PROP.INI  ..\BaselineWin%bit_size%\rel14_C_OscState.out      SGP4OSCSTATE   ..\TestResults\rel14_C_OscState.out         SGP4OSCSTATE   Reports\rel14_C_OscState.out

%verdict% SGP4PROP.INI  ..\BaselineWin%bit_size%\sgp4_val_C_LatLonHeight.out  SGP4LLH        ..\TestResults\sgp4_val_C_LatLonHeight.out  SGP4LLH  	     Reports\sgp4_val_C_LatLonHeight.out
%verdict% SGP4PROP.INI  ..\BaselineWin%bit_size%\sgp4_val_C_MeanElem.out      SGP4MEANKEP    ..\TestResults\sgp4_val_C_MeanElem.out      SGP4MEANKEP    Reports\sgp4_val_C_MeanElem.out
%verdict% SGP4PROP.INI  ..\BaselineWin%bit_size%\sgp4_val_C_NodalApPer.out    SGP4NODAL      ..\TestResults\sgp4_val_C_NodalApPer.out    SGP4NODAL      Reports\sgp4_val_C_NodalApPer.out
%verdict% SGP4PROP.INI  ..\BaselineWin%bit_size%\sgp4_val_C_OscElem.out       SGP4OSCKEP     ..\TestResults\sgp4_val_C_OscElem.out       SGP4OSCKEP     Reports\sgp4_val_C_OscElem.out
%verdict% SGP4PROP.INI  ..\BaselineWin%bit_size%\sgp4_val_C_OscState.out      SGP4OSCSTATE   ..\TestResults\sgp4_val_C_OscState.out      SGP4OSCSTATE   Reports\sgp4_val_C_OscState.out
echo.
echo *** Run_VERDICT.bat: Done.  Results are in the Reports directory...
echo.

