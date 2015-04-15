#!/bin/bash

PATH=$PATH:/usr/local/bin

function run() {
  echo "<h1>$1</h1>"
  CONVERT="convert"
  TMP_OUT=$(mktemp /tmp/fx-stdout.XXXX)
  TMP_ERR=$(mktemp /tmp/fx-stderr.XXXX)
  TMP_IMG=$(mktemp /tmp/fx-image.XXXX)
  "$CONVERT" "$1" -fx @"$2" -format 'png' $TMP_IMG 2>$TMP_ERR >$TMP_OUT
  if [ -s $TMP_IMG ]; then
    data=$(base64 $TMP_IMG)
    echo "<img src=\"data:image/png;base64,$data\" width="100%" />"
  fi
  if [ -s $TMP_OUT ]; then
    echo "<p style=\"padding: 1em; background-color: lightcyan; color: midnightblue;\">" \
         cat $TMP_OUT &&  echo "</p>"
  fi
  if [ -s $TMP_ERR ]; then
    echo "<pre style=\"padding: 1em; background-color: lightyellow; color: red;\">" && \
         cat $TMP_ERR && echo "</pre>"
  fi
  rm -f $TMP_OUT
  rm -f $TMP_ERR
  rm -f $TMP_IMG
}


function generate_image_menu() {
  BASE_DIR=$(dirname "${TM_FILEPATH}")
  BUILT_IN=("granite:", "logo:", "netscape:", "rose:", "wizard:")
  LOCAL_IMAGE=`find -E "${BASE_DIR}" -type f -regex '.*\.(jpe?g|png|tiff?|gif)' -exec basename \{\} ';' | head -n 5`

  OPTIONS=""
  for local_image in $LOCAL_IMAGE
  do
    OPTIONS="${OPTIONS}{title = \"$local_image\";},"
  done

  OPTIONS="${OPTIONS}{separator=1;},{header=1; title=\"Built-In\";}"
  for builtin_image in ${BUILT_IN[@]}
  do
    OPTIONS="${OPTIONS},{title = \"$builtin_image\";}"
  done

  SELECTED_XML=$("$DIALOG" menu --items "(${OPTIONS})")
}
