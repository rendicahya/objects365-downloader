#!/bin/bash

ROOT_DIR="/path/to/root/directory"

echo "Creating the directory structure..."
mkdir -p "$ROOT_DIR/images"
mkdir -p "$ROOT_DIR/images/train"
mkdir -p "$ROOT_DIR/images/val"
mkdir -p "$ROOT_DIR/images-temp/train"
mkdir -p "$ROOT_DIR/images-temp/val"

echo "Downloading train images..."
wget -i images-train.txt -P "$ROOT_DIR/images-temp/train"

echo "Downloading validation images..."
wget -i images-val.txt -P "$ROOT_DIR/images-temp/val"

echo "Extracting train images..."
for file in "$ROOT_DIR/images-temp/train/*.tar.gz"; do
    tar -xzf "$file" -C "$ROOT_DIR/images/train"
done

echo "Extracting validation images..."
for file in "$ROOT_DIR/images-temp/val/*.tar.gz"; do
    tar -xzf "$file" -C "$ROOT_DIR/images/val"
done

echo "Moving train images..."
find "$ROOT_DIR/images/train" -name "*.jpg" -exec mv -t "$ROOT_DIR/images/train" {} +

echo "Moving validation images..."
find "$ROOT_DIR/images/val" -name "*.jpg" -exec mv -t "$ROOT_DIR/images/val" {} +

num_train=$(find "$ROOT_DIR/images/train" -type f -name "*.jpg" | wc -l)
num_val=$(find "$ROOT_DIR/images/val" -type f -name "*.jpg" | wc -l)

size_train=$(du -sh "$ROOT_DIR/images/train" | cut -f 1)
size_val=$(du -sh "$ROOT_DIR/images/val" | cut -f 1)

echo "Downloaded $num_train train images. Total size: $size_train"
echo "Downloaded $num_val val images. Total size: $size_val"

read -p "Do you want to delete the temporary directories? (y/n): " choice

if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
    echo "Deleting the temporary directories..."
    rm -rf "$ROOT_DIR/images-temp"
    echo "Temporary directories deleted."
else
    echo "Temporary directories not deleted."
fi
