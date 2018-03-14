#!/usr/bin/env bash
# Make a proper output for XML files
#
# Copyright (c) 2018 Laurent Franceschetti, MIT License
#
# usage:
#    xmlshow myfile.xml
#    xmlshow myfile.zip
#    program-outputting-xml | xmlshow

# in case you need to change the format, see -out-format in highlight:
OUT_FORMAT=xterm256


if [ $# = 0 ]
then
    # no arguments: use stdin
    filename=/dev/stdin
else
    # file to read
    filename=$1
fi

remove=false


# Unzip the file if necessary
mimetype=$(file --mime-type "$filename" -b)

if [[ $mimetype = 'application/zip' ]]
then
    echo "Unzipping..."
    filename=$(mktemp).xml
    unzip -p "$1" > "$filename"
    remove=true
elif [[ $mimetype = 'application/x-gzip' ]]
then
    echo "Gunzipping..."
    filename=$(mktemp).xml
    gunzip -c "$1" > "$filename"
    remove=true
fi

# Beautify, highlight with colors and send to less
xmllint --format "$filename" | highlight --syntax=xml --out-format=$OUT_FORMAT | less -R -N

# remove the filename
if $remove
then
    echo "Removing temporary file ($filename)"
    rm "$filename"
fi
