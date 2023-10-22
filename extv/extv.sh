#!/usr/bin/bash
default_ext="mp3"
rename_file_extension() {
    local file="$1"
    local new_ext="$2"
    
    local file_name="${file%.*}"  # Extract file name without extension
    local extension="${file##*.}"  # Extract current extension
    
    local new_file="${file_name}.${new_ext}"  # Construct new file name with new extension
    
    echo "$new_file"
}

if [[ $# -lt 2 ]]; then
    new_ext="$default_ext"
else
    new_ext="$2"
fi
new_file=$(rename_file_extension $1 $new_ext)
ffmpeg -i $1 -vn -ac 2 -ar 44100 -ab 320k -f $new_ext $new_file
