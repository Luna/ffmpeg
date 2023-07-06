@echo off
setlocal enabledelayedexpansion

REM Set the input and output file names
set INPUT_FILE=%~1
set OUTPUT_FILE=%~dpn1-shorts.mp4

REM Get the input file's dimensions
for /f "delims=: tokens=2" %%a in ('ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=s=x:p=0 "%INPUT_FILE%"') do set WIDTH=%%a
for /f "delims=: tokens=2" %%a in ('ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=s=x:p=0 "%INPUT_FILE%"') do set HEIGHT=%%a

REM Check if the video needs to be rotated (landscape to portrait)
if !WIDTH! gtr !HEIGHT! (
  set ROTATE=-vf "transpose=1"
) else (
  set ROTATE=
)

REM Resize the video to Shorts size (1080x1920)
ffmpeg -i "%INPUT_FILE%" %ROTATE% -vf "scale=-2:1920,crop=1080:1920" -c:a copy "%OUTPUT_FILE%"

echo Converted "%INPUT_FILE%" to "%OUTPUT_FILE%"

pause