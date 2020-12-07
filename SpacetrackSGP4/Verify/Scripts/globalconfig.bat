rem passing paramters: %1=debug\release; %2=architect (32, 64)
set mode=Debug
if %1==release set mode=Release

set arc=Win32
if %2==64 set arc=x64

set aspath=..\..\..\..\Lib_%arc%\%mode%\