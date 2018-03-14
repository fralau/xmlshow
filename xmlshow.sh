#!/usr/bin/env bash
# Make a proper output for XML files
#
# Copyright (c) 2018 Laurent Franceschetti, MIT License
#


filename=$1
remove=false


# Unzip the file if necessary
mimetype=$(file --mime-type "$filename" -b)

if [[ $mimetype = 'application/zip' ]]
then
    echo "Unzipping..."
    filename=$(mktemp).xml
    unzip -p "$1" > "$filename"
    remove=true
fi

# Beautify, highlight with colors and send to less
xmllint --format "$filename" | highlight --syntax=xml --out-format=truecolor | less -R -N

# remove the filename
if $remove
then
    echo "Removing temporary file ($filename)"
    rm "$filename"
fi
