#!/bin/bash
# set -x

usage() {
  echo "This command splits file up to 99 separate files, no more."
  echo "Usage: $0 -f filename -n rows [ -p prepend ] [ -h header ]" 1>&2
  echo ""
  echo "Options:"
  echo " -f, file to split"
  echo " -n, max number of rows per file"
  echo " -p, prepend for split files. Ex. ... -f file.csv -p ex. => ex.00.csv"
  echo " -h, if present with value 'no' then header row will not be appended to split files"
  exit 0
}

split_into_rows() {
  header_row=$(head -1 $file) # get header row
  split -l $rows -d $file $prepend # split the file
  for i in $(find $prepend* -not -name $file); do mv $i $i.$ext; done # rename files

  # Check if header row needs to be inserted into split files
  if [[ -z $header ]] || [[ $header != 'no' ]]; then
    for j in $(find . -type f -name "${prepend}*.${ext}" -not -name "${prepend}00.${ext}");
      do
        # https://stackoverflow.com/questions/43969732/insert-a-new-line-at-the-beginning-of-a-file
        sed -i '' "1s/^/$header_row\n/" $j; # add header row at the top of the file
    done
  fi
}

while getopts f:n:p:h: flag
do
  case "${flag}" in
    f) file=${OPTARG};;
    n) rows=${OPTARG};;
    p) prepend=${OPTARG};;
    h) header=${OPTARG};;
  esac
done

if [[ -z $file || -z $rows ]]; then
  usage
else
  # Get file information
  filename=$(basename -- "$file")
  ext="${filename##*.}"
  filename="${filename%.*}"
  
  # Set split file name if not provided
  if [[ -z $prepend ]]; then
    prepend="${filename}."
  fi

  # Uncomment for quickly removing generated files before each run
  # find . -name "${filename}.*" -not -name "${file}" -exec rm {} \;

  start_time="$(date -u +%s)"
  split_into_rows
  end_time="$(date -u +%s)"
  elapsed=$(dc -e "$end_time $start_time - p")
  echo "Splitting $file file into $rows rows in $elapsed seconds"
fi
