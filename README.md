Portable-JDK
============

The main batch script is cable of converting any oracle JDK installation executable into a portable JDK folder by extracting the necessary files and renaming them into the proper names. This is useful for those who want to maintain a cleaner environment without having to create registry entries and shortcuts, yet still achieve the same functionality of a full JDK installation.

The batch script uses 7-Zip to extract the JDK installation files. It will try to locate an installation of 7-Zip on the host it is running on, and if not found, will download the necessary dependencies on-the-fly.
