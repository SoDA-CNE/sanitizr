#!/bin/bash
# Author: SoDA-CNE (See No Evil) | ÐAMIAN VΛ
# THIS PROGRAM WILL DELETE ANY FILES YOU SPECIFY
# PROVIDE THE FOLDER TO CLEAN AS THE INPUT ARGUMENT
# May 6 2013

# UI COLORS
RED=$(tput setaf 1) # Red
GREEN=$(tput setaf 2) # Green
BLUE=$(tput setaf 4) # Blue
NORM=$(tput sgr0) # Text reset
WHITE=$(tput setaf 7) # White

# READ DIRECTORY TO CLEAN
clear
if [ $1 == "" ]; then # condition could also use [ -n $1 ] to check if the argument was passed
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

: '
Would like to create an array of search items to automatically
search for as the users storage. The user may then append or remove
from that array/json data file as they wish.
' 

#Files, Format, and String to Remove
read -p "${WHITE}Search String?: ${NORM}" strA
printf "\n"
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