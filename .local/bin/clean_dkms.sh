#!/bin/bash

# Check if dkms is installed
if ! command -v dkms &> /dev/null; then
    echo "Error: dkms is not installed. Please install it and try again."
    exit 1
fi

# Array to track removed modules
removed_modules=()

# Fetch all module information from dkms status
dkms_status=$(dkms status)

if [[ -z "$dkms_status" ]]; then
    echo "No DKMS modules found to clean up."
    exit 0
fi

# Process each unique module and version
echo "$dkms_status" | awk -F, '{print $1}' | sort | uniq | while read -r module_version; do
    # Extract module name and version
    module_name=$(echo "$module_version" | awk -F/ '{print $1}')
    module_version_number=$(echo "$module_version" | awk -F/ '{print $2}')

    # Get all kernel versions for this module and version
    kernel_versions=$(echo "$dkms_status" | grep "^$module_name/$module_version_number," | awk -F, '{print $2}' | awk '{print $1}' | sort -V)

    if [[ -z "$kernel_versions" ]]; then
        echo "No kernel versions found for module $module_name/$module_version_number. Skipping..."
        continue
    fi

    # Determine the latest kernel version
    latest_kernel_version=$(echo "$kernel_versions" | tail -n 1)

    echo "Processing module: $module_name/$module_version_number"
    echo "Latest kernel version: $latest_kernel_version"

    # Loop through all kernel versions and remove older ones
    for kernel_version in $kernel_versions; do
        if [[ "$kernel_version" != "$latest_kernel_version" ]]; then
            echo "Removing $module_name/$module_version_number for kernel $kernel_version..."
            sudo dkms remove -m "$module_name" -v "$module_version_number" -k "$kernel_version"
            if [[ $? -eq 0 ]]; then
                removed_modules+=("$module_name/$module_version_number for kernel $kernel_version")
            else
                echo "Error removing $module_name/$module_version_number for kernel $kernel_version. Manual intervention may be required."
            fi
        fi
    done
done

# Summary of removed modules
if [[ ${#removed_modules[@]} -gt 0 ]]; then
    echo -e "\nModules and versions removed during cleanup:"
    for removed in "${removed_modules[@]}"; do
        echo "$removed"
    done
else
    echo "No modules were removed."
fi

echo "DKMS cleanup complete."

