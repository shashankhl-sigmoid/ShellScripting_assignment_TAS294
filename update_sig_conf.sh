#!/bin/bash

validate_input() {
    input="$1"
    allowed="$2"
    if [[ ! " $allowed " =~ " $input " ]]; then
        echo "Invalid input. Allowed options are: $allowed"
        exit 1
    fi
}

validate_count() {
    count="$1"
    if [[ ! "$count" =~ ^[0-9]$ ]]; then
        echo "Invalid count. Please enter a single digit number (0-9)."
        exit 1
    fi
}

echo "Please enter the Component Name [INGESTOR/JOINER/WRANGLER/VALIDATOR]:"
read -r component_name
validate_input "$component_name" "INGESTOR JOINER WRANGLER VALIDATOR"

echo "Please enter the Scale [MID/HIGH/LOW]:"
read -r scale
validate_input "$scale" "MID HIGH LOW"

echo "Please enter the View [Auction/Bid]:"
read -r view
validate_input "$view" "Auction Bid"

echo "Please enter the Count (single digit number 0-9):"
read -r count
validate_count "$count"

if [[ "$view" == "Auction" ]]; then
    view_name="vdopiasample"
else
    view_name="vdopiasample-bid"
fi

new_line="$view ; $scale ; $component_name ; ETL ; $view_name-etl= $count"

echo "The new configuration line to be inserted is:"
echo "$new_line"

update_line_in_file() {
    file="$1"
    new_line="$2"

    sed -i "0,/;/{s|.*|$new_line|;b}" "$conf_file"
}

conf_file="sig.conf"

if [[ ! -f "$conf_file" ]]; then
    echo "Configuration file '$conf_file' not found!"
    exit 1
fi

update_line_in_file "$conf_file" "$new_line"

echo "Configuration updated successfully!"
