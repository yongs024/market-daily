@echo off
REM ASCII only. cmd reads .bat in the OEM codepage and mangles Korean text.
cd /d "%~dp0"

echo ============================================
echo  Publish daily dashboard to Vercel
echo  add -^> commit -^> push  (Vercel auto-deploys)
echo ============================================
echo.

where git >nul 2>&1
if errorlevel 1 (
  echo [ERROR] git is not installed or not on PATH.
  echo         Install Git for Windows: https://git-scm.com/download/win
  pause
  exit /b 1
)

REM This folder lives in OneDrive, which sometimes holds git lock files open
REM and leaves them behind. Nothing else uses this repo, so clearing stale
REM locks here is safe and saves a confusing "repository crashed" error.
if exist ".git" (
  del /q ".git\index.lock" 2>nul
  del /q ".git\HEAD.lock" 2>nul
  del /q ".git\objects\maintenance.lock" 2>nul
  for /r ".git\objects" %%F in (tmp_obj_*) do del /q "%%F" 2>nul
) else (
  echo [SETUP] Creating local repository...
  git init -b main
  git config user.email "yongs024@gmail.com"
  git config user.name "yongs024"
)

REM First run: attach the GitHub remote.
git remote get-url origin >nul 2>&1
if errorlevel 1 (
  echo [SETUP] Adding remote origin...
  git remote add origin https://github.com/yongs024/market-daily.git
  echo.
  echo         Create that EMPTY repo on GitHub first if it does not exist:
  echo         https://github.com/new    name: market-daily    ^(no README^)
  echo.
)

git add -A

git diff --cached --quiet
if errorlevel 1 (
  for /f "tokens=1-3 delims=/ " %%a in ("%date%") do set STAMP=%%a-%%b-%%c
  git commit -m "dashboard update %STAMP%"
) else (
  echo [INFO] No file changes to commit.
)

echo.
echo Pushing to origin/main ...
git push -u origin main
if errorlevel 1 (
  echo.
  echo [ERROR] Push failed.
  echo   - First time? GitHub opens a browser window to sign in.
  echo   - Repo missing? Create it: https://github.com/new  name: market-daily
  echo   - Branch mismatch? Try:  git branch -M main
  pause
  exit /b 1
)

echo.
echo Done. Vercel redeploys within about a minute.
pause
