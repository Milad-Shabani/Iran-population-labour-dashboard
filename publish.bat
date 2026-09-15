@echo off
REM ============================================================
REM  Publish this folder as a public repo on github.com/Milad-Shabani
REM  and turn on GitHub Pages so the dashboards are live on the web.
REM
REM  Requires: git, and GitHub CLI (gh) installed and logged in.
REM            Run  gh auth login  once before using this script.
REM
REM  If a repo with this name already exists and you want to keep its
REM  history, rename it instead of creating a second one:
REM      gh repo rename %REPO_NAME% --repo Milad-Shabani/OLD-NAME
REM  then just run a normal  git push .
REM ============================================================

set REPO_NAME=iran-population-labour-dashboard
set REPO_DESC=Interactive data story on Iran's population and labour market, 1395-1405. Unemployment halved while the employment-to-population ratio stayed flat. Self-contained HTML, 18 hand-built SVG charts, zero dependencies, bilingual (EN/FA).

REM --- run from the folder this .bat lives in
cd /d "%~dp0"

REM --- git identity (safe to run every time)
git config --global user.name "Milad Shabani"
git config --global user.email "MILAD.SHABANI6515@GMAIL.COM"

REM --- init only if not already a repo
if not exist ".git" (
    git init
    git branch -M main
)

REM --- drop any leftover remote from a previous attempt
git remote remove origin 2>nul

git add .
git commit -m "Iran population and labour market dashboard, 1395-1405"
git branch -M main

gh repo create %REPO_NAME% --public --source=. --remote=origin --push --description "%REPO_DESC%"
if errorlevel 1 (
    echo.
    echo [ERROR] gh repo create failed - see the message above.
    echo Common causes: a repo named %REPO_NAME% already exists on your account,
    echo or you are not logged in ^(run: gh auth login^).
    pause
    exit /b 1
)

gh repo edit Milad-Shabani/%REPO_NAME% ^
  --homepage "https://milad-shabani.github.io/%REPO_NAME%/" ^
  --add-topic data-visualization --add-topic dashboard --add-topic iran ^
  --add-topic demographics --add-topic labour-market --add-topic labor-statistics ^
  --add-topic data-journalism --add-topic svg --add-topic rtl ^
  --add-topic open-data --add-topic no-dependencies --add-topic persian

REM --- serve the repo root as a website
gh api -X POST repos/Milad-Shabani/%REPO_NAME%/pages ^
  -f "source[branch]=main" -f "source[path]=/" >nul 2>&1
if errorlevel 1 (
    echo [NOTE] Could not enable GitHub Pages automatically.
    echo        Turn it on manually: Settings ^> Pages ^> Source: main / root
) else (
    echo GitHub Pages enabled.
)

echo.
echo Done.
echo   Repo:      https://github.com/Milad-Shabani/%REPO_NAME%
echo   Live site: https://milad-shabani.github.io/%REPO_NAME%/
echo   ^(Pages can take a minute or two to build the first time.^)
pause
