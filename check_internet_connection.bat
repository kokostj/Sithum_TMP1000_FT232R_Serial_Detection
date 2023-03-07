@ECHO OFF

:loop 
PING google.com | FIND "time=" > NUL

IF ERRORLEVEL 1 (
echo "connect to the internet and press Enter"
pause >nul
goto loop)

echo "You have an active connection"
pause

