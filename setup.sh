#!/bin/bash

ROOT_DIR=""

if [ $# -eq 1 ]; then
    ROOT_DIR="$1"
else
    echo "Usage: $0 <download_directory>"
    exit 1
fi

read -p "Do you want to delete the temporary files after each extraction? (y/n): " remove_temp

echo "Creating the directory structure..."
mkdir -p "$ROOT_DIR/images"
mkdir -p "$ROOT_DIR/images/train"
mkdir -p "$ROOT_DIR/images/val"
mkdir -p "$ROOT_DIR/images-temp/train"
mkdir -p "$ROOT_DIR/images-temp/val"
mkdir -p "$ROOT_DIR/labels"

echo "Downloading train images..."
wget -c -i images-train.txt -P "$ROOT_DIR/images-temp/train"
echo "  Done"

echo "Downloading validation images..."
wget -c -i images-val.txt -P "$ROOT_DIR/images-temp/val"
echo "  Done"

echo "Extracting train images..."
for file in "$ROOT_DIR/images-temp/train"/*.tar.gz; do
    echo "  Extracting $file"
    tar -xzf "$file" -C "$ROOT_DIR/images/train"
    echo "    Done."

    if [ "$remove_temp" == "y" ] || [ "$remove_temp" == "Y" ]; then
        rm "$file"
        echo "  $file deleted"
    fi
done

echo "Extracting validation images..."
for file in "$ROOT_DIR/images-temp/val"/*.tar.gz; do
    echo "  Extracting $file"
    tar -xzf "$file" -C "$ROOT_DIR/images/val"
    echo "    Done."

    if [ "$remove_temp" == "y" ] || [ "$remove_temp" == "Y" ]; then
        rm "$file"
        echo "  $file deleted."
    fi
done

echo "Setting up train images..."
find "$ROOT_DIR/images/train" -name "*.jpg" -exec mv -t "$ROOT_DIR/images/train" {} +
echo "  Done."

echo "Setting up validation images..."
find "$ROOT_DIR/images/val" -name "*.jpg" -exec mv -t "$ROOT_DIR/images/val" {} +
echo "  Done."

echo "Downloading train labels..."
wget -c "https://github.com/rendicahya/objects365/raw/main/labels-train.zip" -O labels-train.zip
echo "  Done"

echo "Downloading validation labels..."
wget -c "https://github.com/rendicahya/objects365/raw/main/labels-val.zip" -O labels-val.zip
echo "  Done"

echo "Removing empty directories..."
find "$ROOT_DIR/images/train" -type d -empty -delete
find "$ROOT_DIR/images/val" -type d -empty -delete
echo "  Done."

echo "Extracting train labels..."
unzip -qq labels-train.zip -d labels
echo "  Done."

echo "Extracting validation labels..."
unzip -qq labels-val.zip -d labels
echo "  Done."

echo "Counting train images..."
num_train_img=$(find "$ROOT_DIR/images/train" -type f -name "*.jpg" | wc -l)
size_train_img=$(du -sh "$ROOT_DIR/images/train" | cut -f 1)
echo "  Done."

echo "Counting validation images..."
num_val_img=$(find "$ROOT_DIR/images/val" -type f -name "*.jpg" | wc -l)
size_val_img=$(du -sh "$ROOT_DIR/images/val" | cut -f 1)
echo "  Done."

echo "Counting train labels..."
num_train_lbl=$(find "$ROOT_DIR/labels/train" -type f -name "*.txt" | wc -l)
size_train_lbl=$(du -sh "$ROOT_DIR/labels/train" | cut -f 1)
echo "  Done."

echo "Counting validation labels..."
num_val_lbl=$(find "$ROOT_DIR/labels/val" -type f -name "*.txt" | wc -l)
size_val_lbl=$(du -sh "$ROOT_DIR/labels/val" | cut -f 1)
echo "  Done."

if [ "$remove_temp" == "y" ] || [ "$remove_temp" == "Y" ]; then
    echo "Deleting the temporary directories..."
    rm -rf "$ROOT_DIR/images-temp"
    echo "  Done."
else
    echo "Temporary directories not deleted."
fi

echo "[SUMMARY]"
echo "$num_train_img train images. Total size: $size_train_img"
echo "$num_val_img val images. Total size: $size_val_img"
echo "$num_train_lbl train labels. Total size: $size_train_lbl"
echo "$num_val_lbl val labels. Total size: $size_val_lbl"
