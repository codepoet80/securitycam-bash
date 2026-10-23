# securitycam-bash

![App Icon](web/icon.png)

Loosely derived from my [kunacam-php](https://github.com/codepoet80/kunacam-php) project, this is a super quick-and-dirty solution for publishing still frames from any RTSP-enabled web cams to a webpage.

It depends on a bash script, driven by a config file that you must edit, scheduled by a cronjob, that you must create, on a schedule you define.

The script also generates a static `index.html`, so any web server that can serve plain files will work -- no PHP required. It assumes you can create a symlink or virtual directory pointing to the `web` subdirectory in this project. **Do not point your web server to the root of this project, doing so will expose your camera RTSP URLs to clients!**

## Server Requirements

Tested with nginx and apache2 (should also work with the built-in web server in Pi-hole v6), with the following installed:

+ ffmpeg 4.4.2 or newer

## Client Requirements

Pretty much any browser in the past 15 years. Tested on Chrome and Firefox. Also tested on webOS and Android browsers.

## Setup

- Clone this code somewhere on your system

- Copy `config-example.sh` to `config.sh`

- Modify the `cams` array in `config.sh` to point to the ffmpeg (for RTSP) or wget command for each of your cameras -- one camera for each line.

- Optionally set `refresh`, `cam_names` and `cam_links` in `config.sh` to your liking (web update rate, camera names, and click-through links)

- Ensure `update-cams.sh` is executable and works when you execute it manually.

- Schedule `update-cams.sh` to run as you see fit via `cron` (or some other mechanism)

- Create a symlink or virtual directory in your web server of choice to point to the `web` subfolder in this project.
  - For Pi-hole v6, which serves files from `/var/www/html`: `sudo ln -s /path/to/securitycam-bash/web /var/www/html/cams`. By default Pi-hole only serves its own admin pages, so you also need to enable serving other files with `sudo pihole-FTL --config webserver.serve_all true`. The web server runs as the `pihole` user, so it needs read access along the whole path -- if the project is in your home folder, you may need `chmod o+x ~`

- View your created path in a web browser
