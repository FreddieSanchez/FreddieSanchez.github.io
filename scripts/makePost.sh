#!/bin/sh

MD_FILE=$1
POST_FILE=$2

TITLE=`head -1 $MD_FILE | cut -d % -f2`
HTML_FILE="`echo $MD_FILE | cut -d . -f1`.html"

echo "* [$TITLE]($HTML_FILE)" >> $POST_FILE

