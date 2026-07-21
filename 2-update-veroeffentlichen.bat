@echo off
setlocal
title Herzschlag - Update veroeffentlichen
cd /d "%~dp0"

echo ==============================================
echo    HERZSCHLAG - Update veroeffentlichen
echo ==============================================
echo.

if not exist ".git" (
  echo [FEHLER] Kein Git-Repository gefunden.
  pause
  exit /b 1
)
if not exist "game.html" (
  echo [FEHLER] game.html nicht gefunden.
  echo Bitte zuerst 1-updater-einrichten.bat ausfuehren.
  pause
  exit /b 1
)

echo Aktuelle version.json:
if exist "version.json" type version.json
echo.
set /p NEWVER=Neue Versionsnummer (z.B. 1.0.1): 
if "%NEWVER%"=="" ( echo [FEHLER] Keine Version eingegeben. & pause & exit /b 1 )
set /p CHANGES=Was ist neu? (kurz, ohne Anfuehrungszeichen): 
if "%CHANGES%"=="" set CHANGES=Kleinere Verbesserungen

echo.
echo [1/3] Schreibe version.json ...
(
echo {
echo   "version": "%NEWVER%",
echo   "changelog": "%CHANGES%"
echo }
) > version.json

echo [2/3] Aktualisiere index.html fuer GitHub Pages ...
copy /y "game.html" "index.html" >nul

echo [3/3] Lade zu GitHub hoch ...
git add -A
git commit -m "Update %NEWVER%: %CHANGES%"
git push origin main
if errorlevel 1 (
  echo.
  echo [FEHLER] Hochladen fehlgeschlagen. Internet/Anmeldung pruefen
  echo und erneut versuchen.
  pause
  exit /b 1
)

echo.
echo ==============================================
echo  FERTIG! Version %NEWVER% ist online.
echo  - APK-Spieler: Update beim naechsten App-Start
echo    (GitHub-Cache: bis zu ~5 Minuten Verzoegerung)
echo  - Browser: https://kayhartmann.github.io/Herzschlag
echo  KEIN APK-Neubau noetig.
echo ==============================================
echo.
pause
