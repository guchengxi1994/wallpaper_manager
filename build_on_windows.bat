@echo off

set input1=%1%

if "%input1%"=="build" (
    conda activate player
    cd player

    :: pyinstaller -w   player.py -y
    pyinstaller -w   player.py -y

    if exist "dist/player/player.exe" (
        echo "file exists"
        xcopy dist\player\ ..\build\windows\runner\Debug\player\ /E /Y /F
    ) else (
        echo "unknow file"
    )

    cd ..
) else (
    echo "unknow command"
)

