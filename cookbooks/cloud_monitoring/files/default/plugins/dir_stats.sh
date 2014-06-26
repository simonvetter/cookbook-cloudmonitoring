#!/bin/bash
set -e
TARGET="${1}"

if [ "z" = "z${TARGET}" ]
then
  echo "status ko missing target argument"
  exit 1
fi

SIZE="$(du -sm ${TARGET} | awk '{print $1}')"
NB_FILES="$(find ${TARGET} -type f | wc -l)"
OLDEST_FILE_STAT="$(find ${TARGET} -type f -printf "%T@ %p\n" | sort -n | head -n1)"
OLDEST_FILE_NAME="$(echo ${OLDEST_FILE_STAT} | cut -d ' ' -f2)"
OLDEST_FILE_MTIME="$(echo ${OLDEST_FILE_STAT} | cut -d ' ' -f1 | cut -d '.' -f1)"
OLDEST_FILE_AGE=$((`date +%s`-${OLDEST_FILE_MTIME}))

echo "status ok target uses ${SIZE} MB in ${NB_FILES} files"
echo "metric total_size uint64 ${SIZE} megabytes"
echo "metric total_files uint64 ${NB_FILES} files"
echo "metric oldest_file_age uint64 ${OLDEST_FILE_AGE} seconds"
echo "metric oldest_file_name string ${OLDEST_FILE_NAME}"
