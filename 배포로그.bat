@echo off
REM ASCII only. Same as manual deploy but logs everything so Claude can read it.
cd /d "%~dp0"
(
echo ==== manual deploy %date% %time% ====
if exist ".git" (
  del /q ".git\index.lock" 2>nul
  del /q ".git\HEAD.lock" 2>nul
)
git add -A
git status --short
git diff --cached --quiet && echo [INFO] no changes to commit || git commit -m "dashboard update manual"
git push -u origin main
echo exit=%ERRORLEVEL%
) > _manual_deploy.log 2>&1
type _manual_deploy.log
echo.
echo === Done. Tell Claude to read _manual_deploy.log ===
pause
