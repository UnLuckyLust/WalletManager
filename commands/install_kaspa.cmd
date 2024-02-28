@REM Written by UnLuckyLust - https://github.com/UnLuckyLust/WalletManager
@echo off
setlocal
cd /d %~dp0
cls
echo [7;94m::: SETUP :::[0m[94m Installing Kaspad v0.12.15... [0m
curl --output kaspad.zip -LO https://github.com/kaspanet/kaspad/releases/download/v0.12.15/kaspad-v0.12.15-win64.zip 
Call :UnZipFile "%cd%" "%cd%\kaspad.zip"
exit /b
:UnZipFile <ExtractTo> <newzipfile>
set kaspa="%temp%\kaspad.vbs"
if exist %kaspa% del /f /q %kaspa%
>%kaspa%  echo Set fso = CreateObject("Scripting.FileSystemObject")
>>%kaspa% echo If NOT fso.FolderExists(%1) Then
>>%kaspa% echo fso.CreateFolder(%1)
>>%kaspa% echo End If
>>%kaspa% echo set objShell = CreateObject("Shell.Application")
>>%kaspa% echo set FilesInZip=objShell.NameSpace(%2).items
>>%kaspa% echo objShell.NameSpace(%1).CopyHere(FilesInZip)
>>%kaspa% echo Set fso = Nothing
>>%kaspa% echo Set objShell = Nothing
cscript //nologo %kaspa%
if exist %kaspa% del /f /q %kaspa%
if exist kaspad.zip del kaspad.zip
call KaspaControl.cmd
