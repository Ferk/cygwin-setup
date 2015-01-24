#!/bin/sh

if hash apt-cyg
then
	echo "Already isntalled"
else
	svn --force export http://apt-cyg.googlecode.com/svn/trunk/ /bin/
	chmod +x /bin/apt-cyg
fi
