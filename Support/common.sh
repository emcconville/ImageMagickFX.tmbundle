#!/bin/bash

PATH=$PATH:/usr/local/bin

function run() {
  CONVERT="convert"
  TMP_OUT=$(mktemp /tmp/fx-stdout.XXXX)
  TMP_ERR=$(mktemp /tmp/fx-stderr.XXXX)
  TMP_IMG=$(mktemp /tmp/fx-image.XXXX)
  "$CONVERT" "$1" -fx @"$2" -format 'png' $TMP_IMG 2>$TMP_ERR >$TMP_OUT
  if [ -s $TMP_IMG ]; then
    data=$(base64 $TMP_IMG)
    echo "<img src=\"data:image/png;base64,$data\" />"
  fi
  if [ -s $TMP_OUT ]; then
    stdout=$(<$TMP_OUT)
    echo "<p style=\"padding: 1em; background-color: lightcyan; color: midnightblue;\">$stdout</p>"
  fi
  if [ -s $TMP_ERR ]; then
    stderr=$(<$TMP_ERR)
    "<p style=\"padding: 1em; background-color: orange; color: red;\"><strong>$stderr</strong></p>"
  fi
  rm -f $TMP_OUT
  rm -f $TMP_ERR
  rm -f $TMP_IMG
}
