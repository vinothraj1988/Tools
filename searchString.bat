@echo off

SET Destination=C:\Lynx_Web_Api_Logs\

echo off
set CUR_YYYY=%date:~10,4%
set CUR_MM=%date:~4,2%
set CUR_DD=%date:~7,2%
set CUR_HH=%time:~0,2%
if %CUR_HH% lss 10 (set CUR_HH=0%time:~1,1%)

set CUR_NN=%time:~3,2%
set CUR_SS=%time:~6,2%
set CUR_MS=%time:~9,2%

set SUBFILENAME=%CUR_YYYY%%CUR_MM%%CUR_DD%-%CUR_HH%%CUR_NN%%CUR_SS%

REM findstr /n /i /c:"ERROR" %Destination%* > Errorlist.txt

FIND /N "ERROR" %Destination%* > Errorlist_%SUBFILENAME%.txt

if %errorlevel%==0 (
echo Found! logged files into file
) else (
echo No matches found
)
pause