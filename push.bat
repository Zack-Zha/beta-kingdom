@echo off
cd /d "%~dp0"
echo === Beta Kingdom - Push to GitHub ===
echo.

git add -A

set /p MSG="Commit message (回车用默认): "
if "%MSG%"=="" set MSG=update

git commit -m "%MSG%"
git push origin main

echo.
echo === Done ===
pause
