@echo off
%~dp0/adb.exe connect 127.0.0.1:58526
%~dp0/adb.exe -s 127.0.0.1:58526 install %1
pause