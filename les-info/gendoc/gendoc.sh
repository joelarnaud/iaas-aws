#!/bin/bash

terraform-docs --help > /dev/null
if [ 0 -ne $? ]
then
  echo "You need terraform-docs in your PATH"
  exit 1
fi

if [ "" == "$1" ]
then
  echo "Need main.tf location of module"
  exit 1
fi
MAIN_LOCATION=$1

GENDOC_SCRIPT_LOCATION=$(dirname "$0")

tmpfile=$(mktemp /tmp/terraform-docs-temp-markdown.XXXXXX)
echo "Using temporary file $tmpfile" >&2

echo "" >> "$tmpfile"
if [ -f "$GENDOC_SCRIPT_LOCATION/HEADER.md" ]
then
  cat "$GENDOC_SCRIPT_LOCATION/HEADER.md" >> "$tmpfile" 
fi

terraform-docs markdown table --show=requirements "$MAIN_LOCATION" >> "$tmpfile"
terraform-docs markdown table --show=providers "$MAIN_LOCATION" >> "$tmpfile"

if [ -f "$GENDOC_SCRIPT_LOCATION/RE-INPUT.md" ]
then
  cat "$GENDOC_SCRIPT_LOCATION/PRE-INPUT.md" >> "$tmpfile" 
fi

terraform-docs markdown table --show=inputs "$MAIN_LOCATION" >> "$tmpfile"

if [ -f "$GENDOC_SCRIPT_LOCATION/PRE-OUTPUT.md" ]
then
  cat "$GENDOC_SCRIPT_LOCATION/PRE-OUTPUT.md" >> "$tmpfile" 
fi

terraform-docs markdown table --show=outputs "$MAIN_LOCATION" >> "$tmpfile"

if [ -f "$GENDOC_SCRIPT_LOCATION/FOOTER.md" ]
then
  cat "$GENDOC_SCRIPT_LOCATION/FOOTER.md" >> "$tmpfile" 
fi

echo "The content of this file has been generated on $(date)" >> "$tmpfile"

cat "$tmpfile"

rm -f "$tmpfile"

