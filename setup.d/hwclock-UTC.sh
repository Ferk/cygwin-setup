#!/bin/sh
#
# Sets the system to use the hardware clock as UTC time, and only set the local timezone
# in the OS level (like it's done in most UNIX systems).
# This way we avoid constantly changing the time when dual booting.

regtool -wd set /HKLM/SYSTEM/CurrentControlSet/Control/TimeZoneInformation/RealTimeIsUniversal "1"
