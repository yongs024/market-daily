@echo off
REM ASCII only. cmd reads .bat in the OEM codepage and mangles Korean text.
REM
REM Registers 배포_무인.bat as TWO scheduled tasks. Run ONCE.
REM   07:10 weekdays - after the 06:30 Claude morning task rebuilds the page
REM   16:30 weekdays - after the 16:00 Claude close task rebuilds the page
REM
REM No pause: it writes the result to _register.log and closes by itself,
REM so it can be launched unattended.
REM
REM First-time note: git push needs credentials. If GitHub has never been
REM authorized on this PC, run 배포.bat manually once and finish the browser
REM sign-in. After that the stored credential lets the task push with no prompt.

setlocal
cd /d "%~dp0"
set "TARGET=%~dp0배포_무인.bat"
set "LOG=%~dp0_register.log"

echo ==================================================== > "%LOG%"
echo  %date% %time%  register deploy tasks >> "%LOG%"
echo  target: %TARGET% >> "%LOG%"

schtasks /Query /TN "MarketDailyDeployAM" >nul 2>&1 && schtasks /Delete /TN "MarketDailyDeployAM" /F >nul 2>&1
schtasks /Create /TN "MarketDailyDeployAM" /TR "\"%TARGET%\"" /SC WEEKLY /D MON,TUE,WED,THU,FRI /ST 07:10 /F >> "%LOG%" 2>&1
set "A=%ERRORLEVEL%"

schtasks /Query /TN "MarketDailyDeployPM" >nul 2>&1 && schtasks /Delete /TN "MarketDailyDeployPM" /F >nul 2>&1
schtasks /Create /TN "MarketDailyDeployPM" /TR "\"%TARGET%\"" /SC WEEKLY /D MON,TUE,WED,THU,FRI /ST 16:30 /F >> "%LOG%" 2>&1
set "B=%ERRORLEVEL%"

echo  AM=%A%  PM=%B%   (0 = success) >> "%LOG%"
schtasks /Query /TN "MarketDailyDeployAM" /FO LIST >> "%LOG%" 2>&1
schtasks /Query /TN "MarketDailyDeployPM" /FO LIST >> "%LOG%" 2>&1
echo  DONE >> "%LOG%"
exit /b 0
