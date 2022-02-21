#!/bin/bash

# shopt -s extglob # Enable extension glob pattern
shopt -s nullglob # Do not iterate if there is no directories

# Make working directory
[ ! -d ./sorted ] && mkdir -p ./sorted

for dir in ./*/; do
  trimmed_dir=$(basename $dir) # Remove the trailing slash with basename
  # Find directories with no accompanying aria2 file, and matching movie naming conventions
  if [ ! -f "$trimmed_dir.aria2" ] && [[ $trimmed_dir =~ ^(([a-zA-Z]+\.)+[0-9]{4}).*$ ]]; then
    valid_download="${BASH_REMATCH[1]}" # Strip video name with year suffix
    echo "+ Found finished download directory \"./$trimmed_dir\", with valid video \"$valid_download\""
    # Move video files
    for vid in $trimmed_dir/*; do
      vid_file=$(basename $vid)
      if [[ $vid_file =~ ^(([a-zA-Z]+\.)+[0-9]{4})((\.([a-zA-Z0-9]+|DTS\-HD|WEB\-DL))*)(-[a-zA-Z0-9]*)?\.(mkv|mp4)$ ]]; then
        echo "- Processing $vid_file..."
        vid_name="${BASH_REMATCH[1]}"
        vid_detail="${BASH_REMATCH[3]#.}"
        vid_ext="${BASH_REMATCH[7]}"
        # Create video directory
        vid_dir="./sorted/$vid_name"
        [ ! -d $vid_dir ] && mkdir "$vid_dir"
        if [[ $vid_detail == "" ]]; then new_vid="$vid_name.$vid_ext"; else new_vid="$vid_name - $vid_detail.$vid_ext"; fi
        # Move video
        mv "$vid" "$vid_dir/$new_vid"
        echo "- Moved \"$vid\" to \"$vid_dir/$new_vid\""
      fi
    done
    echo "- Done with \"./$trimmed_dir\""
  fi
done
