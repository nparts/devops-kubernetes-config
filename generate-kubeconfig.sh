#!/bin/bash

# Usage: ./generate_kubeconfig.sh -n <number_of_groups> -c <cluster_url> [-t <template_file>] [-o <output_dir>] [-d] [-f]
# Example: ./generate_kubeconfig.sh -n 3 -c https://example-cluster-url:6443 -t kubeconfig.template -o ./output-kubeconfig/ -d -f

# Default values
number_of_groups=1
cluster_url=""
template_file="./kubeconfig.template"
output_dir="./output-kubeconfig/"
create_dir=false
force_overwrite=false

# Check if microk8s is installed
if ! command -v microk8s &> /dev/null; then
    echo "microk8s could not be found. Please install it to continue."
    exit 1
fi

# Parse arguments
while getopts "n:c:t:o:df" opt; do
  case $opt in
    n) number_of_groups=$OPTARG ;;
    c) cluster_url=$OPTARG ;;
    t) template_file=$OPTARG ;;
    o) output_dir=$OPTARG ;;
    d) create_dir=true ;;
    f) force_overwrite=true ;;
    *) echo "Usage: $0 -n <number_of_groups> -c <cluster_url> [-t <template_file>] [-o <output_dir>] [-d] [-f]"
       exit 1 ;;
  esac
done

# Validate necessary inputs
if [ -z "$cluster_url" ]; then
  echo "Error: cluster_url is required."
  echo "Usage: $0 -n <number_of_groups> -c <cluster_url> [-t <template_file>] [-o <output_dir>] [-d] [-f]"
  exit 1
fi

if [ ! -f "$template_file" ]; then
    echo "Error: Template file '$template_file' does not exist."
    exit 1
else
    echo "Template file '$template_file' found, proceeding with the operation."
fi

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
if [[ $number_of_groups -lt 1 || $number_of_groups -gt 99 ]]; then
    echo "Number of groups must be between 1 and 99."
    exit 1
fi

# Read CA data
ca_data=$(microk8s kubectl config view --raw | grep 'certificate-authority-data' | awk '{print $2}')

if [ -z "$ca_data" ]; then
    echo "Error: CA data could not be retrieved."
    exit 1
fi

# Generate kubeconfig files for each group
for ((i=1; i<=number_of_groups; i++)); do
  group_number=$(printf "%02d" $i)
  # Fetch token dynamically
  token=$(microk8s kubectl -n group${group_number} get secret $(microk8s kubectl -n group${group_number} get sa/group${group_number} -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode)

  if [ -z "$token" ]; then
      echo "Error: Token for group${group_number} could not be retrieved."
      continue
  fi

  # Prepare the output file path
  output_file="${output_dir}kubeconfig_group${group_number}.yaml"
  
  # Check for file existence and overwrite settings
  if [ -f "$output_file" ] && [ "$force_overwrite" = false ]; then
      echo "File $output_file already exists and force overwrite is not enabled. Skipping."
      continue
  fi

  # Replace variables in template and generate config
  sed -e "s|{{group_number}}|${group_number}|g" \
      -e "s|{{cluster_url}}|${cluster_url}|g" \
      -e "s|{{ca_data}}|${ca_data}|g" \
      -e "s|{{token}}|${token}|g" \
      "$template_file" > "$output_file"
  
  echo "Generated kubeconfig for group${group_number} at $output_file"
done

echo "All applicable kubeconfig files have been generated."
