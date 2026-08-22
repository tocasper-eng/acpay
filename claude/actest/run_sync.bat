@echo off
REM actest 同步排程用啟動檔（Windows 工作排程器）
REM 成功 exit 0，任一資料表失敗 exit 1
chcp 65001 >nul
cd /d "%~dp0"
python sync_actest.py %*
exit /b %ERRORLEVEL%
