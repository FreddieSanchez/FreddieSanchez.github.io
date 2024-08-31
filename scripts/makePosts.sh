#!/bin/bash
echo "making posts"
SOURCE_DIR=src/markdown
POST_MARKDOWN_FILE=$SOURCE_DIR/posts.md
TEMP_POST_MARKDOWN_FILE=$SOURCE_DIR/posts.tmp
POST_MARKDOWN_FILES=$(find $SOURCE_DIR/posts -type f)
echo "" > $POST_MARKDOWN_FILE

for file in $POST_MARKDOWN_FILES; do 
  echo "processing $file"
  MD_FILE=$file
  TITLE="$(echo `head -1 $MD_FILE | cut -d % -f2`| xargs)"
  DATE="$(echo `head -3 $MD_FILE | tail -1 | cut -d % -f2` | xargs)"
  HTML_DIR=${MD_FILE/$SOURCE_DIR/""}
  HTML_FILE=${HTML_DIR/md/html}
  echo "* [$TITLE]($HTML_FILE) - _${DATE}_" >> $POST_MARKDOWN_FILE
done;

# Take the last field put it to the first field, sort it, then remove it, and it to the file.
awk '{print $NF,$0}' $POST_MARKDOWN_FILE  | sort -r | cut -d ' ' -f2-  > $TEMP_POST_MARKDOWN_FILE

HEADER_LINE1="% Posts"
HEADER_LINE2="% Freddie Sanchez"
HEADER_LINE3="% $(date +'%Y-%b-%d')"

echo -e "$HEADER_LINE1\n$HEADER_LINE2\n$HEADER_LINE3\n$(cat $TEMP_POST_MARKDOWN_FILE)" > $TEMP_POST_MARKDOWN_FILE

# copy the temp file to the final file.
mv $TEMP_POST_MARKDOWN_FILE $POST_MARKDOWN_FILE
