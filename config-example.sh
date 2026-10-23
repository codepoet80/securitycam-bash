#!/bin/bash
# each line represents the command to fetch an image from a camera
# the string CAMIMG will be replaced with a new filename generated sequentially
declare -a cams=(
	"ffmpeg -y -rtsp_transport tcp -i rtsp://camuser:campassword@192.168.1.XXX:88/videoMain -frames:v 1 -update 1 CAMIMG"	#FoscamHD
 	"wget -O CAMIMG --user camuser --password campassword http://192.168.1.XXX:88/snapshot.cgi"	#FoscamSD
)

# how often (in milliseconds) the web page reloads each camera image
refresh=32000

# cameras get default names based on their filename (Cam-0, Cam-1...)
# 	you can optionally override this by listing names in the same order as the cams above
declare -a cam_names=(
	"LivingRoom Cam"
	"Garage Cam"
)

# some cameras have web pages or media streaming URLs
# 	if you include them here, clicking on the cam image will go to that URL
# 	note these are visible to anyone who can load the page, so think twice about embedding passwords
declare -a cam_links=(
	"http://192.168.1.XXX:88/"
	""
)
