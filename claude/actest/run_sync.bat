@echo off
REM 資料同步排程用啟動檔（Windows 工作排程器）
REM 同步目標由 sync_config.json 決定，成功 exit 0，任一資料表失敗 exit 1
chcp 65001 >nul
cd /d "%~dp0"
python sync_db.py %*
exit /b %ERRORLEVEL%
