#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 <new_user> <main_user>"
    echo "  <new_user>  : The username for the new user to be created."
    echo "  <main_user> : The existing username with access to the new user's files."
    exit 1
}

# Function to create a new user with a home directory and bash shell
create_new_user() {
    local new_user="$1"
    local main_user="$2"

    # Check if the main user exists
    if ! id "$main_user" &>/dev/null; then
        echo "Error: Main user '$main_user' does not exist."
        exit 1
    fi

    # Check if the new user already exists
    if id "$new_user" &>/dev/null; then
        echo "Error: New user '$new_user' already exists."
        exit 1
    fi

    # Create the new user with a home directory and bash shell
    sudo useradd --home --shell /bin/bash "$new_user"

    # Set permissions: main user has full access, new user restricted
    sudo chmod 700 /home/"$main_user"
    sudo chmod 755 /home/"$new_user"
    sudo setfacl --modify u:"$main_user":rwx /home/"$new_user"
    sudo setfacl --modify u:"$new_user":--- /home/"$main_user"

    echo "User '$new_user' created with restricted access to main user '$main_user'."
}

# Function to replace example files from main user to new user
sync_example_directory() {
    local new_user="$1"
    local main_user="$2"

    # Check if the "example directory" exists in the main user's home
    if [[ -d /home/"$main_user"/example ]]; then
        # Replace or overwrite all files in the new user's "example directory"
        sudo rsync -a --delete /home/"$main_user"/example/ /home/"$new_user"/example/
        sudo chown -R "$new_user":"$new_user" /home/"$new_user"/example
        echo "'example directory' synchronized from '$main_user' to '$new_user'."
    else
        echo "Warning: No 'example directory' found in '$main_user's home."
    fi
}

# Main execution
# Validate input arguments
if [[ $# -ne 2 ]]; then
    usage
fi

NEW_USER="$1"
MAIN_USER="$2"

# Execute functions
create_new_user "$NEW_USER" "$MAIN_USER"
sync_example_directory "$NEW_USER" "$MAIN_USER"
