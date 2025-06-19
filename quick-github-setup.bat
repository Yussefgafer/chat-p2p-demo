@echo off
echo ========================================
echo    Chat P2P - GitHub Setup Script
echo ========================================
echo.

echo [1/4] Initializing Git repository...
git init
if %errorlevel% neq 0 (
    echo Error: Git initialization failed
    pause
    exit /b 1
)

echo [2/4] Adding all files...
git add .
if %errorlevel% neq 0 (
    echo Error: Failed to add files
    pause
    exit /b 1
)

echo [3/4] Creating initial commit...
git commit -m "Initial commit: Chat P2P Demo App with GitHub Actions"
if %errorlevel% neq 0 (
    echo Error: Failed to create commit
    pause
    exit /b 1
)

echo [4/4] Setting main branch...
git branch -M main
if %errorlevel% neq 0 (
    echo Error: Failed to set main branch
    pause
    exit /b 1
)

echo.
echo ========================================
echo           Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Create a new repository on GitHub
echo 2. Copy the repository URL
echo 3. Run: git remote add origin [YOUR_REPO_URL]
echo 4. Run: git push -u origin main
echo 5. Go to GitHub Actions tab and run the workflow
echo.
echo Repository name suggestion: chat-p2p-demo
echo.
pause
