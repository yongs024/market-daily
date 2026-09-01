@echo off
REM ASCII only. cmd reads .bat in the OEM codepage and mangles Korean text.
REM
REM Unattended publish: git add -> commit -> push. Vercel redeploys on push.
REM Same as the manual deploy bat but with no pause; logs instead of printing.
REM Registered by the auto-register bat to run on weekdays at 07:10 and 16:30.

cd /d "%~dp0"
set "LOG=%~dp0_deploy.log"

echo ==================================================== >> "%LOG%"
echo  START %date% %time% >> "%LOG%"

where git >nul 2>&1
if errorlevel 1 (
  echo [ERROR] git not on PATH >> "%LOG%"
  exit /b 1
)

REM OneDrive sometimes leaves stale git locks behind.
if exist ".git" (
  del /q ".git\index.lock" 2>nul
  del /q ".git\HEAD.lock" 2>nul
)

git add -A >> "%LOG%" 2>&1
git diff --cached --quiet
if errorlevel 1 (
  for /f "tokens=1-3 delims=/ " %%a in ("%date%") do set "STAMP=%%a-%%b-%%c"
  git commit -m "dashboard update %STAMP%" >> "%LOG%" 2>&1
  git push -u origin main >> "%LOG%" 2>&1
  set "RC=%ERRORLEVEL%"
  if errorlevel 1 (
    echo [ERROR] push failed >> "%LOG%"
  ) else (
    echo  pushed OK >> "%LOG%"
  )
) else (
  echo  no changes >> "%LOG%"
  set "RC=0"
)

echo  END   %date% %time% >> "%LOG%"
echo. >> "%LOG%"
exit /b %RC%
