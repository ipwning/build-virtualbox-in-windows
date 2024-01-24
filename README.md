# Build VirtualBox in Windows

## Notice  
Based on [this repository](https://github.com/bruce30262/build-virtualbox-in-windows). Currently works for VirtualBox 7.0.14.  
I recommend build the VirtualBox in windows 10 VM. (I built in Windows 10 VM of vmware)
## Setup Environment

* [Visual Studio 2019 Professional](https://learn.microsoft.com/en-us/visualstudio/releases/2019/release-notes)
* Windows SDK 11 & WDK 11
    * https://go.microsoft.com/fwlink/?linkid=2166460
    * https://go.microsoft.com/fwlink/?linkid=2166289
    * See also: https://docs.microsoft.com/en-us/windows-hardware/drivers/download-the-wdk
    * Basically you can use Visual Stuido Installer to install the latest SDK and WDK. **Notice that SDK and WDK's version should be the same.**  
    * Currently I'm using version `10.0.22000.0`.

* [Zip for Windows](https://gnuwin32.sourceforge.net/packages/zip.htm)
    * Needed for `kmk packing`
    * Install into default path

* [WIX3](https://github.com/wixtoolset/wix3/releases)
    * Needed for `kmk packing`
    * Download `wix311-binaries.zip`
    * Extract the file into `C:\VBoxBuild\wix311`

* [OpenSSL](https://slproweb.com/products/Win32OpenSSL.html)
    * [x32](https://slproweb.com/download/Win32OpenSSL-3_0_12.msi)
    * [x64](https://slproweb.com/download/Win64OpenSSL-3_0_12.msi)
    * Needed for `SSL`
    * Download `Win32OpenSSL-3_0_12.msi`, `Win64OpenSSL-3_0_12.msi`
    * Install in the `C:\VBoxBuild\SSL\OpenSSL-Win{architecture bit}`
    * Example: `C:\VBoxBuild\SSL\OpenSSL-Win32`

* [WinDDK 7.1](https://www.microsoft.com/en-hk/download/details.aspx?id=11800)
    * Double click `GRMWDK_EN_7600_1.ISO`
    * Run `KitSetup.exe`
    * check every checkbox and press ok.
* [Yasm](https://yasm.tortall.net/Download.html)
    * Download `Win64.exe`, rename it to `yasm.exe`. Set the PATH env so `yasm.exe` can be found in PATH.
* [nasm](https://www.nasm.us/pub/nasm/releasebuilds/2.16.01/win64/nasm-2.16.01-win64.zip)
    * Extract zip at `C:VBoxBuild\nasm` and set the PATH env so `nasm.exe.` can be found in PATH. 
* [Qt5](https://download.qt.io/official_releases/qt/5.15/5.15.2/single/qt-everywhere-src-5.15.2.zip.mirrorlist)
    * You have to build it for Virtualbox GUI.
    * First of all, extract the zip file in `C:\VBoxBuild\Qt\qt5-everywhere-src-5.15.2` and Build with this build instruction.
    ```powershell
    cd C:\VBoxBuild\Qt\qt5-everywhere-src-5.15.2
    SET _ROOT=C:VBoxBuild\Qt\qt5-everywhere-src-5.15.2
    SET PATH=%_ROOT%\qtbase\bin;%_ROOT%\gnuwin32\bin;%PATH%
    SET _ROOT=
    .\configure.bat -opensource -confirm-license -nomake tests -nomake examples -no-compile-examples -release -shared -no-ltcg -accessibility -opengl desktop -no-openvg -no-iconv -no-evdev -no-mtdev -no-inotify -no-eventfd -no-system-proxies -qt-zlib -qt-pcre -no-icu -qt-libpng -qt-libjpeg -qt-freetype -no-fontconfig -qt-harfbuzz -no-angle -no-plugin-manifests -qreal double -strip -no-ssl -no-openssl -no-libproxy -no-dbus -no-direct2d -directwrite -no-style-fusion -skip qt3d -skip qtactiveqt -skip qtandroidextras -skip qtcanvas3d -skip qtconnectivity -skip qtdeclarative -skip qtdoc -skip qtgraphicaleffects -skip qtlocation -skip qtmacextras -skip qtmultimedia -skip qtquickcontrols -skip qtquickcontrols2 -skip qtscript -skip qtsensors -skip qtserialbus -skip qtserialport -skip qtwayland -skip qtwebchannel -skip qtwebengine -skip qtwebsockets -skip qtwebview -skip qtx11extras -skip qtxmlpatterns -prefix C:\VBoxBuild\Qt\qt5-x64
    nmake
    nmake install
    ``` 

* MinGW
    * In this repo `setup.py` will install and build mingw for you, but you need to add `C:\VBoxBuild\MinGW\mingw64\bin` in the PATH env.

## How to build

After that, the building steps are bascially the same as the [original](#2-set-up-privilege) :  
* Turn on test mode, reboot.  
* Make sure the VirtualBox source code is in `C:/VBoxBuild/VirtualBox/`.  
* Open cmd as admin.
* `py script/setup.py`
* `py script/build.py`  
    - This will do `kmk` and `kmk packing`, then you can run `C:\VBoxBuild\VirtualBox\out\win.amd64\release\bin\Virtualbox.exe`.

### Troubleshooting  
* Make sure to delete all the certificates named `MyTestCertificate` before building ( check the [FAQ](#faq) below ).  
* During the first build, it probably will run into error saying something like `No making rule for VBoxGuestAdditions.iso`. All you need to do is:  
    - `mkdir C:/VBoxBuild/VirtualBox/out/win.amd64/release/bin/additions/`  
    - `touch C:/VBoxBuild/VirtualBox/out/win.amd64/release/bin/additions/VBoxGuestAdditions.iso`  
    - Rerun `setup.py` and `build.py` ( don't forget to delete the certificate first )
* It probably will occurs some dll error. So you have to match the dll with path in the VirtualBox build folder.
    - If occurs the `it was not found libcurl.dll` error. => add `C:\VBoxBuild\curl\x64` & `C:\VBoxBuild\curl\x32` in the %path% 
