@echo off
echo ================================================
echo  Fixing git locks + committing + pushing...
echo ================================================
cd /d "C:\Users\BRDC OFFICE\Desktop\CMMS\CMMS NEW"

REM Remove ALL stale git locks
if exist ".git\index.lock" del /f ".git\index.lock"
if exist ".git\HEAD.lock"  del /f ".git\HEAD.lock"
if exist ".git\refs\heads\main.lock" del /f ".git\refs\heads\main.lock"

REM Stage and commit
git add -A
git commit -m "Update: %DATE% %TIME%"

REM Push (force in case of divergence)
git push --force origin main

echo.
echo ================================================
echo  Done! Live at:
echo  https://itbahama.github.io/BRDC-INTRANET/employee-portal.html
echo ================================================
pause
