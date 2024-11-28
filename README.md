
# Documentation: `create_user_with_permissions.sh`

## Purpose

The `create_user_with_permissions.sh` script is designed to:
1. Create a new user with:
   - A home directory.
   - The default Bash shell.
2. Set permissions such that:
   - The new user cannot access the files or directories of the main user.
   - The main user has full access to all files and directories of the new user.
3. Synchronize the contents of the `Example` directory from the main user's home directory to the new user's `Example` directory. Any existing files in the new user's `Example` directory are replaced with those from the main user.

---

## Key Features

- **Flexible User Specification**: Allows dynamic specification of the new user and the main user as command-line arguments.
- **Permission Management**:
  - Ensures that the new user's files are private except for access granted to the main user.
  - Restricts the new user from accessing any files or directories of the main user.
- **Example Directory Synchronization**:
  - Uses the `rsync` command to copy files efficiently, preserving file attributes and metadata.
  - Ensures the new user's `Example` directory is an exact replica of the main user's `Example` directory.

---

## Script Overview

### Input Arguments:
- `<new_user>`: The username for the new user to be created.
- `<main_user>`: The existing username with permissions to access the new user's files.

### Functions:
- `usage`: Displays usage information and exits if the arguments are incorrect.
- `create_new_user`: Creates the new user, sets up their home directory and bash shell, and configures permissions for file access.
- `sync_Example_directory`: Copies or replaces all files in the new user's `Example` directory with those from the main user's `Example` directory, ensuring proper ownership and permissions.

### Error Handling:
- Verifies that both the new user and main user are valid.
- Checks if the main user's `Example` directory exists before attempting to synchronize.

---

## Tasks Performed

1. **User Creation**:
   - Creates the new user using `useradd` with options to generate a home directory and use the bash shell.
   - Ensures user-specific permissions:
     - New user has private access to their home directory (`chmod 755`).
     - Main user is granted full access to the new user's home directory via `setfacl`.

2. **Example Directory Synchronization**:
   - Replaces all files in the new user's `Example` directory with those from the main user's `Example` directory.
   - Ensures the new user's `Example` directory has proper ownership and permissions (`chown`).

3. **Post-Synchronization State**:
   - The new user's `Example` directory is a replica of the main user's `Example` directory.
   - Main user retains full access to the new user's home directory.

---

## How to Use

1. Save the script as `create_user_with_permissions.sh`.
2. Make the script executable:
   ```bash
   chmod +x create_user_with_permissions.sh
   ```
3. Run the script as a superuser (with `sudo`), specifying the new user and the main user:
   ```bash
   sudo bash create_user_with_permissions.sh <new_user> <main_user>
   ```
   Example:
   ```bash
   sudo bash create_user_with_permissions.sh newuser mainuser
   ```

---

## Requirements

- **Operating System**: Ubuntu-based systems.
- **Permissions**: The script must be executed with superuser privileges (`sudo`).
- **Preconditions**:
  - The main user must already exist on the system.
  - The new user must not already exist on the system.

---

## Example Use Case

1. **Command**:
   ```bash
   sudo bash create_user_with_permissions.sh developer admin
   ```
2. **Outcome**:
   - A new user `developer` is created.
   - The `admin` user is granted full access to `developer`'s files.
   - All files from `/home/admin/Example` are copied to `/home/developer/Example`, overwriting existing files in `developer`'s `Example` directory.

---

## Notes

- Ensure that the `Example` directory in the main user's home contains the desired files before running the script.
- The script performs a complete replacement of files in the new user's `Example` directory, so any pre-existing files will be deleted.

---

## Contributing

If you'd like to improve this script, you can:
1. Fork the repository containing the script.
2. Make your changes.
3. Submit a pull request with a description of the improvements.

---

## License

This script is licensed under the MIT License. You can view the full text of the MIT License [here](https://opensource.org/licenses/MIT).
