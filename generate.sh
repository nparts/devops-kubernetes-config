#!/bin/bash

# Default values
template_dir="./templates/"
output_dir="./output/"
num_groups=1
create_dir=false
force_overwrite=false

# Function to ensure output directory ends with a slash
ensure_trailing_slash() {
    [[ "$1" != */ ]] && echo "$1"/ || echo "$1"
}

# Parse command-line arguments
while getopts "t:d:n:cf" opt; do
    case ${opt} in
        t ) template_dir=$(ensure_trailing_slash "$OPTARG") ;;
        d ) output_dir=$(ensure_trailing_slash "$OPTARG") ;;
        n ) num_groups=$OPTARG ;;
        c ) create_dir=true ;;
        f ) force_overwrite=true ;;
        ? ) echo "Usage: cmd [-t template_directory] [-d output_directory] [-n number_of_groups] [-c] [-f]" ;;
    esac
done

# Check if directory exists, is writable, and prompt to create if not
if [ ! -d "$output_dir" ]; then
    if [ "$create_dir" = true ]; then
        mkdir -p "$output_dir"
        if [ $? -ne 0 ]; then
            echo "Failed to create directory: $output_dir"
            exit 1
        fi
    else
        echo "Directory does not exist: $output_dir. Use -c option to create it."
        exit 1
    fi
elif [ ! -w "$output_dir" ]; then
    echo "Directory is not writable: $output_dir"
    exit 1
fi

# Validate number of groups
if [[ $num_groups -lt 1 || $num_groups -gt 99 ]]; then
    echo "Number of groups must be between 1 and 99."
    exit 1
fi

# Check for existing files and -f option
check_and_write() {
    local file=$1
    local content=$2
    if [[ -f "$file" && $force_overwrite != true ]]; then
        echo "File $file already exists. Use -f to overwrite."
        exit 1
    fi
    echo "$content" > "$file"
}

# Process each template file
for template in $(find "$template_dir" -maxdepth 1 -name '*-template.yaml'); do
    base_name=$(basename "$template" "-template.yaml")
    # Loop to create RoleBinding files for each group number
    for i in $(seq -w 1 $num_groups); do
        output_file="${output_dir}${base_name}-group${i}.yaml"
        if [[ -f "$output_file" && $force_overwrite != true ]]; then
            echo "File $output_file already exists. Use -f to overwrite."
            continue
        fi
        # Replace placeholders and create the file
        sed "s/{{ group_number }}/${i}/g" "$template" > "$output_file"
        echo "Generated $output_file"
    done
done

# Final permissions adjustment, if needed
chmod 600 "${output_dir}"*.yaml
