#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

html_escape() {
        local s=$1
        s=${s//'&'/'&amp;'}
        s=${s//'<'/'&lt;'}
        s=${s//'>'/'&gt;'}
        s=${s//'"'/'&quot;'}
        printf '%s' "$s"
}

write_index() {
        local tmpIndex
        tmpIndex=$(mktemp "$SCRIPT_DIR/web/.index.XXXXXX")
        {
                cat <<EOF
<!DOCTYPE html>
<html>
    <head>
        <title>Security Cameras</title>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
        <link rel="stylesheet" href="style.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
        <link rel="icon" href="favicon.ico" type="image/x-icon">
        <link rel="manifest" href="manifest.json">
        <meta name="theme-color" content="#000000">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <meta name="apple-mobile-web-app-title" content="Cameras">
        <link rel="apple-touch-icon" href="icon-256.png">
        <script>
        var rate = ${refresh:-32000};
EOF
                cat <<'EOF'
        function imgReady(self) {
            console.log(self.id + " is ready!");
            var spinner = document.getElementById("spinner-" + self.id);
            spinner.style.display = "none";
            setTimeout (
                function(self) {
                    console.log("timeout fired for " + self.id);
                    var cam = document.getElementById(self.id);
                    var spinner = document.getElementById("spinner-" + self.id);
                    var d=new Date();
                    cam.src = self.id + ".jpg?time=" + d.getTime();
                    spinner.style.display = "inline";
                }, rate, self
            );
        }
        function camError(self) {
            self.src='offline.png';
            var spanToMove = document.getElementById("span-" + self.id);
            var spans = document.getElementsByTagName("span");
            spanToMove.parentNode.appendChild(spanToMove.parentNode.replaceChild(spans[spans.length-1], spanToMove));
        }
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker.register('sw.js');
        }
        </script>
	<style>
		body { background-color:black; color: white; }
	</style>
    </head>
    <body>
    <table width=100% height=100% border=0 cellpadding=0 cellspacing=0>
    <tr>
    <td width=100% height=100% align="center" valign="middle">
        <h1><img src="icon.png" valign="middle" style="vertical-align:top;margin-top:4px;height:32px"> Security Cameras</h1>
        <div id="container">
EOF
                local c camId camName camLink
                for (( c=0; c<${camLength}; c++ ));
                do
                        camId=cam-$c
                        camName=$(html_escape "${cam_names[$c]:-Cam-$c}")
                        camLink=$(html_escape "${cam_links[$c]}")
                        echo "            <span class=\"item\" id=\"span-$camId\">"
                        echo "                <p class=\"camera-name\">$camName</p>"
                        if [ -n "$camLink" ]; then
                                echo "                <a href=\"$camLink\">"
                        else
                                echo "                <a>"
                        fi
                        echo "                    <img class=\"camera\" id=\"$camId\" onload=\"imgReady(this);\" title=\"$camName\" onerror=\"camError(this)\">"
                        echo "                </a>"
                        echo "                <img class=\"spinner\" id=\"spinner-$camId\" src=\"spinner.gif\">"
                        echo "            </span>"
                done
                cat <<'EOF'
        </div>
    </td>
    </tr>
    </table>
    <script>
    // set image sources here so a cached copy of this page never shows stale frames
    var cams = document.getElementsByClassName("camera");
    for (var i = 0; i < cams.length; i++) {
        cams[i].src = cams[i].id + ".jpg?time=" + new Date().getTime();
    }
    </script>
    </body>
</html>
EOF
        } > "$tmpIndex"
        chmod 644 "$tmpIndex"
        mv -f "$tmpIndex" "$SCRIPT_DIR/web/index.html"
}

if [ ! -f $SCRIPT_DIR/config.sh ]; then
        echo "Config file not found! Unable to proceed..."
        echo "Copy config-example.sh to config.sh, and set the URLs to your cameras within it"
        exit
else
        source $SCRIPT_DIR/config.sh
        camLength=${#cams[@]}
        write_index
        echo "Updating $camLength cams..."
        for (( i=0; i<${camLength}; i++ ));
        do
                tempFile=$(mktemp --suffix=.jpg)
                rm -f "$tempFile"
                trap 'rm -f "$tempFile"' EXIT
                outFile=$SCRIPT_DIR/web/cam-$i.jpg
                echo
                echo "Saving to: $outFile"
                echo
                command=${cams[$i]}
                command=${command/CAMIMG/"$tempFile"}
                $command
                mv -f $tempFile $outFile
                trap - EXIT
        done
fi
