#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [ ! -f $SCRIPT_DIR/config.sh ]; then
        echo "Config file not found! Unable to proceed..."
        echo "Copy config-example.sh to config.sh, and set the URLs to your cameras within it"
        exit
else
        source $SCRIPT_DIR/config.sh
        camLength=${#cams[@]}
        echo "Updating $camLength cams..."
        for (( i=0; i<${camLength}; i++ ));
        do
                tempFile=$(mktemp --suffix=.jpg)
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
