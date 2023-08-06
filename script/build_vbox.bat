@echo off

call base_config.bat

cd /d %VBOX_DIR%

echo [+] Configure VirtualBox build setting
set BUILD_TARGET_ARCH=amd64
cscript configure.vbs --with-vc="%VS2019VC_DIR%" --with-qt5="%DEFAULT_DIR%\Qt\5.15.2\msvc2019_64" --with-ddk="%WINDDK_DIR%" --with-libsdl="%SDL_DIR%" --with-libcurl="%DEFAULT_DIR%\curl\x64" --with-libcurl32="%DEFAULT_DIR%\curl\x32" --with-python="%PYTHON_DIR%"