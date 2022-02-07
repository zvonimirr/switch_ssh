#!/usr/bin/env bash

SELECTED_SSH_KEY=""

# A function to list all the available SSH keys
function list_keys() {
    # Infinite loop
    while true; do
        clear
        echo "Available SSH keys:"
        # List all the keys in the directory that ends with .pub
        # and put them in an array
        keys=($(ls ~/.ssh/*.pub))
        # Loop through the array and print the key names
        # Set counter to 1
        counter=1
        for key in "${keys[@]}"; do
            # Get the key name from the path
            key_name=$(basename "$key")
            # Remove the .pub extension
            key_name="${key_name%.*}"
            # Print the key name
            echo "$counter) $key_name"
            # Increment the counter
            counter=$((counter+1))
        done
        # Pick a key
        printf "Pick a key: "
        read -r key_number
        # Check if the key number a valid number
        if [[ $key_number =~ ^[0-9]+$ ]]; then
            # Check if the key number is in the range of the keys
            if [[ $key_number -ge 1 && $key_number -le ${#keys[@]} ]]; then
                # Get the key name from the array
                key_name=$(basename "${keys[$((key_number-1))]}")
                # Remove the .pub extension
                key_name="${key_name%.*}"
                # Set the selected key
                SELECTED_SSH_KEY="$key_name"
                # Break the loop
                break
            fi
        fi
    done
}

# Get a list of keys
list_keys
# Start SSH agent
eval "$(ssh-agent -s)"
# Add the SSH key
ssh-add ~/.ssh/$SELECTED_SSH_KEY