@echo off

call base_config.bat

echo [*] Build cURL x64
cd /d %CURL_DIR%\winbuild
nmake /f Makefile.vc mode=dll WITH_SSL=static DEBUG=no MACHINE=x64 SSL_PATH=%SSL64_DIR% ENABLE_SSPI=no ENABLE_WINSSL=no ENABLE_IDN=no

echo [*] Move cURL x64 files
copy ..\builds\libcurl-vc-x64-release-dll-ssl-static-ipv6\lib\libcurl.lib %DEFAULT_DIR%\curl\x64
copy ..\builds\libcurl-vc-x64-release-dll-ssl-static-ipv6\bin\libcurl.dll %DEFAULT_DIR%\curl\x64
copy ..\builds\libcurl-vc-x64-release-dll-ssl-static-ipv6\include\curl\*.h %DEFAULT_DIR%\curl\x64\include\curl

echo [*] Check moved files
IF EXIST %DEFAULT_DIR%\curl\x64\libcurl.lib echo    -libcurl.lib OK
IF EXIST %DEFAULT_DIR%\curl\x64\libcurl.dll echo    -libcurl.dll OK
IF EXIST %DEFAULT_DIR%\curl\x64\include echo    -Include Files OK

@REM echo [+] Qt

@REM cd %QT_DIR%
CALL "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Auxiliary\Build\vcvarsall.bat" amd64
@REM SET _ROOT=C:\Qt\qt-everywhere-src-5.15.2
@REM SET PATH=%_ROOT%\qtbase\bin;%_ROOT%\gnuwin32\bin;%PATH%
@REM SET _ROOT=
@REM cd %QT_DIR%
@REM .\configure.bat -opensource -confirm-license -nomake tests -nomake examples -no-compile-examples -release -shared -no-ltcg -accessibility -opengl desktop -no-openvg -no-iconv -no-evdev -no-mtdev -no-inotify -no-eventfd -no-system-proxies -qt-zlib -qt-pcre -no-icu -qt-libpng -qt-libjpeg -qt-freetype -no-fontconfig -qt-harfbuzz -no-angle -no-plugin-manifests -qreal double -strip -no-ssl -no-openssl -no-libproxy -no-dbus -no-direct2d -directwrite -no-style-fusion -skip qt3d -skip qtactiveqt -skip qtandroidextras -skip qtcanvas3d -skip qtconnectivity -skip qtdeclarative -skip qtdoc -skip qtgraphicaleffects -skip qtlocation -skip qtmacextras -skip qtmultimedia -skip qtquickcontrols -skip qtquickcontrols2 -skip qtscript -skip qtsensors -skip qtserialbus -skip qtserialport -skip qtwayland -skip qtwebchannel -skip qtwebengine -skip qtwebsockets -skip qtwebview -skip qtx11extras -skip qtxmlpatterns -prefix C:\VBoxBuild\Qt\qt5-x64
@REM nmake
@REM nmake install