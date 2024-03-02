@REM Written by UnLuckyLust - https://github.com/UnLuckyLust/WalletManager
@echo off
setlocal
cd /d %~dp0
cls
echo [7;94m::: SETUP :::[0m[94m Installing Sedrad v1.0.0... [0m
curl --output sedrad.zip -LO https://github.com/sedracoin/sedrad/releases/download/v1.0.0/Sedra-v1.0.0.1-win64.zip 
Call :UnZipFile "%cd%" "%cd%\sedrad.zip"
exit /b
:UnZipFile <ExtractTo> <newzipfile>
set sedra="%temp%\sedrad.vbs"
if exist %sedra% del /f /q %sedra%
>%sedra%  echo Set fso = CreateObject("Scripting.FileSystemObject")
>>%sedra% echo If NOT fso.FolderExists(%1) Then
>>%sedra% echo fso.CreateFolder(%1)
>>%sedra% echo End If
>>%sedra% echo set objShell = CreateObject("Shell.Application")
>>%sedra% echo set FilesInZip=objShell.NameSpace(%2).items
>>%sedra% echo objShell.NameSpace(%1).CopyHere(FilesInZip)
>>%sedra% echo Set fso = Nothing
>>%sedra% echo Set objShell = Nothing
cscript //nologo %sedra%
if exist %sedra% del /f /q %sedra%
if exist sedrad.zip del sedrad.zip
call SedraControl.cmd