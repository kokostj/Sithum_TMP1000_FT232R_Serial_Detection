@ECHO OFF

::Checkin whether Software is preinstalled or not
if exist "C:\Program Files (x86)\FTDI\FT_Prog\" ( 
	goto INSTALLED
) else (
	if exist "C:\Program Files\FTDI\FT_Prog\" (
		goto INSTALLED
)else (
		goto UNINSTALLED)
)

:UNINSTALLED
goto loop1
pause

::Checking the internet connection
:loop1 
PING google.com | FIND "time=" > NUL

IF ERRORLEVEL 1 (
echo "connect to the internet and press Enter"
pause >nul
goto loop1)

:: Creates a folder known as METRUM 2 in C drive
mkdir C:\METRUM2

::Get the exact location of the batch file
set batpath=%~dp0

echo "Please wait downloadig started....."

:: This will download the setup zip file 
powershell -command "Invoke-WebRequest https://ftdichip.com/wp-content/uploads/2023/01/FT_Prog_v3.12.31.639-Installer.exe_.zip -Outfile 'C:\METRUM2\setup_ftprog.zip'"   

echo "Finished downloadig the setup file"

:: The zip file will be extracted 
powershell -command "Expand-Archive -Force 'C:\METRUM2\setup_ftprog.zip' 'C:\METRUM2'"

:: The zip file is deleted
del "C:\METRUM2\setup_ftprog.zip"

:: start to run the .exe file with silent installation
"C:\METRUM2\FT_Prog_v3.12.31.639 Installer.exe" /S /norestart

:: The .exe file is deleted
del "C:\METRUM2\FT_Prog_v3.12.31.639 Installer.exe"

:: The folder METRUM2 is also deleted deleted
RD /Q C:\METRUM2

:: Checking whether Program Files (x86) folder is present in computer. In 32bit OS only Program Files folder is present
if exist "C:\Program Files (x86)\" ( 

	::The template file is copied to the ftprog software location
	xcopy /y "%batpath%\FT232R.xml" "C:\Program Files (x86)\FTDI\FT_Prog\Templates\"
	::Changing back the directory to FT Prog folder
	cd "C:\Program Files (x86)\FTDI\FT_Prog\"

) else (

	xcopy /y "%batpath%\FT232R.xml" "C:\Program Files\FTDI\FT_Prog\Templates\"
	::Changing back the directory to FT Prog folder
	cd "C:\Program Files\FTDI\FT_Prog\"
)

::Checking whether the USB Cable is plugged in
:loop2 
:: Programming the ft232 chip
:: The template file (.xml) is generated such that the device description will be "FT232R"
FT_Prog-CmdLine.exe scan prog 0 Templates\FT232R.xml cycl 0 

IF ERRORLEVEL 1 (
echo "Please connect the thermometer with the USB port of the Computer and press ENTER"
pause >nul
goto loop2)


:INSTALLED

set batpath=%~dp0

:: Checking whether Program Files (x86) folder is present in computer. In 32bit OS only Program Files folder is present
if exist "C:\Program Files (x86)\" ( 

	::The template file is copied to the ftprog software location
	xcopy /y "%batpath%\FT232R.xml" "C:\Program Files (x86)\FTDI\FT_Prog\Templates\"
	::Changing back the directory to FT Prog folder
	cd "C:\Program Files (x86)\FTDI\FT_Prog\"
	
) else (

	xcopy /y "%batpath%\FT232R.xml" "C:\Program Files\FTDI\FT_Prog\Templates\"
	::Changing back the directory to FT Prog folder
	cd "C:\Program Files\FTDI\FT_Prog\"
)

::Checking whether the USB Cable is plugged in
:loop4 
:: Programming the ft232 chip
:: The template file (.xml) is generated such that the device description will be "FT232R"
FT_Prog-CmdLine.exe scan prog 0 Templates\FT232R.xml cycl 0 

IF ERRORLEVEL 1 (
echo Please connect the thermometer with the USB port of the Computer and press ENTER
pause >nul
goto loop4
) else (
echo Programmed, connect another thermometer
pause >nul
goto loop4)

