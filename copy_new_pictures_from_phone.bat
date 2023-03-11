@echo off
setlocal enabledelayedexpansion

set a_txt="C:\Users\Chananya\Downloads\computer_ls.txt"
set b_txt="C:\Users\Chananya\Downloads\ls.txt"
set c_txt="C:\Users\Chananya\Downloads\files_to_transfer.txt"
set camera="C:\Users\Chananya\Pictures\Camera"
set commands="adb_pull_commands.bat"


rem Get list of all pictures in the phone
adb shell "ls -1 -A -p /storage/emulated/0/DCIM/Camera | grep -v / > /storage/emulated/0/DCIM/ls.txt"
adb pull -p -a /storage/emulated/0/DCIM/ls.txt %b_txt%
echo Got the list of pictures from the phone!

rem Get list of all pictures in the computer
(for /f "delims=" %%a in ('dir %camera% /B /S /A-D') do @echo %%~nxa) > %a_txt%

rem Find the diff
findstr /v /g:%a_txt% %b_txt% > %c_txt%
del %a_txt% %b_txt%

rem Pulling the pictures
echo Pulling the pictures
(for /f "delims=" %%a in ('type "!c_txt!"') do @(
    echo(echo %%a ^& adb pull -p -a "/storage/emulated/0/DCIM/Camera/%%a" "C:\Users\Chananya\Pictures\Camera\Camera 7\%%a" ^& echo ---
)) > %commands%
call %commands%
del %commands%

echo Done!
pause
