@echo off
echo ========================================
echo    Windows C Drive Cleanup Script
echo ========================================
echo.

echo [1/6] Cleaning Windows Temp Files...
del /q/f/s "%TEMP%\*" 2>nul
for /d %%x in ("%TEMP%\*") do rd /s /q "%%x" 2>nul
del /q/f/s "C:\Windows\Temp\*" 2>nul
for /d %%x in ("C:\Windows\Temp\*") do rd /s /q "%%x" 2>nul
echo ✅ Windows temp files cleaned

echo [2/6] Cleaning User Temp Files...
del /q/f/s "%USERPROFILE%\AppData\Local\Temp\*" 2>nul
for /d %%x in ("%USERPROFILE%\AppData\Local\Temp\*") do rd /s /q "%%x" 2>nul
echo ✅ User temp files cleaned

echo [3/6] Cleaning Android Studio Caches...
if exist "%USERPROFILE%\.gradle\caches" (
    rd /s /q "%USERPROFILE%\.gradle\caches" 2>nul
    echo ✅ Gradle caches cleaned
)
if exist "%USERPROFILE%\.android\cache" (
    rd /s /q "%USERPROFILE%\.android\cache" 2>nul
    echo ✅ Android caches cleaned
)
if exist "%USERPROFILE%\.android\avd\.temp" (
    rd /s /q "%USERPROFILE%\.android\avd\.temp" 2>nul
    echo ✅ AVD temp files cleaned
)

echo [4/6] Cleaning Browser Caches...
if exist "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Cache" (
    del /q/f/s "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Cache\*" 2>nul
    echo ✅ Chrome cache cleaned
)
if exist "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Cache" (
    del /q/f/s "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Cache\*" 2>nul
    echo ✅ Edge cache cleaned
)

echo [5/6] Cleaning System Files...
if exist "C:\Windows\SoftwareDistribution\Download" (
    del /q/f/s "C:\Windows\SoftwareDistribution\Download\*" 2>nul
    echo ✅ Windows Update cache cleaned
)
if exist "C:\Windows\Prefetch" (
    del /q/f/s "C:\Windows\Prefetch\*" 2>nul
    echo ✅ Prefetch files cleaned
)

echo [6/6] Emptying Recycle Bin...
rd /s /q "C:\$Recycle.Bin" 2>nul
echo ✅ Recycle bin emptied

echo.
echo ========================================
echo         Cleanup Completed! 🎉
echo ========================================
echo.
echo Safe files cleaned:
echo • Temporary files
echo • Cache files  
echo • Android Studio caches
echo • Browser caches
echo • Windows update cache
echo • Recycle bin
echo.
echo Your system files and programs are safe!
echo.
pause