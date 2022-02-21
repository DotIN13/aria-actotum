#!/bin/bash

archive_dir="../../archive"

cd ./sorted
for dir in *
do
  for vid in $dir/*
  do
    echo "+ Moving $vid"
    target_dir="$archive_dir/$dir"
    # Create video directory if non-exist
    [ ! -d "$target_dir" ] && mkdir -p $target_dir
    echo "- To ${target_dir#../}"
    mv "$vid" "$target_dir"
    echo "- Done"
  done
done