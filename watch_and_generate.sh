#!/bin/bash

# Instructions:
# Install inotify-tools and plantuml
# sudo apt install inotify-tools
# sudo apt install plantuml
# Make the script executable
# chmod +x watch_and_generate.sh

SOURCE_DIR="./puml"
TARGET_DIR="./diagrams"

# Function to process PUML files
process_file() {
    FILENAME=$(basename "$1")
    plantuml -o "$TARGET_DIR" "$1"
    echo "Generated diagram for $FILENAME"
}

export -f process_file
export TARGET_DIR

# Monitoring the source directory for new or modified .puml files
inotifywait -m -e close_write -e moved_to --format "%w%f" "$SOURCE_DIR" | while read FILE
do
    if [[ "$FILE" =~ \.puml$ ]]; then
        process_file "$FILE"
    fi
done
