# Build VirtualBox in Windows

## Notice  
Based on [this repository](https://github.com/st424204/build-virtualbox-in-windows). Currently works for VirtualBox 7.0.8.  

## Setup Environment

* [Visual Studio 2019 Professional](https://learn.microsoft.com/en-us/visualstudio/releases/2019/release-notes)
* Windows SDK 11 & WDK 11
    * https://go.microsoft.com/fwlink/?linkid=2166460
    * https://go.microsoft.com/fwlink/?linkid=2166289
    * See also: https://docs.microsoft.com/en-us/windows-hardware/drivers/download-the-wdk
    * Basically you can use Visual Stuido Installer to install the latest SDK and WDK. **Notice that SDK and WDK's version should be the same.**  
    * Currently I'm using version `10.0.22621.0`.
    
* [WinSDK 7.1](https://www.microsoft.com/en-us/download/details.aspx?id=8279)
    * Needed for `kmk packing`
    * Install into default path
    * If install failed, check out [this reference](https://notepad.patheticcockroach.com/1666/installing-visual-c-2010-and-windows-sdk-for-windows-7-offline-installer-and-installation-troubleshooting/)

* [Zip for Windows](https://gnuwin32.sourceforge.net/packages/zip.htm)
    * Needed for `kmk packing`
    * Install into default path

* [WIX3](https://github.com/wixtoolset/wix3/releases)
    * Needed for `kmk packing`
    * Download `wix311-binaries.zip`
    * Extract the file into `C:\VBoxBuild\wix311`

* [OpenSSL](https://slproweb.com/products/Win32OpenSSL.html)
    * [x32](https://slproweb.com/download/Win32OpenSSL-3_0_8.msi)
    * [x64](https://slproweb.com/download/Win64OpenSSL-3_0_8.msi)
    * Needed for `SSL`
    * Download `Win32OpenSSL-3_0_8.msi`, `Win64OpenSSL-3_0_8.msi`
    * Install in the `C:\VBoxBuild\SSL\OpenSSL-Win{architecture bit}`
    * Example: `C:\VBoxBuild\SSL\OpenSSL-Win32`

* [WinDDK 7.1](https://www.microsoft.com/en-us/download/details.aspx?displaylang=en&id=11800)
* [Yasm](https://yasm.tortall.net/Download.html)
    * Download `Win64.exe`, rename it to `yasm.exe`. Set the PATH env so `yasm.exe` can be found in PATH.
* Qt
    * [Online installer](https://d13lb3tujbc8s0.cloudfront.net/onlineinstallers/qt-unified-windows-x64-4.5.1-online.exe)
    * Use the installer to install Qt. You need to register an account first
    * Install the prebuild version ( `v5.15.2`, `MSVC 2019 64 bit` )
    * When it ask you the install path, set it to `C:\VBoxBuild\Qt`

* MinGW
    * In this repo `setup.py` will install and build mingw for you, but you need to add `C:\VBoxBuild\MinGW\mingw64\bin` in the PATH env.

## How to build

Before building, you'll have to patch the source code in `src\VBox\Runtime\common\ldr\ldrPE.cpp:4812`:  

```C
// Goto line 4812
// Make sure you patch it into the following lines:
    if (   fNewerStructureHack
            && Dir.Size > cbMaxKnown
            && !(fFlags & (RTLDR_O_FOR_DEBUG | RTLDR_O_FOR_VALIDATION)) && 0)
            //&& !ASMMemIsZero(&u.abZeros[cbMaxKnown], Dir.Size - cbMaxKnown))
        {

```
Patch the source code so later it won't ran into error saying `Fail to load VMMR0.r0....`

After that, the building steps are bascially the same as the [original](#2-set-up-privilege) :  
* Turn on test mode, reboot.  
* Make sure the VirtualBox source code is in `C:/VBoxBuild/VirtualBox/`.  
* Open cmd as admin.
* `py script/setup.py`
* `py script/build.py`  
    - This will do `kmk` and `kmk packing`, which will create an installer ( `.msi` file ) in `C:\VBoxBuild\VirtualBox\out\win.amd64\release\obj\Installer\win`.

### Troubleshooting  
* Make sure to delete all the certificates named `MyTestCertificate` before building ( check the [FAQ](#faq) below ).  
* During the first build, it probably will run into error saying something like `No making rule for VBoxGuestAdditions.iso`. All you need to do is:  
    - `mkdir C:/VBoxBuild/VirtualBox/out/win.amd64/release/bin/additions/`  
    - `touch C:/VBoxBuild/VirtualBox/out/win.amd64/release/bin/additions/VBoxGuestAdditions.iso`  
    - Rerun `setup.py` and `build.py` ( don't forget to delete the certificate first )


## Install and run VirtualBox
* **Install the official VirtualBox first.** This will installed the required library and solve some weird issues.
* After making sure the official VirtualBox can run normally, install the self-build version of VirtualBox ( use the `msi` installer ). The installer will replace the one in `C:\Program Files\Oracle\VirtualBox`.
* Copy `libcurl.dll` in `C:\VBoxBuild\curl\x64`, place it under `C:\Program Files\Oracle\VirtualBox` so our VirtualBox can launch.
* Now open VirtualBox. If you're lucky enough you should see it launched successfully.