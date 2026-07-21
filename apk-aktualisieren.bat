@echo off
setlocal

rem Wechselt automatisch in den Ordner, in dem diese Batch-Datei liegt
cd /d "%~dp0"

echo ============================================
echo  Herzschlag - APK aktualisieren
echo ============================================
echo.
echo Aktueller Ordner: %cd%
echo.

if not exist "www\index.html" (
    echo FEHLER: www\index.html wurde nicht gefunden.
    echo Bitte diese Batch-Datei im Projekt-Hauptordner ausfuehren
    echo ^(dort, wo auch der "www"-Ordner liegt^).
    echo.
    pause
    exit /b 1
)

if not exist "android" (
    echo FEHLER: Der "android"-Ordner wurde nicht gefunden.
    echo Falls das die allererste Einrichtung ist, zuerst manuell ausfuehren:
    echo    npm install
    echo    npm install @capacitor/core @capacitor/cli @capacitor/android
    echo    npx cap add android
    echo.
    pause
    exit /b 1
)

echo [1/4] Stelle sicher, dass alle Pakete (inkl. Vibration/Haptics) installiert sind ...
call npm install
if errorlevel 1 (
    echo.
    echo FEHLER bei npm install. Abgebrochen.
    pause
    exit /b 1
)

echo.
echo [2/4] Synchronisiere www/ nach android/ ...
call npx cap sync android
if errorlevel 1 (
    echo.
    echo FEHLER beim Sync. Abgebrochen.
    pause
    exit /b 1
)

echo.
echo [3/4] Baue die APK ...
cd android
call gradlew.bat assembleDebug
if errorlevel 1 (
    echo.
    echo FEHLER beim Bauen. Siehe Meldungen oben.
    cd ..
    pause
    exit /b 1
)
cd ..

echo.
echo [4/4] Fertig!
echo.
if exist "android\app\build\outputs\apk\debug\app-debug.apk" (
    echo APK liegt hier:
    echo   %cd%\android\app\build\outputs\apk\debug\app-debug.apk
    echo.
    echo Vor der Installation auf dem Handy: alte Version zuerst
    echo deinstallieren, dann die neue APK installieren.
) else (
    echo WARNUNG: Build wurde als erfolgreich gemeldet, aber die APK-Datei
    echo wurde am erwarteten Ort nicht gefunden. Bitte pruefen.
)
echo.
pause
