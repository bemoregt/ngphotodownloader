#!/bin/sh
# This Script downloads National Geographic Photo of the day, and sets it as desktop background (gnome, unity)
# Copyright (C) 2012 Saman Barghi - All Rights Reserved
# Permission to copy, modify, and distribute is granted under GPLv3
# Last Revised 29 Augst 2012


#check for network
while [ -z "`curl -s --head http://google.com/ | head -n 1 | grep 'HTTP/1.[01]'`" ]
do
	echo "Network is down!!"
	sleep 1800
done
#######################

#Change directory to where the script resides.
BASEDIR=$(dirname $0)
cd $BASEDIR
#######################

#getting the image URL
#img=`curl http://photography.nationalgeographic.com/photography/photo-of-the-day/ | grep download_link | awk -F\" '{print $4}'`
#img="http:$(curl http://photography.nationalgeographic.com/photography/photo-of-the-day/ | awk 'found && /<\/div>/ {exit}; found ;/class="primary_photo"/ {found=1}' | grep -oP '(?<=img src=")[^"]*(?=")')"
img="$(curl http://www.nationalgeographic.com/photography/photo-of-the-day/ -s | grep -oP '(?<='\''aemLeadImage'\'': '\'')[^'\'']*')"

#check to see if there is any wallpaper to download
if [ -n "$img" ]
then
    img_base=`basename $img`
    img_md5=`echo -n $img_base | md5sum | cut -f1 -d" "`
	img_file="$img_md5.jpg"

	if [ -f "$img_file" ]
	then
		echo "File already exists"
	else
        curl "$img" > $img_file
		#set the current image as wallpaper
		#gsettings set org.gnome.desktop.background picture-uri file:///`pwd`/$img_file
		echo "Wallpaper downloaded successfully and saved as $img_file"
	fi
else
	echo "No Wallpaper today"
fi
