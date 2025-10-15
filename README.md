# securitycam-bash

![App Icon](web/icon.png)

Loosely derived from my [kunacam-php](https://github.com/codepoet80/kunacam-php) project, this is a super quick-and-dirty solution for publishing still frames from any RTSP-enabled web cams to a webpage.

It depends on a bash script, driven by a config file that you must edit, scheduled by a cronjob, that you must create, on a schedule you define.

It assumes you have your own web-server and can create a symlink or virtual directory pointing to the `web` subdirectory in this project. **Do not point your web server to the root of this project, doing so will expose your camera RTSP URLs to clients!**

## Server Requirements

Tested with nginx and apache2, with the following installed:

+ ffmpeg 4.4.2
+ php 7+

## Client Requirements

Pretty much any browser in the past 15 years. Tested on Chrome and Firefox. Also tested on webOS and Android browsers.

## Setup

- Clone this code somewhere on your system

- Copy `config-example.sh` to `config.sh`

- Modify the `cams` array in `config.sh` to point to the ffmpeg (for RTSP) or wget command for each of your cameras -- one camera for each line.

- Optionally modify `web\config.php` to your liking (set camera names and web update rate)

- Ensure `update-cams.sh` is executable and works when you execute it manually.

- Schedule `update-cams.sh` to run as you see fit via `cron` (or some other mechanism)

- Create a symlink or virtual directory in your web server of choice to point to the `web` subfolder in this project.

- View your created path in a web browser
