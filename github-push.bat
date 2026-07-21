@echo off
setlocal

rem Wechselt automatisch in den Ordner, in dem diese Batch-Datei liegt
cd /d "%~dp0"

echo ============================================
echo  Herzschlag - GitHub aktualisieren
echo ============================================
echo.
echo Aktueller Ordner: %cd%
echo.

if not exist ".git" (
    echo FEHLER: Kein Git-Repository gefunden.
    echo Diese Batch-Datei muss im Herzschlag-Projektordner liegen
    echo ^(dort, wo auch .git, www, android usw. liegen^).
    echo.
    pause
    exit /b 1
)

rem www\index.html immer ins Root kopieren (fuer GitHub Pages)
if exist "www\index.html" (
    echo Kopiere www\index.html ins Root fuer GitHub Pages...
    copy /Y "www\index.html" "index.html" > nul
    echo OK.
    echo.
)

echo Was wurde geaendert?
echo ^(Kurze Beschreibung eingeben, z.B. "Neue Features" oder Enter fuer Standard^)
set /p COMMIT_MSG="Beschreibung: "
if "%COMMIT_MSG%"=="" set COMMIT_MSG=Herzschlag Update

echo.
echo [1/3] Aenderungen vorbereiten...
git add .
if errorlevel 1 (
    echo FEHLER bei git add. Abgebrochen.
    pause
    exit /b 1
)

echo.
echo [2/3] Commit erstellen: "%COMMIT_MSG%"
git commit -m "%COMMIT_MSG%"
if errorlevel 1 (
    echo.
    echo Hinweis: Keine Aenderungen seit dem letzten Push - nichts zu tun.
    pause
    exit /b 0
)

echo.
echo [3/3] Hochladen nach GitHub...
git push origin main
if errorlevel 1 (
    echo.
    echo FEHLER beim Hochladen. Moegliche Ursachen:
    echo - Keine Internetverbindung
    echo - GitHub-Anmeldung abgelaufen ^(browser-Fenster erscheint^)
    pause
    exit /b 1
)

echo.
echo ============================================
echo  Fertig! GitHub wurde aktualisiert.
echo ============================================
echo.
echo Dein Spiel ist jetzt live unter:
echo   https://kayhartmann.github.io/Herzschlag
echo.
echo GitHub Pages braucht ca. 1-2 Minuten zum
echo Aktualisieren - dann einfach F5 druecken.
echo.
pause
