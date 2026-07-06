@echo off
echo ================================================
echo  BRDC Intranet - Push to GitHub
echo ================================================
echo.
cd /d "C:\Users\BRDC OFFICE\Desktop\CMMS\CMMS NEW"

REM Check if git repo already initialized
if exist ".git" (
    echo Git repo already exists, skipping init.
) else (
    echo Initializing git repository...
    git init
)

echo.
echo Adding employee-portal.html...
git add "employee-portal.html"

echo.
echo Committing...
git commit -m "Add employee portal"

echo.
echo Setting branch to main...
git branch -M main

REM Remove old remote if exists
git remote remove origin 2>nul

echo.
echo Adding GitHub remote...
git remote add origin https://github.com/ITBAHAMA/BRDC-INTRANET.git

echo.
echo Pushing to GitHub...
git push -u origin main

echo.
echo ================================================
echo  Done! Check GitHub: https://github.com/ITBAHAMA/BRDC-INTRANET
echo ================================================
pause
