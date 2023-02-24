#!/bin/bash

# Take command-line argument or $HOME if none given
parent_dir="${1:-$HOME}"

# URLs and destination directories
urls=(
  "https://web-docs.gsi.de/~wolle/TELEKOLLEG/KERN/LECTURE/Fraser/L"
  "https://inside.mines.edu/~kleach/PHGN422/lectures/Lecture"
)
destination_dirs=(
  "$parent_dir/NUCS 342"
  "$parent_dir/PHGN 422"
)

for i in "${!urls[@]}"; do
  url_prefix="${urls[$i]}"
  dest_dir="${destination_dirs[$i]}"

  # Create the destination directory if it doesn't exist
  if [ ! -d "$dest_dir" ]; then
    mkdir "$dest_dir"
  fi

  page_num=1
  while true; do
    url="${url_prefix}${page_num}.pdf"
    response=$(curl -s -w '%{http_code}' -o "$dest_dir/Lecture${page_num}.pdf" "$url")

    if [ "$response" = "404" ]; then
      rm "$dest_dir/Lecture${page_num}.pdf"
      echo "Reached the end of lecture notes for ${dest_dir}"
      break
    else
      echo "Downloaded page ${page_num} for ${dest_dir}"
      ((page_num++))
    fi
  done
done
