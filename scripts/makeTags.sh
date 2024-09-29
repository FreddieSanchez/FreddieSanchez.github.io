#!/bin/bash


SOURCE_DIR=src/markdown
MARKDOWN_FILE=$SOURCE_DIR/tags.md
TEMP_MARKDOWN_FILE=$SOURCE_DIR/tags.tmp
POSTS_DIR=$SOURCE_DIR/posts
TAGS_DIR=$SOURCE_DIR/tags
TAGS=$(grep -r -h -E "(#[a-z]+)" $POSTS_DIR | xargs -n1 | sort -u | xargs)
echo "" > $MARKDOWN_FILE
echo "" > $TEMP_MARKDOWN_FILE

make_tag_file() {
	local tag=$1
	local files=$2 
	local tag_file=$3
	local tag_file_name=$4
	local count=$5
	local HEADER_LINE1="% $tag"
        local HEADER_LINE2="% Freddie Sanchez"
	echo -e "$HEADER_LINE1\n$HEADER_LINE2" > "$tag_file"
	echo "# $tag_file_name ($count)" >> "$tag_file"
	for file in $files; do
		TITLE="$(head -1 "$file"| cut -d % -f2| xargs)"
		DATE="$(head -3 "$file"| tail -1 | cut -d % -f2 | xargs)"
		HTML_DIR=${file/$SOURCE_DIR/""}
		HTML_FILE=${HTML_DIR/md/html}

		echo "* [$TITLE]($HTML_FILE) - _${DATE}_" >> "$tag_file"
	done 

}

process_tags() {
	local tags=$1
	for tag in $tags; do
	  local tag_files=$(grep -r "$tag" $POSTS_DIR | cut -d ":" -f1)
	  local count=$(grep -c --max-count 1 -r "$tag" $POSTS_DIR | grep -vE ":0$" | cut -d ":" -f2 | awk '{sum += $1} END {print sum}' )
	  local tag_file_name=$(echo "$tag" | cut -d "#" -f2)
	  local src_tag_file="$TAGS_DIR/$tag_file_name.md"
	  local html_dir=${src_tag_file/$SOURCE_DIR/""}
	  local html_file=${html_dir/md/html}
	  echo "* [$tag]($html_file) ($count)" >> $TEMP_MARKDOWN_FILE
	  make_tag_file "$tag" "$tag_files" "$src_tag_file" "$tag_file_name" "$count"
	done;
}

# Take the last field put it to the first field, sort it, then remove it, and it to the file.
#awk '{print $NF,$0}' $MARKDOWN_FILE  | sort -r | cut -d ' ' -f2-  > $TEMP_MARKDOWN_FILE

process_tags "$TAGS"

HEADER_LINE1="% Tags"
HEADER_LINE2="% Freddie Sanchez"
HEADER_LINE3="% $(date +'%Y-%b-%d')"

echo -e "$HEADER_LINE1\n$HEADER_LINE2\n$HEADER_LINE3\n$(cat $TEMP_MARKDOWN_FILE)" > $TEMP_MARKDOWN_FILE

# copy the temp file to the final file.
mv $TEMP_MARKDOWN_FILE $MARKDOWN_FILE
