chromium-update
=========

A Windows PowerShell script that automatically finds the latest official Windows build of the Chromium browser, and if it is newer than the current version, downloads and installs it.

Since Windows has no native package manager and the Chromium builds don't have a built-in updater, I decided to make it easier for me to keep up-to-date versions of the browser installed.

Please read the comments in the script, especially for the first command, which sets the directory that the script will operate in. The script relies on a persistent file that stores the last installed build version, so it's important to have the directory be in a permanent location.
