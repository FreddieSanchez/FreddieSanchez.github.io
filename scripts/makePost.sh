#!/bin/sh

MD_FILE=$1
HTML_FILE=$2 
POST_FILE=$3

TITLE=`head -1 $MD_FILE | cut -d % -f2`

echo "* [$TITLE]($HTML_FILE)" >> $POST_FILE

