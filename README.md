Introduction
============

This batch script is cable of converting any oracle JDK installation executable into a portable JDK folder by extracting the necessary files and placing them into the correct places. This is useful for those who want to maintain a cleaner environment without having to create registry entries and shortcuts by running the JDK Setup, yet still want to achieve the same functionality of a full JDK installation but in a portable manner.

Usage
=====

1. Copy the Portable-JDK.cmd file anywhere into the machine and run (make sure to run as Administrator if you're on Windows 8 or above).
2. Read the usage description and press "Y" to continue.
3. Drag & Drop the previously downloaded JDK Installer into the console or type the fully qualified path to it.
<p><i>i.e. <b>D:\Downloads\jdk-8u20-windows-x64.exe</b></i></p>
4. Next enter the location to unpack the JDK files.
<p><i>If you specify <b>D:\Dev\Java</b>, it will be extracted to <b>D:\Dev\Java\JDK\8u20_x64</b>. The generated sub folder name depends on the downloaded JDK installer's file name.</i></p>
5. After pressing return, the script will start the extraction process and once completed, will prompt for confirmation on whether to update the <b>JAVA_HOME</b> environment variable path to the newly extracted folder.
6. Proceed with "Y" or "N".

Remarks
=======
* Updating of the <b>JAVA_HOME</b> environment variable will only work if the batch script is run as an administrator. In Windows 7, scripts are run as Administrators by default, so this is not a concern most of the time. But Windows 8 and above will need explicit user consent.


To Do
=====
* Check for user access level and dynamically display a warning if the script is not run as an Administrator.