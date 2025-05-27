@echo off
setlocal enabledelayedexpansion

:: Check if running on Windows or WSL/Git Bash
where bash >nul 2>nul
if %ERRORLEVEL% equ 0 (
    :: Running on WSL/Git Bash
    bash ./sync_repo.sh
) else (
    :: Running on Windows without bash
    echo This script requires Git Bash or WSL to run.
    echo Please install Git for Windows (which includes Git Bash) from:
    echo https://git-scm.com/download/win
    pause
    exit /b 1
) 