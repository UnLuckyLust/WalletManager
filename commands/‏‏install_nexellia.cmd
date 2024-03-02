@REM Written by UnLuckyLust - https://github.com/UnLuckyLust/WalletManager
@echo off
setlocal
cd /d %~dp0
cls
echo [7;94m::: SETUP :::[0m[94m Installing Nexelliad v1.0.2... [0m
curl --output nexelliad.zip -LO https://github.com/Nexellia-Network/nexelliad/releases/download/v1.0.2/nexelliad-v1.0.2-windows-x64.zip 
Call :UnZipFile "%cd%" "%cd%\nexelliad.zip"
exit /b
:UnZipFile <ExtractTo> <newzipfile>
set nexellia="%temp%\nexelliad.vbs"
if exist %nexellia% del /f /q %nexellia%
>%nexellia%  echo Set fso = CreateObject("Scripting.FileSystemObject")
>>%nexellia% echo If NOT fso.FolderExists(%1) Then
>>%nexellia% echo fso.CreateFolder(%1)
>>%nexellia% echo End If
>>%nexellia% echo set objShell = CreateObject("Shell.Application")
>>%nexellia% echo set FilesInZip=objShell.NameSpace(%2).items
>>%nexellia% echo objShell.NameSpace(%1).CopyHere(FilesInZip)
>>%nexellia% echo Set fso = Nothing
>>%nexellia% echo Set objShell = Nothing
cscript //nologo %nexellia%
if exist %nexellia% del /f /q %nexellia%
if exist nexelliad.zip del nexelliad.zip
call NexelliaControl.cmd