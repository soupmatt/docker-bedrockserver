#!/bin/bash

function copy_config() {
   filename=$1

   # if the file exists in the config folder then copy the config
   if [ -f config/$filename ]; then
      cp config/$filename $filename

   # if there is a default config then copy that to both locations
   elif [ -f $filename.defaults ]; then
      cp $filename.defaults $filename
      cp $filename.defaults config/$filename
   fi
}

copy_config server.properties
copy_config ops.json
copy_config whitelist.json
copy_config permissions.json

echo "Executing server"
exec ./bedrock_server
