#!/bin/bash

# Author: SoDA-CNE (See No Evil) | Ð4MIΛN VΛ
# Vox Audita Perit, Littera Scripta Manet
# MIT License
# THIS PROGRAM WILL DELETE ANY FILES YOU SPECIFY
# PROVIDE THE FOLDER TO CLEAN AS THE INPUT ARGUMENT
# © May 6 2013

# UI COLORS
RED=$(tput setaf 1) # Red
GREEN=$(tput setaf 2) # Green
BLUE=$(tput setaf 4) # Blue
NORM=$(tput sgr0) # Text reset
WHITE=$(tput setaf 7) # White

# JSON FILE
json_file="data.json"

# CHECK IF JQ IS INSTALLED
if ! command -v jq &>/dev/null; then
  echo "${RED} ->> jq is NOT installed. Please install jq using your package manager."
  exit 1
fi


# READ DIRECTORY TO CLEAN
clear
if [ "$1" == "" ]; then 
    echo "${RED} ->> You forgot to enter the Directory to clean."
    printf "${RED} ->> ADD the PATH for the DIRECTORY TO CLEAN as a parameter.\n\n"
    #exit 1
    read -p "${WHITE}Directory to CLEAN? ${NORM}" dirtc
else
    dirtc=$1
    # echo "$1" for debugging
fi

echo "${RED}::WARNING::"
printf "THIS WILL REMOVE ALL SPECIFIED FILES AND CAN NOT BE UNDONE!!.\n\n"

# FILES FORMAT AND STRINGS TO REMOVE
# INITIALIZE EMPTY ARRAY
my_array=()

# CREATE TEMP FILE AND STORE
temp_file=$(mktemp)

jq -r '.stringsArray[]' "$json_file" > "$temp_file"

# READ THE JSON FILE USING JQ AND POPULATE ARRAY
while IFS= read -r line; do
  my_array+=("$line")
done < "$temp_file"

# REMOVE TEMP FILE
rm "$temp_file"

# PRINT ARRAY
echo "Current Strings to Cleaned in the Past:"
for element in "${my_array[@]}"; do
  echo "$element"
done

# exit 1 is for debugging

# ADJUST TO ADD MORE STRINGS TO ARRAY
read -p "${WHITE}Search String?: ${NORM}" strA
printf "\n"

# SAVE STRING TO JSON FILE
read -p "${WHITE}Would you like to save this string to the JSON file? [Y/N]: ${NORM}" resp
if [ "${resp}" == "Y" ] || [ "${resp}" == "y" ]; then
  jq --arg strA "$strA" '.stringsArray += [$strA]' "$json_file" > temp && mv temp "$json_file"
  echo "${GREEN}String saved to JSON file."
else
    echo "${BLUE}String not saved."
fi

read -p "${WHITE}File Format? [e.g. jpg, mp4, txt etc]: ${NORM}" fA

getresults="find "$dirtc" -type f -name *"${strA}"*"${fA}" -maxdepth 3 -print"

resultscount=$(eval "$getresults" | wc -l)
if [ $resultscount -gt 0 ]; then
    echo "Total File Count:$resultscount"
    read -p "${WHITE}View Results? [Y/N]: ${NORM}" resp
else
    echo "No Results Found!"
    exit
fi

# Check if user wants to see files
if [ $resp = "Y" ]; then
    eval "$getresults"
fi

# Check for removal readiness
read -p "${WHITE}Ready to Remove Result? [Y/N]: ${NORM}" resp

#I would like to streamline the conditional more
if [ "${resp}" == "Y" ] || [ "${resp}" == "y" ]; then
    find "$dirtc" -name *"${strA}"*"${fA}" -type f -maxdepth 3 -delete
    echo "${RED}All files were DELETED"
else
    echo "${BLUE} No Files were DELETED."
fi

exit