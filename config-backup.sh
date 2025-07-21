#!/bin/bash

set -e

BASE_DIR=$(dirname "$0")
LAB_NAME=$2

if [ -z "$LAB_NAME" ]; then
  echo "Usage: $0 {backup|restore} <lab-name>"
  exit 1
fi

CLAB_DIR=$(find "$BASE_DIR/bgp" -type d -name "clab-$LAB_NAME" | head -n 1)

if [ -z "$CLAB_DIR" ]; then
  echo "Lab directory for '$LAB_NAME' not found in bgp!"
  exit 1
fi

CONFIG_DIR="$BASE_DIR/config-backup/${LAB_NAME}"

case "$1" in
  backup)
    echo "Backing up startup-config files for lab: $LAB_NAME"
    mkdir -p "$CONFIG_DIR"

    find "$CLAB_DIR" -type f -path "*/flash/startup-config" | while read -r file; do
      node_dir=$(dirname "$(dirname "$file")")
      node_name=$(basename "$node_dir")
      dest_dir="$CONFIG_DIR/$node_name"
      mkdir -p "$dest_dir"
      cp "$file" "$dest_dir/startup-config"
      echo "Saved $file → $dest_dir/startup-config"
    done
    ;;

  restore)
    echo "Restoring startup-config files for lab: $LAB_NAME"
    if [ ! -d "$CONFIG_DIR" ]; then
      echo "Config directory does not exist: $CONFIG_DIR"
      exit 1
    fi

    find "$CONFIG_DIR" -type f -name "startup-config" | while read -r file; do
      node_name=$(basename "$(dirname "$file")")
      dest_file="$CLAB_DIR/$node_name/flash/startup-config"
      cp "$file" "$dest_file"
      echo "Restored $file → $dest_file"
    done
    ;;

  *)
    echo "Usage: $0 {backup|restore} <lab-name>"
    exit 1
    ;;
esac
