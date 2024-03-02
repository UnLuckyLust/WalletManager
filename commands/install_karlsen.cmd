@REM Written by UnLuckyLust - https://github.com/UnLuckyLust/WalletManager
@echo off
setlocal
cd /d %~dp0
cls
echo [7;94m::: SETUP :::[0m[94m Installing Karlsend v1.1.0... [0m
curl --output karlsend.zip -LO https://github.com/karlsen-network/karlsend/releases/download/v1.1.0/karlsend-v1.1.0-windows-x64.zip 
Call :UnZipFile "%cd%" "%cd%\karlsend.zip"
exit /b
:UnZipFile <ExtractTo> <newzipfile>
set karlsen="%temp%\karlsend.vbs"
if exist %karlsen% del /f /q %karlsen%
>%karlsen%  echo Set fso = CreateObject("Scripting.FileSystemObject")
>>%karlsen% echo If NOT fso.FolderExists(%1) Then
>>%karlsen% echo fso.CreateFolder(%1)
>>%karlsen% echo End If
>>%karlsen% echo set objShell = CreateObject("Shell.Application")
>>%karlsen% echo set FilesInZip=objShell.NameSpace(%2).items
>>%karlsen% echo objShell.NameSpace(%1).CopyHere(FilesInZip)
>>%karlsen% echo Set fso = Nothing
>>%karlsen% echo Set objShell = Nothing
cscript //nologo %karlsen%
if exist %karlsen% del /f /q %karlsen%
set karlsen_src=%cd%\bin
for /f %%a IN ('dir "%karlsen_src%" /b') do move "%karlsen_src%\%%a" "%cd%\"
if exist karlsend.zip del karlsend.zip
rmdir %karlsen_src%
call KarlsenControl.cmd