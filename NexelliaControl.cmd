@REM Written by UnLuckyLust - https://github.com/UnLuckyLust/WalletManager
@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"
@REM -----------------------------------
@REM ↧↧↧ Start of configuration area ↧↧↧
@REM -----------------------------------
@REM ! IMPORTANT ! Change the Nexellia_Folder value to the Nexellia directory path, or place this file in the Nexellia folder.
    set Nexellia_Folder=%cd%

@REM ----------------------
@REM ↧↧↧ Debug Settings ↧↧↧
@REM ----------------------
    set Debug=false
    set shortcut=true
    set shortcut_location=C:\users\%username%\desktop\
    set shortcut_icon=%cd%\NexelliaLogo.ico
@REM ---------------------------------
@REM ↥↥↥ End of configuration area ↥↥↥
@REM ---------------------------------

if exist %Nexellia_Folder% ( cd %Nexellia_Folder% ) else exit
if exist install_nexellia.cmd del install_nexellia.cmd
set p_name=NexelliaControl
set TimeOut=10
mode con: lines=40 cols=130
fsutil dirty query %systemdrive% >nul || (
    if %Debug%==true echo [7;94m::: SETUP :::[0m[94m Requesting administrative privileges... [0m
    set "ELEVATE_CMDLINE=cd /d "%cd%" & call "%~f0" %*"
    findstr "^:::" "%~sf0">"%temp%\getadmin.vbs"
    cscript //nologo "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs" & exit /b
)
rem ------- getadmin.vbs ----------------------------------
::: Set objShell = CreateObject("Shell.Application")
::: Set objWshShell = WScript.CreateObject("WScript.Shell")
::: Set objWshProcessEnv = objWshShell.Environment("PROCESS")
::: strCommandLine = Trim(objWshProcessEnv("ELEVATE_CMDLINE"))
::: objShell.ShellExecute "cmd", "/c " & strCommandLine, "", "runas"
rem -------------------------------------------------------
if %Debug%==true echo [7;92m::: SUCCESS :::[0m[92m Running %p_name% as admin [0m

@REM Nexellia Check
set nexelliadVersion=Nexelliad v1.0.2
set REnexellia=start
if exist %Nexellia_Folder%/nexelliad.exe (
    if exist %Nexellia_Folder%/nexelliawallet.exe (
        @REM if exist %Nexellia_Folder%/nexelliaminer.exe (
            if exist %Nexellia_Folder%/nexelliactl.exe (
                set REnexellia=pass
            ) else (
                echo [7;91m::: ERROR :::[0m[91m Cannot find nexelliactl.exe, make sure this file is located in the Nexellia installation directory. [0m
                set /p REnexellia="[7;96m::: INPUT :::[0m Would you like to download [93m%nexelliadVersion%[0m? ([96mY[0m/[96mN[0m) > "
            )
        @REM ) else (
        @REM     echo [7;91m::: ERROR :::[0m[91m Cannot find nexelliaminer.exe, make sure this file is located in the Nexellia installation directory. [0m
        @REM     set /p REnexellia="[7;96m::: INPUT :::[0m Would you like to download [93m%nexelliadVersion%[0m? ([96mY[0m/[96mN[0m) > "
        @REM )
    ) else (
        echo [7;91m::: ERROR :::[0m[91m Cannot find nexelliawallet.exe, make sure this file is located in the Nexellia installation directory. [0m
        set /p REnexellia="[7;96m::: INPUT :::[0m Would you like to download [93m%nexelliadVersion%[0m? ([96mY[0m/[96mN[0m) > "
    )
) else (
    echo [7;91m::: ERROR :::[0m[91m Cannot find nexelliad.exe, make sure this file is located in the Nexellia installation directory. [0m
    set /p REnexellia="[7;96m::: INPUT :::[0m Would you like to download [93m%nexelliadVersion%[0m? ([96mY[0m/[96mN[0m) > "
)

if "%REnexellia%"=="x" exit
if "%REnexellia%"=="s" (
    call %p_name%.cmd
)
if "%REnexellia%"=="Y" ( set REnexellia=true ) else (
    if "%REnexellia%"=="y" ( set REnexellia=true ) else (
        if %REnexellia%==pass ( set REnexellia=pass ) else set REnexellia=false
    )
)

if %REnexellia%==true (
    echo [7;94m::: SETUP :::[0m[94m Downloading Nexellia files... [0m
    curl --output install_nexellia.cmd -LO https://raw.githubusercontent.com/UnLuckyLust/WalletManager/cmd/commands/install_nexellia.cmd
    call install_nexellia.cmd
) else (
    if %REnexellia%==pass (
        if %Debug%==true echo [7;92m::: SUCCESS :::[0m[92m Nexellia Program Found. [0m
    ) else (
        echo [7;91m::: ERROR :::[0m[91m Can not start, Failed to find Nexellia Program files. [0m
        timeout /t %TimeOut%
        exit  
    )
)

@REM Create Shortcut
set LOG=".\%~N0_runtime.log"
set shortcut_loc=%shortcut_location%\%p_name%.lnk
if %shortcut%==true (
    if exist %shortcut_loc% (
        if %Debug%==true echo [7;94m::: SETUP :::[0m[94m Found existing shortcut. [0m
    ) else (
        set cSctVBS=CreateShortcut.vbs
        ((
        echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
        echo sLinkFile = oWS.ExpandEnvironmentStrings^("!shortcut_loc!"^)
        echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
        echo oLink.TargetPath = oWS.ExpandEnvironmentStrings^("%cd%\%p_name%.cmd"^)
        echo oLink.IconLocation = "%shortcut_icon%"
        echo oLink.WindowStyle = "1"
        echo oLink.WorkingDirectory = "%cd%"
        echo oLink.Save
        )1>!cSctVBS!
        cscript //nologo .\!cSctVBS!
        DEL !cSctVBS! /f /q
        )1>>!LOG! 2>>&1
        if exist !LOG! del !LOG!
        if %Debug%==true echo [7;94m::: SETUP :::[0m[94m Shortcut successfully Created. [0m
    )
)

cls
set Version=1.0.0
echo [7;94m::: INFO :::[0m[94m %p_name% - Version %Version% [0m
echo [7;94m::: INFO :::[0m[94m If you don't have Nexellia Node Running, you must run the command - I - before you can use other commands [0m
echo [7;94m::: INFO :::[0m[94m If you don't have a wallet yet, be sure to create/restore one before you can use wallet-based commands [0m
echo [7;94m::: INFO :::[0m[94m If you don't have Nexellia Daemon Running, you need to run the command - D - to connect the wallet to the node [0m
echo.
echo [7;93m::::::::::::::::::: SETUP COMMANDS [0m
echo [7;95m:::    SETUP    :::[0m[95m -[0m[93m X [0m[95m- Quit Program [0m
echo [7;95m:::    SETUP    :::[0m[95m -[0m[93m S [0m[95m- Force Quit all Nexellia Processes [0m
echo [7;95m:::    SETUP    :::[0m[95m -[0m[93m I [0m[95m- Index Nexellia UTXOs [0m
echo [7;95m:::    SETUP    :::[0m[95m -[0m[93m D [0m[95m- Start Nexellia Daemon [0m
echo [7;95m:::    INFO     :::[0m[95m -[0m[93m N [0m[95m- Show Node Info [0m
echo [7;95m:::    INFO     :::[0m[95m -[0m[93m B [0m[95m- Show Dag Block Info [0m
@REM echo [7;95m:::   MINING    :::[0m[95m -[0m[93m M [0m[95m- Start Mining Nexellia [0m
echo [7;93m::::::::::::::::::: WALLET COMMANDS [0m
echo [7;95m:::   WALLET    :::[0m[95m -[0m[93m C [0m[95m- Create New Wallet [0m
echo [7;95m:::   WALLET    :::[0m[95m -[0m[93m R [0m[95m- Restore Wallet from mnemonic [0m
echo [7;95m:::   WALLET    :::[0m[95m -[0m[93m A [0m[95m- Add New Receiving Address [0m
echo [7;95m:::   WALLET    :::[0m[95m -[0m[93m 1 [0m[95m- Show Balance [0m
echo [7;95m:::   WALLET    :::[0m[95m -[0m[93m 2 [0m[95m- Show Addresses [0m
echo [7;95m:::   WALLET    :::[0m[95m -[0m[93m 3 [0m[95m- Dump UnEncrypted Data [0m
echo [7;95m:::   WALLET    :::[0m[95m -[0m[93m 4 [0m[95m- Sweep from Privat Key [0m
echo [7;95m::: TRANSACTION :::[0m[95m -[0m[93m 5 [0m[95m- Send Nexellia [0m
echo [7;95m::: TRANSACTION :::[0m[95m -[0m[93m 6 [0m[95m- Sign Transtaction [0m
echo [7;95m::: TRANSACTION :::[0m[95m -[0m[93m 7 [0m[95m- Parse Transtaction [0m
echo [7;95m::: TRANSACTION :::[0m[95m -[0m[93m 8 [0m[95m- Broadcast Transtaction [0m
echo [7;95m::: TRANSACTION :::[0m[95m -[0m[93m 9 [0m[95m- Create UnSigned Transection [0m
echo.

@REM Commands
set U_COMMAND==false
set /p U_COMMAND="[7;96m::: INPUT :::[0m Type a command from the list above > "
if "%U_COMMAND%"=="X" exit
if "%U_COMMAND%"=="x" exit
if "%U_COMMAND%"=="s" set U_COMMAND=S
set KILL_CONFIRM=false
if "%U_COMMAND%"=="S" set /p KILL_CONFIRM="[7;96m::: INPUT :::[0m Are you sure you want to disable all Nexellia processes? ([96mY[0m/[96mN[0m) > "
if "%KILL_CONFIRM%"=="Y" set KILL_CONFIRM=true
if "%KILL_CONFIRM%"=="y" set KILL_CONFIRM=true
if "%U_COMMAND%"=="S" (
    if %KILL_CONFIRM%==true (
        taskkill /F /IM nexelliawallet.exe
        @REM taskkill /F /IM nexelliaminer.exe
        taskkill /F /IM nexelliad.exe
        taskkill /F /IM cmd.exe
    )
)
if "%U_COMMAND%"=="i" set U_COMMAND=I
if "%U_COMMAND%"=="I" (
    start cmd /k %Nexellia_Folder%/nexelliad.exe --utxoindex
)
if "%U_COMMAND%"=="d" set U_COMMAND=D
if "%U_COMMAND%"=="D" (
    start cmd /k %Nexellia_Folder%/nexelliawallet.exe start-daemon
)
if "%U_COMMAND%"=="c" set U_COMMAND=C
if "%U_COMMAND%"=="C" (
    %Nexellia_Folder%/nexelliawallet.exe create
    pause
)
if "%U_COMMAND%"=="r" set U_COMMAND=R
if "%U_COMMAND%"=="R" (
    %Nexellia_Folder%/nexelliawallet.exe create -i
    pause
)
if "%U_COMMAND%"=="a" set U_COMMAND=A
if "%U_COMMAND%"=="A" (
    %Nexellia_Folder%/nexelliawallet.exe new-address
    pause
)
if "%U_COMMAND%"=="1" (
    %Nexellia_Folder%/nexelliawallet.exe balance
    %Nexellia_Folder%/nexelliawallet.exe balance -v
    pause
)
if "%U_COMMAND%"=="2" (
    %Nexellia_Folder%/nexelliawallet.exe show-addresses
    pause
)
if "%U_COMMAND%"=="3" (
    %Nexellia_Folder%/nexelliawallet.exe dump-unencrypted-data
    pause
)
set SWEEP_KEY=PRIVET_KEY
set SWEEP_CONFIRM=false
if "%U_COMMAND%"=="4" (
    set /p SWEEP_KEY="[7;96m::: INPUT :::[0m Enter Privat Key to Sweep from > "
)
if "%U_COMMAND%"=="4" (
    echo [7;93m::: INFO :::[0m[93m Sweep Nexellia from Privet key: [0m[96m%SWEEP_KEY%[0m
    set /p SWEEP_CONFIRM="[7;96m::: INPUT :::[0m Send Y to Confirm Sweep > "
)
if "%SWEEP_CONFIRM%"=="Y" set SWEEP_CONFIRM=true
if "%SWEEP_CONFIRM%"=="y" set SWEEP_CONFIRM=true
if "%U_COMMAND%"=="4" (
    if %SWEEP_CONFIRM%==true (
    %Nexellia_Folder%/nexelliawallet.exe sweep -k %SWEEP_KEY%
    pause
    )
)
set SEND_AMOUNT=0
set SEND_TO=WALLET_ADDRESS
set SEND_CONFIRM=false
if "%U_COMMAND%"=="5" (
    set /p SEND_AMOUNT="[7;96m::: INPUT :::[0m Type Amount of Nexellia to Send > "
    set /p SEND_TO="[7;96m::: INPUT :::[0m Nexellia Address to Send the coins > "
)
if "%U_COMMAND%"=="5" (
    echo [7;93m::: INFO :::[0m[93m Sending Amount of [0m[96m%SEND_AMOUNT%[0m[93m Nexellia to Address: [0m[96m%SEND_TO%[0m
    set /p SEND_CONFIRM="[7;96m::: INPUT :::[0m Send Y to Confirm Sending Nexellia > "
)
if "%SEND_CONFIRM%"=="Y" set SEND_CONFIRM=true
if "%SEND_CONFIRM%"=="y" set SEND_CONFIRM=true
if "%U_COMMAND%"=="5" (
    if %SEND_CONFIRM%==true (
        %Nexellia_Folder%/nexelliawallet.exe send --send-amount %SEND_AMOUNT% /t %SEND_TO%
        pause
    )
)
set SIGN_TRANSACTION=TRANSACTION_ID
if "%U_COMMAND%"=="6" (
    set /p SIGN_TRANSACTION="[7;96m::: INPUT :::[0m Enter Transaction ID to Sign > "
)
if "%U_COMMAND%"=="6" (
    %Nexellia_Folder%/nexelliawallet.exe sign --transaction %SIGN_TRANSACTION%
    pause
)
set PARSE_TRANSACTION=TRANSACTION_ID
if "%U_COMMAND%"=="7" (
    set /p PARSE_TRANSACTION="[7;96m::: INPUT :::[0m Enter Transaction ID to Parse > "
)
if "%U_COMMAND%"=="7" (
    %Nexellia_Folder%/nexelliawallet.exe parse --transaction %PARSE_TRANSACTION%
    pause
)
set BROADCAST_TRANSACTION=TRANSACTION_ID
if "%U_COMMAND%"=="8" (
    set /p BROADCAST_TRANSACTION="[7;96m::: INPUT :::[0m Enter Transaction ID to Broadcast > "
)
if "%U_COMMAND%"=="8" (
    %Nexellia_Folder%/nexelliawallet.exe broadcast --transaction %BROADCAST_TRANSACTION%
    pause
)
set UNSIGNED_SEND_AMOUNT=0
set UNSIGNED_SEND_TO=WALLET_ADDRESS
set UNSIGNED_SEND_CONFIRM=false
if "%U_COMMAND%"=="9" (
    set /p UNSIGNED_SEND_AMOUNT="[7;96m::: INPUT :::[0m Type Amount of Nexellia to Send > "
    set /p UNSIGNED_SEND_TO="[7;96m::: INPUT :::[0m Nexellia Address to Send the coins > "
)
if "%U_COMMAND%"=="9" (
    echo [7;93m::: INFO :::[0m[93m This UnSigned Transaction will send Amount of [0m[96m%UNSIGNED_SEND_AMOUNT%[0m[93m Nexellia to Address: [0m[96m%UNSIGNED_SEND_TO%[0m
    set /p UNSIGNED_SEND_CONFIRM="[7;96m::: INPUT :::[0m Send Y to Confirm UnSigned Nexellia Transaction > "
)
if "%UNSIGNED_SEND_CONFIRM%"=="Y" set UNSIGNED_SEND_CONFIRM=true
if "%UNSIGNED_SEND_CONFIRM%"=="y" set UNSIGNED_SEND_CONFIRM=true
if "%U_COMMAND%"=="9" (
    if %UNSIGNED_SEND_CONFIRM%==true (
        %Nexellia_Folder%/nexelliawallet.exe create-unsigned-transaction --send-amount %UNSIGNED_SEND_AMOUNT% /t %UNSIGNED_SEND_TO%
        pause
    )
)
@REM if "%U_COMMAND%"=="m" set U_COMMAND=M
@REM set MINER_ADDR=WALLET_ADDRESS
@REM set MINER_CONFIRM=false
@REM if "%U_COMMAND%"=="M" (
@REM     set /p MINER_ADDR="[7;96m::: INPUT :::[0m Enter a wallet address you want to mine to > "
@REM )
@REM if "%U_COMMAND%"=="M" (
@REM     echo [7;93m::: INFO :::[0m[93m Starting to Mine Nexellia to Wallet Address: [0m[96m%MINER_ADDR%[0m
@REM     set /p MINER_CONFIRM="[7;96m::: INPUT :::[0m Send Y to Start Mining Nexellia > "
@REM )
@REM if "%MINER_CONFIRM%"=="Y" set MINER_CONFIRM=true
@REM if "%MINER_CONFIRM%"=="y" set MINER_CONFIRM=true
@REM if "%U_COMMAND%"=="M" (
@REM     if %MINER_CONFIRM%==true (
@REM         start cmd /k %Nexellia_Folder%/nexelliaminer.exe --miningaddr %MINER_ADDR%
@REM     )
@REM )
if "%U_COMMAND%"=="n" set U_COMMAND=N
if "%U_COMMAND%"=="N" (
    %Nexellia_Folder%/nexelliactl.exe GetInfo
    pause
)
if "%U_COMMAND%"=="b" set U_COMMAND=B
if "%U_COMMAND%"=="B" (
    %Nexellia_Folder%/nexelliactl.exe GetBlockDagInfo
    pause
)
set U_COMMAND=false
call NexelliaControl.cmd
