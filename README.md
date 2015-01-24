# cygwin-setup

This is just a quick script with a set of instructions to set up my Windows installations.
There are also some registry files and configuration files.

To run the script (beware! it will install a basic selection of programs) you can use the following oneliner from a cmd prompt:

    @powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/Ferk/cygwin-setup/master/cygwin-setup.ps1'))"

Or from a powershell terminal:

    iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/Ferk/cygwin-setup/master/cygwin-setup.ps1'))
