@echo off
:: Creates a folder known as METRUM 2 in C drive
mkdir C:\METRUM2


::Get the exact location of the batch file
set batpath=%~dp0


echo "Please wait downloadig started....."

REM This will download the setup zip file 
powershell -command "Invoke-WebRequest https://ftdichip.com/wp-content/uploads/2023/01/FT_Prog_v3.12.31.639-Installer.exe_.zip -Outfile 'C:\METRUM2\setup_ftprog.zip'"   

echo "Finished downloadig the setup file"

REM The zip file will be extracted 
powershell -command "Expand-Archive -Force 'C:\METRUM2\setup_ftprog.zip' 'C:\METRUM2'"


REM Renaming the .exe file 
REM ren "F:\Veroxlabs_internship\Batch scripting\FT_Prog_v3.12.31.639 Installer.exe" "FT_prog.exe"

REM The zip file is deleted
del "C:\METRUM2\setup_ftprog.zip"

REM start to run the .exe file with silent installation
"C:\METRUM2\FT_Prog_v3.12.31.639 Installer.exe" /S /norestart

REM The .exe file is deleted
REM del "C:\METRUM2\FT_Prog_v3.12.31.639 Installer.exe"

REM changing drives
REM cd /d C:

REM getting the path of the FT prog software
REM cd "C:\Program Files (x86)\FTDI\FT_Prog"

REM opening the software
REM start FT_Prog.exe


REM to copy the FT232R.xml file to the FT_prog software path
xcopy /y "%batpath%\FT232R.xml" "C:\Program Files (x86)\FTDI\FT_Prog\Templates"

REM Programming the ft232 chip
FT_Prog-CmdLine.exe scan prog 0 Templates\FT232R.xml cycl 0 

pause
REM setlocal
REM setlocal enabledelayedexpansion
REM for /f "usebackq tokens=3*" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\FTDI\FT_prog\DC\InstallPath" /s') do (
REM	set ftprog=%%a %%b
REM	start FT_prog.exe
REM	echo !ftprog!)
REM endlocal

