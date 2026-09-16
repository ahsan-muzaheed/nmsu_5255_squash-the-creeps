@echo off
REM Starts a local web server for the exported game and opens it in the browser.
REM Export first in Godot: Project > Export > Web > Export Project (package\index.html).
REM Close the "Game Server" window to stop the server.

set "PORT=8000"
set "GAME_DIR=%~dp0package"
REM set "GAME_DIR=%~dp0."

if not exist "%GAME_DIR%\index.html" (
    echo.
    echo   No exported game found at: %GAME_DIR%\index.html
    echo   In Godot: Project ^> Export ^> Web ^> Export Project, save as package\index.html
    echo.
    pause
    exit /b 1
)

where python >nul 2>nul
if %errorlevel%==0 (
    start "Game Server" /D "%GAME_DIR%" python -m http.server %PORT%
) else (
    where node >nul 2>nul
    if errorlevel 1 (
        echo   Neither Python nor Node.js was found. Install one of them and try again.
        pause
        exit /b 1
    )
    start "Game Server" /D "%GAME_DIR%" node -e "const h=require('http'),f=require('fs'),p=require('path');const t={'.html':'text/html','.js':'text/javascript','.wasm':'application/wasm','.pck':'application/octet-stream','.png':'image/png'};h.createServer((q,r)=>{let u=decodeURIComponent(q.url.split('?')[0]);if(u==='/')u='/index.html';const fp=p.join(process.cwd(),u);f.readFile(fp,(e,d)=>{if(e){r.writeHead(404);r.end();return}r.writeHead(200,{'Content-Type':t[p.extname(fp)]||'application/octet-stream'});r.end(d)})}).listen(%PORT%,()=>console.log('Serving on http://localhost:%PORT%  - close this window to stop'))"
)

REM Give the server a moment to start, then open the game.
REM "%SystemRoot%\System32\timeout.exe" /t 2 /nobreak >nul
REM start "" "http://localhost:%PORT%/index.html"
