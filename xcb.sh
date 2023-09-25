#!/bin/bash

VERSION="1.0.0"

verbose=false

# Function to display help message
show_help() {
  printf "Usage: $0 [-v] [content]"
  printf "  -v	Enables verbose mode."
  printf "  -h	Shows this help message."
}

# Function to print a message if verbose mode is enabled
print_message() {
  if [ "$verbose" = true ]; then
    printf >&2 "$1"
  fi
}

# Function to check if a command exists
command_exists () {
  command -v "$1" &> /dev/null ;
}

# Function to set the clipboard content
set_clipboard() {
  if command_exists qdbus && qdbus org.kde.klipper /klipper org.kde.klipper.klipper.setClipboardContents "$1" > /dev/null 2>&1; then
    print_message "Content copied to KDE clipboard: $1"
  elif command_exists xsel; then
    printf "$1" | xsel -i
    print_message "Content copied to clipboard using xsel: $1"
  elif command_exists xclip; then
    printf "$1" | xclip -selection clipboard
    print_message "Content copied to clipboard using xclip: $1"
  else
    printf "Neither qdbus, xsel, nor xclip were found. Clipboard not supported." >&2
    return 1
  fi
}

# Main function
while getopts "vdh" opt; do
  case "$opt" in
    v|version)
      printf "Version: $VERSION"
      ;;
    d|debug)
      verbose=true
      ;;
    h|help)
      show_help
      exit
      ;;
    \?)
      show_help
      exit 1
      ;;
  esac
done

# Shift the options and arguments
shift $((OPTIND-1))

# Check for the content either in arguments or in Stdin
if [ -n "$*" ]; then
  set_clipboard "$*"
elif [ -t 0 ]; then
  printf "No input was provided. Expecting input via stdin or as an argument.\nYou may get some assistance running: xcb --help" >&2
else
  set_clipboard "$(cat)"
fi

