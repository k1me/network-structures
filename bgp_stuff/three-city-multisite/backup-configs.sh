#!/bin/bash

BASE_DIR=$(dirname "$0")
CONFIG_DIR="$BASE_DIR/config"
CLAB_DIR="$BASE_DIR/clab-bgp-multisite-network"

case "$1" in
  backup)
    echo "Backing up startup-config files..."
    mkdir -p "$CONFIG_DIR"
    find "$CLAB_DIR" -type f -path "*/flash/startup-config" | while read -r file; do
      node_dir=$(dirname "$(dirname "$file")") # node mappa pl. clab-bgp-multisite-network/bud-r1
      node_name=$(basename "$node_dir")
      dest_dir="$CONFIG_DIR/$node_name"
      mkdir -p "$dest_dir"
      cp "$file" "$dest_dir/startup-config"
      echo "Saved $file to $dest_dir/startup-config"
    done
    ;;

  restore)
    echo "Restoring startup-config files..."
    if [ ! -d "$CONFIG_DIR" ]; then
      echo "Config directory does not exist!"
      exit 1
    fi
    find "$CONFIG_DIR" -type f -name "startup-config" | while read -r file; do
      node_name=$(basename "$(dirname "$file")")
      dest_file="$CLAB_DIR/$node_name/flash/startup-config"
      cp "$file" "$dest_file"
      echo "Restored $file to $dest_file"
    done
    ;;

  *)
    echo "Usage: $0 {backup|restore}"
    exit 1
    ;;
esac