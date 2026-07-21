@echo off
setlocal
title Herzschlag - Updater aktivieren (einmalig)
cd /d "%~dp0"

echo ==============================================
echo    HERZSCHLAG - Auto-Updater aktivieren
echo ==============================================
echo.

if not exist ".git" (
  echo [FEHLER] Kein Git-Repository gefunden.
  echo Diese Datei muss in C:\herzschlag liegen
  echo (dort, wo auch .git, www und android liegen).
  pause
  exit /b 1
)

rem --- Sind die neuen Dateien da? ---
if not exist "game.html" ( echo [FEHLER] game.html fehlt - ZIP richtig entpackt? & pause & exit /b 1 )
if not exist "version.json" ( echo [FEHLER] version.json fehlt - ZIP richtig entpackt? & pause & exit /b 1 )
findstr /c:"HERZSCHLAG-AUTO-UPDATER" "www\index.html" >nul 2>nul
if errorlevel 1 (
  echo [FEHLER] www\index.html ist nicht der Loader.
  echo Wurde die ZIP wirklich MIT Ordnerstruktur nach C:\herzschlag
  echo entpackt und Ueberschreiben bestaetigt?
  pause
  exit /b 1
)

echo Alle Updater-Dateien liegen richtig. Jetzt wird alles
echo zu GitHub hochgeladen.
echo.
pause

echo [1/3] Lege altes github-push.bat still (Umbenennung) ...
if exist "github-push.bat" ren "github-push.bat" "github-push-ALT-nicht-mehr-nutzen.bat"

echo [2/3] Lade alles zu GitHub hoch ...
git add -A
git commit -m "Auto-Updater eingebaut (Version 1.0.0)"
git push origin main
if errorlevel 1 (
  echo.
  echo [FEHLER] Hochladen fehlgeschlagen (Internet/Anmeldung pruefen).
  echo Danach diese Datei einfach ERNEUT ausfuehren.
  pause
  exit /b 1
)

echo [3/3] Fertig!
echo.
echo ==============================================
echo    WICHTIG - Letzter Schritt:
echo ==============================================
echo Fuehre jetzt EINMAL apk-aktualisieren.bat aus und installiere
echo die neue APK auf dem Handy. Diese APK enthaelt den Loader -
echo danach musst du fuer Spiel-Updates NIE WIEDER eine APK bauen.
echo.
echo Ab jetzt gilt:
echo   - Spiel bearbeiten:  game.html (im Hauptordner)
echo   - Update verteilen:  2-update-veroeffentlichen.bat
echo   - www\index.html NICHT mehr anfassen (das ist der Loader)
echo.
pause
